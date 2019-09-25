function BehaviorOscillation(subj_name, prms)
%
% prms.tvec =  cue-target interval range of interest, (e.g. 500:1200)
% prms.metric = bahevioral metric, 'hit_rate' or 'RT'
% prms.frqcutoff = frequency range to plot the behavioral fft (e.g. 2:10);
% prms.data_dir =  (e.g. '/Users/pinheirochagas/Pedro/drive/Stanford/projects/visuospatial_attention/EglyDriver/Data/')

% List files
% data_dir = fullfile(root_dir,'data',subj_name, day_tag);
data_dir = [prms.data_dir subj_name];
data_files = dir(fullfile(data_dir, ['*' subj_name '*.mat']));

% Time
tvec = 500:1200;

% Concatenate runs
for i = 1:length(data_files)
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
savePNG(gcf, 300, [data_dir subj_name '_stim_accuracy.png'])

% Count hit rate
stepsize = 30; % to be defined
for t = 1:length(tvec)
    currentT= [tvec(t)-stepsize tvec(t)+stepsize];
    tridx = find(data.int_cue_targ_time >= currentT(1) & data.int_cue_targ_time <= currentT(2) & data.targ_type == 1);
    if strcmp(prms.metric, 'hit_rate')
        AC(t) = length(find(data.response_time(tridx) > 0)) / length(tridx);
    elseif strcmp(prms.metric, 'RT')
        AC(t) = mean(data.response_time(find(data.response_time(tridx) > 0)));
    end
end
% Smooth the data
AC_sm = nanfastsmooth(AC, length(prms.tvec)/ stepsize);
AC_sm(isnan(AC_sm)) = 0; % DANGEROUS FIX, double check first

% Prepare fildtrip structure
behavGA.trial{1} = AC_sm;
behavGA.time{1} = prms.tvec ./ 1000;
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
if strcmp(prms.metric, 'hit_rate')
    ylabel('Hit Rate')
elseif strcmp(prms.metric, 'RT')
    ylabel('RT (ms)')
else
end

set(gca,'fontsize',fontsize)
% ylim([0 1])
box on

subplot(1,3,3)
hold on
frqcutoff = find(behavfft.freq>=prms.frqcutoff(1) & behavfft.freq<=prms.frqcutoff(2));
plot(behavfft.freq(frqcutoff), behavfft.powspctrm(frqcutoff), 'LineWidth', linewidth, 'Color', 'k')
xlabel('Frequency Hz')
ylabel('Power')
set(gca,'fontsize',fontsize)
box on
set(gcf,'color','w');
ylim([0 350])

% Save
savePNG(gcf, 300, sprintf('%s/%s_%s.png' , data_dir, subj_name, prms.metric))
end
