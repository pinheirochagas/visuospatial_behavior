function behavfft = BehaviorOscillation(root_dir,subj_name, day_tag)

% List files
% data_dir = fullfile(root_dir,'data',subj_name, day_tag);
data_dir = fullfile(root_dir,subj_name);
data_files = dir(fullfile(data_dir, ['*' subj_name '*.mat']));
data_files_tmp = {data_files(:).name};
data_files = data_files(find(cellfun(@(x) ~contains(x, '._'), data_files_tmp)));

% Time
tvec = 500:1200;

% Concatenate runs
for i = 1:2
    load([data_files(i).folder filesep data_files(i).name ])
    data_tmp = slist;
    correct(i) = sum(data_tmp.error_type == 5)/ size(data_tmp,1);
    if i == 1
        data = data_tmp;
    else
        data = vertcat(data, data_tmp);
    end
end

% Plot accuracy
hold on
plot(correct, '-o', 'LineWidth', 2, 'MarkerSize', 10, 'Color', 'k')

xlabel('Block number')
ylabel('Accuracy')
hold on
set(gca,'fontsize',20)
% f_out = sprintf('%sresults/accuracy_by_block_%s_%s.png',root_dir,subj_name,day_tag);
f_out = sprintf('%sresults/accuracy_by_block_%s_%s.png',root_dir,subj_name);

% savePNG(gcf, 600, f_out) 


% Accuracy

% Count hit rate
% tvec = min(data.int_cue_targ_time):1:max(data.int_cue_targ_time);
stepsize = 30; % to be defined
for t = 1:length(tvec)
    currentT= [tvec(t)-stepsize tvec(t)+stepsize];
    tridx = find(data.int_cue_targ_time >= currentT(1) & data.int_cue_targ_time <= currentT(2) & data.targ_type == 1);
%      AC(t) = length(find(data.response_time(tridx) > 0)) / length(tridx);
     AC(t) = mean(data.response_time(find(data.response_time(tridx) > 0)));
end
% Smooth the data
AC_sm = nanfastsmooth(AC, length(tvec)/ stepsize);
AC_sm(isnan(AC_sm)) = 0 % DANGEROUS, CORRECT.
% Prepare fildtrip structure
behavGA.trial{1} = AC_sm;
behavGA.time{1} = [tvec ./ 1000];
behavGA.label = {subj_name};

%% Zero-padded FFT
cfg = [];
cfg.method = 'mtmfft';
cfg.taper = 'hanning';
cfg.pad = 10;
cfg.foilim = [0 30];
behavfft = ft_freqanalysis(cfg, behavGA);
pw = behavfft.powspctrm;
powspctrm_z = (pw - min(pw)) / (max(pw) - min(pw));


%% Plotting
figure('units', 'normalized', 'outerposition', [0 0 1 .45]) % [0 0 .6 .3]
linewidth = 3;
fontsize = 16;

subplot(1,3,1)
hold on
histogram(data.response_time(data.response>0), 'FaceColor', [1 1 1], 'EdgeColor', 'k', 'LineWidth', 2)
xlabel('RT ms')
ylabel('Frequency')
set(gca,'fontsize',fontsize)
box on

subplot(1,3,2)
hold on
plot(behavGA.time{1}*1000,AC, 'LineWidth', 1, 'Color',[.7 .7 .7])
plot(behavGA.time{1}*1000,behavGA.trial{1}, 'LineWidth', linewidth, 'Color', 'k')
xlim([min(behavGA.time{1}*1000) max(behavGA.time{1}*1000)])

plot(xlim, [mean(AC) mean(AC)], 'Color', 'k', 'LineWidth',1)
xlabel('Cue-Target interval ms')
ylabel('RT (ms)')
% ylabel('Hit Rate')

set(gca,'fontsize',fontsize)
% ylim([0 1])
box on

subplot(1,3,3)
hold on
frqcutoff = find(behavfft.freq>=2 & behavfft.freq<=10);
plot(behavfft.freq(frqcutoff), powspctrm_z(frqcutoff), 'LineWidth', linewidth, 'Color', 'k')
xlabel('Frequency Hz')
ylabel('Norm. Power')
set(gca,'fontsize',fontsize)
box on
set(gcf,'color','w');

% Save
f_out = sprintf('%sresults/BehOsci_%s_%s.png',root_dir,subj_name,day_tag);
savePNG(gcf, 600, f_out) 
close all



end
