%% Egly - plot all behavioral analyses

% clear all

subj = {'CP15'}
pathname = '/home/knight/rhelfric/Data/ECoG_Egly/'

tvec = 500:1:1700;
stepsize = 50;

for s = 1:length(subj)

    % load file
%     load([pathname, subj{s}, '/' subj{s}, '_behav_raw'])

    % only select valid trials
    behav = behav(find(behav(:,10) == 1),:);

    % find prc correct
    correct(s) = length(find(behav(:,6) > 0)) / size(behav,1);

    AC = ones(length(tvec),1) * NaN;
    for t = 1:length(tvec)

        currentT = [tvec(t)-stepsize tvec(t)+stepsize];
        tridx = find(behav(:,5) >= currentT(1) & behav(:,5) <= currentT(2) ...
                        & behav(:,10) == 1);
        % calc mean AC for three cond
        AC(t) = length(find(behav(tridx,6) > 0)) / length(tridx);

    end
       
    AC_sm = nanfastsmooth(AC, 25);
    
	% FFT
	behavGA.trial{1}(s,:) = AC_sm; 
%     clear AC
    
end

behavGA.time{1} = tvec ./ 1000;
behavGA.label = subj'




%% 1. zero-padded FFT
cfg = [];
cfg.method = 'mtmfft';
cfg.taper = 'hanning';
cfg.pad = 10;
cfg.foilim = [0 30];
behavfft = ft_freqanalysis(cfg, behavGA)