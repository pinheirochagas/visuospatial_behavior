%StimEglyDriverEBS
%% Generate stimuli list for Visual Spatio EBS
catchtrials = 2*ones(1,ntrials);
catchtrials(1:10) = 1;
shufid=randsample(1:60,60);
catchtrials = catchtrials(shufid);
id_old = [];
for i =1:ntrials
    tb(i).catchtrials = catchtrials(i);
    TB = evalin('base',strcat('TB',num2str(tb(i).catchtrials)));
    idall = 1:size(TB,1);
    try
        idall(id_old)=[];
        id = randsample(idall,1);
        id_old = [id_old id];
    catch
        id = randi(size(TB,1));
    end
    tb(i).bar_VH = str2num(TB.VorH{id});
    tb(i).trial_type = str2num(TB.TrialType{id});
    tb(i).cue_pos = str2num(TB.CuePosition{id});
    tb(i).Fixsq1 = evalin('base',TB.ScreenFix1{id});
    tb(i).color1 = evalin('base',TB.Color1{id});
    if catchtrials(i) == 2
        tb(i).Fixsq2 = evalin('base',TB.ScreenFix2{id});
        tb(i).color2 = evalin('base',TB.Color2{id});
        tb(i).targ_pos = evalin('base',TB.TargetPosition{id});
    else
        tb(i).Fixsq2 = nan;
        tb(i).color2 = nan;
        tb(i).targ_pos = nan;
    end
end

nbins = 25;
int_cue_time = 100;
int_targ_time = 100; %120;
min_cue_t = 500;
max_cue_t = 1200;
int_resp_time = 600; % response time
%int_resp_time = 1200; % response time
int_resp_time_max = 600;
%int_resp_time_max = 1200;
int_ITI = 1500;

int_fix_time = randsample(400:800, ntrials);
int_fix_bar_time =  randsample(400:800, ntrials);

slist = struct2table(tb);
slist.int_cue_targ_time = randsample(min_cue_t:max_cue_t,ntrials)';

slist.int_fix_time = int_fix_time';
slist.int_fix_time(slist.catchtrials == 1) = 1200;

slist.int_fix_bar_time = int_fix_bar_time';
slist.int_fix_bar_time(slist.catchtrials == 1) = 1200;

slist.total_time = slist.int_fix_time + slist.int_fix_bar_time + int_cue_time + slist.int_cue_targ_time + ...
    int_targ_time + int_resp_time + 200;

slist.TTL = repmat([repmat([8 8 8 8 8], ntrials/10, 1); ...
repmat([8 8 8 8 8], ntrials/10, 1)], 5, 1);

% Set stimulation timing
min_after_cue = 100;
max_before_target = 200;
stim_duration = 200;
for i = 1:size(slist,1)
    slist.stim_onset(i) = datasample([min_after_cue:(slist.int_cue_targ_time(i) -max_before_target -stim_duration)], 1)';
end



