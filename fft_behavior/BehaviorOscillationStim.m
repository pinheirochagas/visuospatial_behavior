function BehaviorOscillationStim(subj_name, prms)
%
% cfg.tvec =  500:1200
% cfg.data_dir = '/Users/pinheirochagas/Pedro/drive/Stanford/projects/visuospatial_attention/EglyDriver/Data/'
% cfg.metric = 'hit_rate'
% cfg.time_window = 'cue-target'
% cfg.frqcutoff = [2 10];

%% Load data
data_dir = [prms.data_dir subj_name];
data_files = dir(fullfile(data_dir, ['*' subj_name '*.mat']));

% Concatenate runs
for i = 1:length(data_files)
    load([data_files(i).folder filesep data_files(i).name ])
    data_tmp = slist;
    datastim = data_tmp(data_tmp.TTL(:,3) == 128,:);
    datanostim = data_tmp(data_tmp.TTL(:,3) == 8,:);
    correctstim(i) = sum(datastim.error_type == 5)/ size(datastim,1);
    correctnostim(i) = sum(datanostim.error_type == 5)/ size(datanostim,1);
    if i == 1
        data = data_tmp;
    else
        data = vertcat(data, data_tmp);
    end
end

% Plot accuracy
hold on
plot(correctnostim, '-o', 'LineWidth', 2, 'MarkerSize', 10, 'Color', 'k')
plot(correctstim, '-o', 'LineWidth', 2, 'MarkerSize', 10, 'Color', 'r')

xlabel('Block number')
ylabel('Accuracy')
hold on
plot(correctnostim)
set(gca,'fontsize',20)
savePNG(gcf, 300, [data_dir subj_name '_stim_accuracy.png'])

% Accuracy
data_all.s = data(data.TTL(:,3) == 128,: );
data_all.ns = data(data.TTL(:,3) == 8,: );

stim_no_stim = {'s', 'ns'};

correctstim = sum(datastim.error_type == 5)/ size(datastim,1);
correctnostim = sum(datanostim.error_type == 5)/ size(datanostim,1);


for i = 1:2
    data = data_all.(stim_no_stim{i});
    % Count hit rate
    stepsize = 30; % to be defined
    for t = 1:length(prms.tvec)
        currentT= [prms.tvec(t)-stepsize prms.tvec(t)+stepsize];
        
        if strcmp(prms.time_window, 'cue-target')
            tridx = find(data.int_cue_targ_time >= currentT(1) & data.int_cue_targ_time <= currentT(2) & data.targ_type == 1);
        elseif strcmp(prms.time_window, 'stim-target')
            tridx = find(data.int_cue_targ_time - data.stim_onset >= currentT(1) & data.int_cue_targ_time - data.stim_onset <= currentT(2) & data.targ_type == 1);
        else
        end
        
        
        if strcmp(prms.metric, 'hit_rate')
            AC.(stim_no_stim{i})(t) = length(find(data.response_time(tridx) > 0)) / length(tridx);
        elseif strcmp(prms.metric, 'RT')
            AC.(stim_no_stim{i})(t) = mean(data.response_time(find(data.response_time(tridx) > 0)));
        else
        end
        
        
    end
    % Smooth the data
    AC_sm = nanfastsmooth(AC.(stim_no_stim{i}), length(prms.tvec)/ stepsize);
    AC_sm(isnan(AC_sm)) = 0;
    % Prepare fildtrip structure
    behavGA.(stim_no_stim{i}).trial{1} = AC_sm;
    behavGA.(stim_no_stim{i}).time{1} = [prms.tvec ./ 1000];
    behavGA.(stim_no_stim{i}).label = {subj_name};
    
    %% Zero-padded FFT
    cfg = [];
    cfg.method = 'mtmfft';
    cfg.taper = 'hanning';
    cfg.pad = 10;
    cfg.foilim = [0 30];
    behavfft.(stim_no_stim{i}) = ft_freqanalysis(cfg, behavGA.(stim_no_stim{i}));
    pw = behavfft.(stim_no_stim{i}).powspctrm;
    powspctrm_z.(stim_no_stim{i}) = (pw - min(pw)) / (max(pw) - min(pw));
end


%% Plotting
figure('units', 'normalized', 'outerposition', [0 0 1 .45]) % [0 0 .6 .3]
subplot(1,2,1)
histogram(data_all.ns.int_cue_targ_time, 20, 'FaceColor', 'k')
xlabel('Cue-target interval')
ylabel('Frequency')
set(gca,'fontsize',20)

subplot(1,2,2)
histogram(data_all.ns.stim_onset, 20, 'FaceColor', 'r')
xlabel('Stimulation onset time')
ylabel('Frequency')
set(gca,'fontsize',20)

figure('units', 'normalized', 'outerposition', [0 0 1 .45]) % [0 0 .6 .3]
linewidth = 3;
fontsize = 16;

subplot(1,3,1)
histogram(data_all.ns.response_time(data_all.ns.response>0), 'FaceColor', [1 1 1], 'EdgeColor', 'k', 'LineWidth', 2)
hold on
histogram(data_all.s.response_time(data_all.s.response>0), 'FaceColor', [1 1 1], 'EdgeColor', 'r', 'LineWidth', 2)
xlabel('RT ms')
ylabel('Frequency')
set(gca,'fontsize',fontsize)
alpha(0.8)
plot([mean(data_all.ns.response_time(data_all.ns.response>0)) mean(data_all.ns.response_time(data_all.ns.response>0))],ylim,'Color', 'k', 'LineWidth',4)
plot([mean(data_all.s.response_time(data_all.s.response>0)) mean(data_all.s.response_time(data_all.s.response>0))],ylim,'Color', 'r', 'LineWidth',4)
box on

subplot(1,3,2)
hold on
plot(behavGA.ns.time{1}*1000,AC.ns, 'LineWidth', 1, 'Color',[.7 .7 .7])
plot(behavGA.ns.time{1}*1000,behavGA.ns.trial{1}, 'LineWidth', linewidth, 'Color', 'k')
plot(behavGA.s.time{1}*1000,AC.s, 'LineWidth', 1, 'Color',[.7 .7 .7])
plot(behavGA.s.time{1}*1000,behavGA.s.trial{1}, 'LineWidth', linewidth, 'Color', 'r')

xlim([min(behavGA.s.time{1}*1000) max(behavGA.s.time{1}*1000)])

plot(xlim, [mean(AC.ns) mean(AC.ns)], 'Color', 'k', 'LineWidth',1)
plot(xlim, [mean(AC.s) mean(AC.s)], 'Color', 'r', 'LineWidth',1)

if strcmp(prms.time_window, 'cue-target')
    xlabel('Cue-Target interval ms')
elseif strcmp(prms.time_window, 'stim-target')
    xlabel('Stimulation-Target interval ms')
else
end

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
frqcutoff = find(behavfft.ns.freq>=prms.frqcutoff(1) & behavfft.ns.freq<=prms.frqcutoff(2));
plot(behavfft.ns.freq(frqcutoff), behavfft.ns.powspctrm(frqcutoff), 'LineWidth', linewidth, 'Color', 'k')
frqcutoff = find(behavfft.s.freq>=prms.frqcutoff(1) & behavfft.s.freq<=prms.frqcutoff(2));
plot(behavfft.s.freq(frqcutoff), behavfft.s.powspctrm(frqcutoff), 'LineWidth', linewidth, 'Color', 'r')
xlabel('Frequency Hz')
ylabel('Power')
set(gca,'fontsize',fontsize)
box on
set(gcf,'color','w');
savePNG(gcf, 300, sprintf('%s/%s_%s_%s.png' , data_dir, subj_name, prms.time_window, prms.metric))
end

