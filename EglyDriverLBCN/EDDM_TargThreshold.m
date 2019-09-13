%%% For detecting the target contrast threshold of the subject
%%% Adjust the screen parameters (p_mon_width, p_mon_height, p_v_dist) based on the local screen before running
%%% Task:
%%%             Subject is required to keep the fixation at the center white square throughout the trial duration,
%%%             A white cue will appear on one of the 4 bar ends. A contrast dimming will occur as target at the cued bar end
%%%             follwoing a variable delay. Subject is required to press the space bar as soon as possible after the target contrast dimming.
%%% The script will adjust the level of target contrast based on the subject's performance. The script will plot the performanced based
%%% contrast modification and the final output of the script - targ_contrast- is to be entered into the main experiment script - MGA_Ver4.m

%%% Manoj Eradath, Princeton Neuroscience Institute, 05/2016
% Adapted to LBCN - Stanford by Pedro Pinheiro-Chagas
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sca;
close all;
clearvars;
targ_contrast = 237;

sub_ID = input('Sub Name: ','s');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
try
    Screen('Preference', 'SkipSyncTests', 1);
    screens = Screen('Screens');
    screenNumber = max(screens);
    WhiteC= [255 255 255]; grey = [128 128 128 ]; BlackC = [0 0 0]; RedC = [255 0 0];GreenC = [0 255 0];BlueC = [0 0 255];CyanC = [0 255 255];
    [window, windowRect] = Screen('OpenWindow', screenNumber, grey);
    ifi = Screen('GetFlipInterval', window);
    topPriorityLevel = MaxPriority(window);
    Priority(topPriorityLevel);
    KbName('UnifyKeyNames');
    [id names]  = GetKeyboardIndices; dev_id = -1;
    full_data=[];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Variables
    nt=1; ntrials=40;
    ListenChar(2);
    HideCursor;
    % Main Task for Threshold detection
    WaitSecs(5)
    while nt < ntrials
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % setting up stimuli paremeters
        [screenXpixels, screenYpixels] = Screen('WindowSize', window);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Physical screen dimensions
        %ScreenDPI= 109 ;  % DPI display screen (iMac27)
        ScreenDPI= 120 ;  % DPI display screen (parvizi testing laptop)
        set(0,'units','pixels');
        Pix_SS=get(0,'screensize');
        p_mon_width=(Pix_SS(3)*2.54)/ScreenDPI;
        p_mon_height=(Pix_SS(4)*2.54)/ScreenDPI;
        p_v_dist_Confactor=66/55; % conversion factor for p_v_dist, taken from control script
        p_v_dist = p_mon_width*p_v_dist_Confactor; %viewing distance
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        pix_per_deg  = pi * windowRect(3) / atan(p_mon_width/p_v_dist/2) / 360; % pixels per degree
        centerX = windowRect(3)/2;  centerY = windowRect(4)/2;
        VbarL = 2.0* pix_per_deg;VbarW = 12 * pix_per_deg;
        HbarL = 12* pix_per_deg;HbarW = 2.0 * pix_per_deg;
        CFixL = 0.7 * pix_per_deg;CFixW = 0.7 *pix_per_deg;
        CueL = 2.5 * pix_per_deg; CueW = 2.5 * pix_per_deg;
        TarL = 1.8 * pix_per_deg; TarW = 1.8 * pix_per_deg;
        BardistCoversionFact=6/55; % Bar distance from center conversion factor taken from control script
        BarDistFromCenter = BardistCoversionFact*p_mon_width; %(in cm )
        Xleft=(0.5 - (BarDistFromCenter/p_mon_width));
        Xright=(0.5 + (BarDistFromCenter/p_mon_width));
        Ytop=(0.5 - (BarDistFromCenter/p_mon_height));
        Ybot=(0.5 + (BarDistFromCenter/p_mon_height));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % fixation square to begin with
        fixSq=[ 0 0 CFixL CFixW];
        squareXpos = [screenXpixels * 0.5 ];
        squareYpos = [screenYpixels * 0.5 ];
        allColors = [WhiteC];
        Fix = CenterRectOnPointd_sori(fixSq, squareXpos, squareYpos);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% Fixation
        % fixation square with vertical bars
        fixSqVB1 = [[0 0 VbarL VbarW]' [0 0 CFixL CFixW]' [0 0 VbarL VbarW]'];
        squareXpos1 = [screenXpixels * Xleft  screenXpixels * 0.5  screenXpixels * Xright];
        squareYpos1 = [screenYpixels * 0.5 screenYpixels * 0.5 screenYpixels * 0.5 ];
        allColors_VB = [WhiteC' WhiteC' WhiteC'];
        FixsqVB = CenterRectOnPointd_sori(fixSqVB1, squareXpos1, squareYpos1);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % fixation square with vertical bars topleft cue
        FixSqVB_TLC1 = [[0 0 CueL CueW]' [0 0 VbarL VbarW]' [0 0 CFixL CFixW]' [0 0 VbarL VbarW]' ];
        squareXpos3 = [screenXpixels * Xleft screenXpixels * Xleft  screenXpixels * 0.5  screenXpixels * Xright ];
        squareYpos3 = [screenYpixels * Ytop screenYpixels * 0.5 screenYpixels * 0.5 screenYpixels * 0.5 ];
        allColors1  = [BlackC' WhiteC'  WhiteC'  WhiteC' ];
        FixSqVB_TLC   = CenterRectOnPointd_sori(FixSqVB_TLC1, squareXpos3, squareYpos3);
        % fixation square with vertical bars bottom left cue
        FixSqVB_BLC1 = [[0 0 CueL CueW]' [0 0 VbarL VbarW]' [0 0 CFixL CFixW]' [0 0 VbarL VbarW]' ];
        squareXpos5 = [screenXpixels * Xleft screenXpixels * Xleft  screenXpixels * 0.5  screenXpixels * Xright ];
        squareYpos5 = [screenYpixels * Ybot screenYpixels * 0.5 screenYpixels * 0.5 screenYpixels * 0.5 ];
        allColors3  = [BlackC' WhiteC'  WhiteC'  WhiteC' ];
        FixSqVB_BLC   = CenterRectOnPointd_sori(FixSqVB_BLC1, squareXpos5, squareYpos5);
        % fixation square with vertical bars topright cue
        FixSqVB_TRC1 = [[0 0 CueL CueW]' [0 0 VbarL VbarW]' [0 0 CFixL CFixW]' [0 0 VbarL VbarW]' ];
        squareXpos4 = [screenXpixels * Xright screenXpixels * Xleft  screenXpixels * 0.5  screenXpixels * Xright ];
        squareYpos4 = [screenYpixels * Ytop screenYpixels * 0.5 screenYpixels * 0.5 screenYpixels * 0.5 ];
        allColors2 = [BlackC' WhiteC'  WhiteC'  WhiteC' ];
        FixSqVB_TRC = CenterRectOnPointd_sori(FixSqVB_TRC1, squareXpos4, squareYpos4);
        % fixation square with vertical bars bottom right cue
        FixSqVB_BRC1 = [[0 0 CueL CueW]' [0 0 VbarL VbarW]' [0 0 CFixL CFixW]' [0 0 VbarL VbarW]' ];
        squareXpos6 = [screenXpixels * Xright screenXpixels * Xleft  screenXpixels * 0.5  screenXpixels * Xright ];
        squareYpos6 = [screenYpixels * Ybot screenYpixels * 0.5 screenYpixels * 0.5 screenYpixels * 0.5 ];
        allColors4  = [BlackC' WhiteC'  WhiteC'  WhiteC' ];
        FixSqVB_BRC   = CenterRectOnPointd_sori(FixSqVB_BRC1, squareXpos6, squareYpos6);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% Targets
        % fixation square with vertical bars top Left  Target
        FixSqVB_TLT1 = [ [0 0 VbarL VbarW]' [0 0 CFixL CFixW]' [0 0 VbarL VbarW]' [0 0 TarL TarW]'];
        squareXpos7 = [ screenXpixels * Xleft  screenXpixels * 0.5  screenXpixels * Xright screenXpixels * Xleft];
        squareYpos7 = [screenYpixels * 0.5 screenYpixels * 0.5 screenYpixels * 0.5 screenYpixels * (Ytop) ];
        allColors5  = [ WhiteC' WhiteC' WhiteC' [targ_contrast targ_contrast targ_contrast]'];
        FixSqVB_TLT   = CenterRectOnPointd_sori(FixSqVB_TLT1, squareXpos7, squareYpos7);
        % fixation square with vertical bars bottom left Target
        FixSqVB_BLT1 = [ [0 0 VbarL VbarW]' [0 0 CFixL CFixW]' [0 0 VbarL VbarW]' [0 0 TarL TarW]'];
        squareXpos9 = [ screenXpixels * Xleft  screenXpixels * 0.5  screenXpixels * Xright screenXpixels * Xleft];
        squareYpos9 = [screenYpixels * 0.5 screenYpixels * 0.5 screenYpixels * 0.5 screenYpixels * (Ybot) ];
        allColors7  = [ WhiteC' WhiteC' WhiteC' [targ_contrast targ_contrast targ_contrast]'];
        FixSqVB_BLT   = CenterRectOnPointd_sori(FixSqVB_BLT1, squareXpos9, squareYpos9);
        % fixation square with vertical bars topright Target
        FixSqVB_TRT1 = [ [0 0 VbarL VbarW]' [0 0 CFixL CFixW]' [0 0 VbarL VbarW]'  [0 0 TarL TarW]' ];
        squareXpos8 = [ screenXpixels * Xleft  screenXpixels * 0.5  screenXpixels * Xright screenXpixels * Xright];
        squareYpos8 = [screenYpixels * 0.5 screenYpixels * 0.5 screenYpixels * 0.5 screenYpixels * (Ytop) ];
        allColors6 = [ WhiteC' WhiteC' WhiteC' [targ_contrast targ_contrast targ_contrast]'];
        FixSqVB_TRT = CenterRectOnPointd_sori(FixSqVB_TRT1, squareXpos8, squareYpos8);
        % fixation square with vertical bars bottom right target
        FixSqVB_BRT1 = [ [0 0 VbarL VbarW]' [0 0 CFixL CFixW]' [0 0 VbarL VbarW]'  [0 0 TarL TarW]' ];
        squareXpos10 = [ screenXpixels * Xleft  screenXpixels * 0.5  screenXpixels * Xright screenXpixels * Xright];
        squareYpos10 = [screenYpixels * 0.5 screenYpixels * 0.5 screenYpixels * 0.5 screenYpixels * (Ybot)];
        allColors8  = [ WhiteC' WhiteC' WhiteC' [targ_contrast targ_contrast targ_contrast]'];
        FixSqVB_BRT   = CenterRectOnPointd_sori(FixSqVB_BRT1, squareXpos10, squareYpos10);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        datam=[];error_type=0;
        %Randomization
        int_fix_time = randi([500,1200],[1,1]);
        int_fix_bar_time = randi([500, 1200],[1,1]);
        int_cue_time = 100;
        int_cue_targ_time = randi([1000,2500],[1,1]);
        int_targ_time = 100;
        int_resp_time = 600; % response time
        %int_resp_time = 1200; % response time
        int_resp_time_max = 1200;
        rand_V_cue_pos = randi(4,[1,1]);
        quitb=0;
        trial_type = 0;
        targ_type =0;
        targ_pos = 0;
        cue_pos = 0;
        response = 0;
        response_time=0;
        total_time=(int_fix_time + int_fix_bar_time + int_cue_time + int_cue_targ_time + int_targ_time + 100)  ;
        int_ITI= 1000;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Task loop
        expt_startime = GetSecs;
        while ((GetSecs - expt_startime)*1000) < (int_fix_time + int_fix_bar_time + int_cue_time + int_cue_targ_time + int_targ_time + int_resp_time + 100)
            %quitting the task, if needed
            [keyIsDown,Secs, keycode1] = KbCheck(dev_id);
            if find(keycode1)==41 %
                quitb=1;
                ListenChar(0);
                ShowCursor;
                Screen('CloseAll');
                fprintf('\n#-----------------------#Pressed Esc Session Aborted #----------------------------------#\n')
                save(filename,'full_data')
                break
            end
            % If not quit, start of the main loop
            if quitb ~= 1
                vbl0=Screen('Flip', window );
                Screen('FillRect', window, allColors, Fix);
                vbl=Screen('Flip', window, vbl0 + (ifi));
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                Screen('FillRect', window, allColors_VB, FixsqVB);
                vbl1 = Screen('Flip', window, vbl +  (int_fix_time/1000));
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                if rand_V_cue_pos == 1 % Valid trials top left cue
                    Screen('FillRect', window, allColors1, FixSqVB_TLC);
                    vbl2 = Screen('Flip', window, vbl1 + (int_fix_bar_time/1000));
                    Screen('FillRect', window, allColors_VB, FixsqVB);
                    vbl3  = Screen('Flip', window, vbl2 +  (int_cue_time/1000));
                    while ((GetSecs - vbl3)) < (int_cue_targ_time/1000)
                        [keyIsDown,Secs, keycode] = KbCheck(dev_id);
                        if find(keycode)==32
                            response=0;
                            response_time=0;
                            error_type=1;
                            end_time = GetSecs;
                            break
                        end
                    end
                    Screen('FillRect', window, allColors5, FixSqVB_TLT );
                    vbl4  = Screen('Flip', window, vbl3 + (int_cue_targ_time/1000));
                end
                if rand_V_cue_pos == 2 % Valid trials Bottom left cue
                    Screen('FillRect', window, allColors3, FixSqVB_BLC);
                    vbl2 = Screen('Flip', window, vbl1 + (int_fix_bar_time/1000));
                    Screen('FillRect', window, allColors_VB, FixsqVB);
                    vbl3  = Screen('Flip', window, vbl2 +  (int_cue_time/1000));
                    while ((GetSecs - vbl3)) < (int_cue_targ_time/1000)
                        [keyIsDown,Secs, keycode] = KbCheck(dev_id);
                        if find(keycode)==32
                            response=0;
                            response_time=0;
                            error_type=1;
                            end_time = GetSecs;
                            break
                        end
                    end
                    Screen('FillRect', window, allColors7, FixSqVB_BLT );
                    vbl4  = Screen('Flip', window, vbl3 + (int_cue_targ_time/1000));
                end
                if rand_V_cue_pos == 3 % Valid trials Top Right cue
                    Screen('FillRect', window, allColors2, FixSqVB_TRC);
                    vbl2 = Screen('Flip', window, vbl1 + (int_fix_bar_time/1000));
                    Screen('FillRect', window, allColors_VB, FixsqVB);
                    vbl3  = Screen('Flip', window, vbl2 +  (int_cue_time/1000));
                    while ((GetSecs - vbl3)) < (int_cue_targ_time/1000)
                        [keyIsDown,Secs, keycode] = KbCheck(dev_id);
                        if find(keycode)==32 %44 for mac 32 for windows
                            response=0;
                            response_time=0;
                            error_type=1;
                            end_time = GetSecs;
                            break
                        end
                    end
                    Screen('FillRect', window, allColors6, FixSqVB_TRT );
                    vbl4  = Screen('Flip', window, vbl3 + (int_cue_targ_time/1000));
                end
                if rand_V_cue_pos == 4 % Valid trials Bottom Right cue
                    Screen('FillRect', window, allColors4, FixSqVB_BRC);
                    vbl2 = Screen('Flip', window, vbl1 + (int_fix_bar_time/1000));
                    Screen('FillRect', window, allColors_VB, FixsqVB);
                    vbl3  = Screen('Flip', window, vbl2 +  (int_cue_time/1000));
                    while ((GetSecs - vbl3)) < (int_cue_targ_time/1000)
                        [keyIsDown,Secs, keycode] = KbCheck(dev_id);
                        if find(keycode)==32
                            response=0;
                            response_time=0;
                            error_type=1;
                            end_time = GetSecs;
                            break
                        end
                    end
                    Screen('FillRect', window, allColors8, FixSqVB_BRT );
                    vbl4  = Screen('Flip', window, vbl3 + (int_cue_targ_time/1000));
                end
                Screen('FillRect', window, allColors_VB, FixsqVB);
                vbl5 = Screen('Flip', window, vbl4 +  (int_targ_time/1000));
            end
            % response Checking
            while ((GetSecs - vbl5)*1000 ) < int_resp_time
                [keyIsDown,Secs, keycode] = KbCheck(dev_id);
                if find(keycode)==32 & error_type ~= 1
                    response=1;
                    response_time=(GetSecs-vbl5)*1000;
                    error_type = 4; % No error
                    if response_time < 100
                        response = 0;
                        response_time = 0;
                        error_type = 2; % hitting within 100ms of target onset  Error 1 is hitting before target onset
                    end
                    if response_time > int_resp_time_max
                        response = 0;
                        response_time = 0;
                        error_type = 3; % Late error, no key press within response time window
                    end
                end
            end
            
            if isempty(find(ismember(1:4,error_type)))
                response=0;
                response_time=0;
                error_type = 5; %No key press, late error
            end
            Screen('FillRect', window, grey);
            vbl6 = Screen('Flip', window, vbl5 +  (int_resp_time/1000));
            Screen('FillRect', window, grey);
            vbl7 = Screen('Flip', window, vbl6 +  (int_ITI/1000));
            end_time = GetSecs;
        end
        datam=[nt, response, error_type, response_time, targ_contrast];
        full_data =[full_data; datam];
        nt = nt + 1;
        resptest=full_data(:,2);
        if length(resptest) > 3
%             if resptest(end)==1 && resptest(end-1)==1 && resptest(end-2)==1
            if resptest(end)==1 && resptest(end-1)==1
                targ_contrast=targ_contrast+0.4;
            elseif resptest(end)==0
                targ_contrast=targ_contrast-0.4;
            end
        end
    end
    if nt == ntrials
        ListenChar(0);
        ShowCursor;
        Screen('CloseAll');
        
        pathway = sprintf('%s/Data/Threshold_%s.mat',pwd,sub_ID); 
        save(pathway,'full_data');
%         save('Thresholdmat','full_data')
        return
    end
catch
    thiserror = lasterror();
    % save workspace!  otherwise we'll potentially loose all access to the data
    save('./crash_dump.mat');
    fprintf('\n#----------------------------------#\nsaving workspace in ./crash_dump.mat\n#----------------------------------#\n')
    % Clean up in case of an error in main code
    Screen('CloseAll'); % close any open screens/windows
    ShowCursor;         % restore cursor visibility
    ListenChar(1);      % keystrokes make it to command line/editor (Ctrl-c)
    Priority(0);        % restore normal processing priority
    display(sprintf('\n'));
    for i = 1:length(thiserror.stack)
        display(thiserror.stack(i));
    end
    rethrow(thiserror); % display error message that caused crash
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
close all;
load(sprintf('%s/Data/Threshold_%s.mat',pwd,'NC0014'))
ddt=full_data(:,5);
plot(ddt,'r','LineWidth',2);
targ_contrast=max(ddt)-0.1 %  below the minimum detection threshold

clearvars -except full_data targ_con
targ_contrast
sca;



