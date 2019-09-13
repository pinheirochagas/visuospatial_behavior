function EglyDriverLBCN
%% EglyDriver Task
% LBCN - Stanford University 2019
% Pedro Pinheiro-Chagas and Su Liu
% Adapted from Manoj Eradath

sca;
close all;
clearvars;

% define adjustments
adj_hard = 0.3;
adj_easy = 0.3;
ntrials_adj_hard = 2;
ntrials_adj_easy = 1;

targ_contrast = 250; %251 211
define_trial_type = 'Exo';
sub_ID = input('Sub Name: ','s');
block = input('Block Number (1-4) : ','s');
filename = [sprintf('Data_%s_%d', sub_ID, str2num(block)), '.', datestr(now,'dd.mm.yyyy.HH.MM'),'.mat'];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
RTBox('clear');
RTBox('TTLWidth', .02);
RTBox('enable','light');
ntrials = 60; %ntrials=251;

Screen('Preference', 'SkipSyncTests', 1);
screens = Screen('Screens');
screenNumber = max(screens);
WhiteC= [255 255 255]; grey = [128 128 128 ]; BlackC = [0 0 0]; RedC = [255 0 0];GreenC = [0 255 0];BlueC = [0 0 255];CyanC = [0 255 255];
[window, windowRect] = Screen('OpenWindow', screenNumber, grey);
%[window, windowRect] = Screen('OpenWindow', screenNumber, grey,[0 0 700 450]);%%Not full screen in debug mode
ifi = Screen('GetFlipInterval', window);
topPriorityLevel = MaxPriority(window);
Priority(topPriorityLevel);
KbName('UnifyKeyNames');
[id, names]  = GetKeyboardIndices;
dev_id = -1;
full_data = nan(ntrials,16);
ListenChar(2);
% HideCursor;
WaitSecs(5)
%% Generage tabels of stimulus parameters
[TB1, TB2] = gen_stim_event(define_trial_type);%TB1: catch tial (1/10 of the trials); TB2: Trials with target
EDDM_StimScript_Ver1_sori_pointer;
StimEglyDriverEBS;
%% Main Experiment loop
vbl_all = zeros(ntrials, 5);
for i = 1 : ntrials
    response = 0;
    response_time = 0;
    error_type = 0;
    targ_type = 0;
    is_targ = 0;
    display(targ_contrast)
    EDDM_StimScript_Ver1_sori_pointer;
    quislist = 0;
    expt_startime = GetSecs;
    while ((GetSecs - expt_startime)*1000) < slist.total_time(i)
        [keyIsDown,Secs, keycode1] = KbCheck(dev_id);
        %% quitting the task, if needed (not working for mac)
        if ~isempty(find(keycode1, 1)) && ((find(keycode1)==27 && slist(i).catchtrials == 1) || (find(keycode1)==41 && slist(i).catchtrials == 2)) %
            quislist=1;
            ListenChar(0);
            ShowCursor;
            sca;
            %Screen('CloseAll');
            fprintf('\n#-----------------------#Pressed Esc Session Aborted #----------------------------------#\n')
            %save(filename,'full_data')
            return
        else
            intervals = [slist.int_fix_time(i) slist.int_fix_bar_time(i)...
                int_cue_time slist.int_cue_targ_time(i) int_targ_time];
            colors = {allColors_VB1 slist.color1{i} allColors_VB1 ...
                allColors_VB1 allColors_VB1};
            positions = {slist.Fixsq1{i}(:,2:end) slist.Fixsq1{i} slist.Fixsq1{i}(:,2:end)...
                slist.Fixsq1{i}(:,2:end) slist.Fixsq1{i}(:,2:end)};
            is_targ = 0;
            targ_type = slist.targ_pos(i);
            if slist.catchtrials(i) == 2
                colors{4} = slist.color2{i};
                positions{4} = slist.Fixsq2{i};
                is_targ = 1;
            end
            %% Show fixation, bar, cue
            vbl0=Screen('Flip', window );
            Screen('FillRect', window, allColors, Fix);
            vbl=Screen('Flip', window, vbl0 + (ifi));
            for j = 1:5
                Screen('FillRect', window, colors{j}, positions{j});
                vbl = Screen('Flip', window, vbl +  (intervals(j)/1000));
                vbl_all(i,j) = vbl;
                RTBox('clear');
                RTBox('TTL',8)
                if j == 3 %After the cue is shown, check for early press
                    % decide weathe or not to stimulate
                    set_zero = GetSecs - vbl;
                    flag = 0;
                    while (((GetSecs - vbl)) < ((slist.stim_onset(i)) + 10)/1000 && flag ==0) % CHECK THE UNIT SEC OR MS
                        if ((GetSecs - vbl)) >= (slist.stim_onset(i)/1000)
                            RTBox('clear');
                            RTBox('TTL',slist.TTL(i,j));
                            display('stim')
                            flag = 1;
                        end
                    end
                    
                    while ((GetSecs - vbl)) < (slist.int_cue_targ_time(i)/1000)
                        [keyIsDown,Secs, keycode] = KbCheck(dev_id);
                        if find(keycode) == 32%space; orinal 32
                            response = 0;
                            response_time = 0;
                            error_type = 1; % Early bar press before target onset
                        end
                    end
                end
            end
            while ((GetSecs - vbl)*1000 ) < int_resp_time
                [keyIsDown,Secs, keycode] = KbCheck(dev_id);
                if slist.catchtrials(i) == 1
                    if isempty(find(keycode, 1))== 1
                        response = 1;
                        response_time=(GetSecs-vbl)*1000;
                        error_type = 5; % No target (catch trials), no press, no error
                    end
                    if ~isempty(find(keycode, 1)) && find(keycode) == 32%32
                        response = 0;
                        error_type = 6; % False alarm Bar press during response time, no target catch trials
                        response_time=(GetSecs-vbl)*1000;
                    end
                else
                    if ~isempty(find(keycode, 1)) && error_type ~= 1 %&&find(keycode)== 32
                        response = 1;
                        response_time = (GetSecs-vbl)*1000;
                        error_type = 5; % No error,Correct response
                        if response_time < 100
                            response = 0;
                            error_type = 2; % hitting within 100ms of target onset,late 1 error
                        end
                        
                        if response_time > int_resp_time_max
                            response = 0;
                            error_type = 3; % Late error, no key press within response time window,late 2 error
                        end
                    end
                    if isempty(find(ismember(1:6,error_type), 1))
                        response=0;
                        response_time=0;
                        error_type = 7; %No key press, essentially same as late 3 error
                    end
                end
            end
            %%%%%%%%%%%%%%%%
            Screen('FillRect', window, grey);
            vbl = Screen('Flip', window, vbl +  (int_resp_time/1000) + (0.5*ifi));
            Screen('FillRect', window, grey);
            vbl = Screen('Flip', window, vbl +  (int_ITI/1000) + (0.5*ifi));
            end_time = GetSecs;
            total_trial_time = round((end_time - expt_startime)*1000);
        end
    end
    
    slist.targ_type(i) = targ_type;
    slist.response(i) = response;
    slist.response_time(i) = response_time;
    slist.error_type(i) = error_type;
    slist.is_targ(i) = is_targ;
    slist.total_trial_time(i) = total_trial_time;
    slist.targ_contrast(i) = targ_contrast;
    
    if i > 4
        respmat=slist.response(1:i);
        if sum(respmat(end-ntrials_adj_hard:end)==length(respmat(end-ntrials_adj_hard:end)))
            targ_contrast = targ_contrast + adj_hard;
        elseif sum(respmat(end-ntrials_adj_easy:end)==0)
            targ_contrast = targ_contrast - adj_easy;
        end
    end
    
    if i == ntrials
        slist.stimulus_onset_time = vbl_all;
        save(fullfile('Data',filename),'slist');
        ListenChar(0);
        ShowCursor;
        Screen('CloseAll'); % close any open screens/windows
        sca;
        return
    end
end

end
