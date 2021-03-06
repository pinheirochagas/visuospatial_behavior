%%
addpath(genpath('/Users/pinheirochagas/Pedro/Stanford/code/visuospatial_behavior/'))
addpath('/Users/pinheirochagas/Pedro/Stanford/code/fieldtrip/')
ft_defaults

subj_name = {'S19_141'};
days = [2, 3, 2, 3, 3];


root_dir = '/Volumes/LBCN8T/Stanford/visuospatial/';

root_dir = '/Users/pinheirochagas/Pedro/drive/Stanford/projects/visuospatial_attention/EglyDriver/Data/'

for i = 1:length(subj_name)
    for ii = 1:days(i)
        day_tag = ['Day' num2str(ii)];
        behavfft = BehaviorOscillation(root_dir, subj_name{i}, day_tag);
    end
end
















%% Load data
files = dir(fullfile('/Users/pinheirochagas/Pedro/drive/Stanford/projects/visuospatial_attention/EglyDriver/Data/'));
data_dir = '/Users/pinheirochagas/Pedro/drive/Stanford/projects/visuospatial_attention/EglyDriver/Data/';

subj_name = {'NC0002'};
data_files = dir(fullfile(data_dir, ['*' subj_name{1} '*.mat']));

tvec = 500:1200;

% Concatenate runs 
for i = 1:4
    load([data_files(i).folder filesep data_files(i).name ])
    % convert to table
%     data_tmp = array2table(cell2mat(full_data(2:end,:)));
%     data_tmp.Properties.VariableNames = full_data(1,:);
    data_tmp = slist;
%     data_tmp = data_tmp(data_tmp.stim_onset<=200,:)
    
    correct(i) = sum(data_tmp.error_type == 5)/ size(data_tmp,1)
    
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
plot(correctnostim)
set(gca,'fontsize',20)
save2pdf([data_dir 's137_accuracy.pdf'], gcf, 600) 
% savePNG(gcf, 300, [data_dir 's137_stim_accuracy.png'])

% Accuracy

% Count hit rate
% tvec = min(data.int_cue_targ_time):1:max(data.int_cue_targ_time);
stepsize = 30; % to be defined
for t = 1:length(tvec)
    currentT= [tvec(t)-stepsize tvec(t)+stepsize];
    tridx = find(data.int_cue_targ_time >= currentT(1) & data.int_cue_targ_time <= currentT(2) & data.targ_type == 1);
    AC(t) = length(find(data.response_time(tridx) > 0)) / length(tridx);
end
% Smooth the data
AC_sm = nanfastsmooth(AC, length(tvec)/ stepsize);
AC_sm(isnan(AC_sm)) = 0
% Prepare fildtrip structure
behavGA.trial{1} = AC_sm;
behavGA.time{1} = [tvec ./ 1000];
behavGA.label = subj_name;

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
save2pdf([data_dir 's137_timing_distribution.pdf'], gcf, 600) 




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
% xlim([100 1000])

subplot(1,3,2)
hold on
plot(behavGA.time{1}*1000,AC, 'LineWidth', 1, 'Color',[.7 .7 .7])
plot(behavGA.time{1}*1000,behavGA.trial{1}, 'LineWidth', linewidth, 'Color', 'k')
% plot(behavGA.s.time{1}*1000,AC.s, 'LineWidth', 1, 'Color',[.7 .7 .7])
% plot(behavGA.s.time{1}*1000,behavGA.s.trial{1}, 'LineWidth', linewidth, 'Color', 'r')

xlim([min(behavGA.time{1}*1000) max(behavGA.time{1}*1000)])

plot(xlim, [mean(AC) mean(AC)], 'Color', 'k', 'LineWidth',1)
% plot(xlim, [mean(AC.s) mean(AC.s)], 'Color', 'r', 'LineWidth',1)

xlabel('Cue-Target interval ms')
ylabel('Hit Rate')
set(gca,'fontsize',fontsize)
ylim([0 1])
box on

subplot(1,3,3)
hold on
frqcutoff = find(behavfft.freq>=2 & behavfft.freq<=10);
plot(behavfft.freq(frqcutoff), powspctrm_z(frqcutoff), 'LineWidth', linewidth, 'Color', 'k')
% frqcutoff = find(behavfft.s.freq>=2 & behavfft.s.freq<=10);
% plot(behavfft.s.freq(frqcutoff), behavfft.s.powspctrm(frqcutoff), 'LineWidth', linewidth, 'Color', 'r')
xlabel('Frequency Hz')
ylabel('Norm. Power')
set(gca,'fontsize',fontsize)
% ylim([0 1])
box on
set(gcf,'color','w');
save2pdf([data_dir 's137_behav.pdf'], gcf, 600) 


% get mean AC
hold on
plot(behavGA.time{1}*1000,behavGA.trial{1}, 'LineWidth', linewidth, 'Color', 'k')
plot(xlim, [mean(AC) mean(AC)], 'Color', 'k', 'LineWidth',1)

plot(behavGA.time{1}(behavGA.trial{1} < mean(AC))*1000,behavGA.trial{1}(behavGA.trial{1} < mean(AC)), 'LineWidth', linewidth, 'Color', 'r')
plot(behavGA.time{1}(behavGA.trial{1} > mean(AC))*1000,behavGA.trial{1}(behavGA.trial{1} > mean(AC)), 'LineWidth', linewidth, 'Color', 'b')



stim_phase = behavGA.trial{1} < mean(AC);


for i = 1:size(data,1)
    [minn,idx] = min(abs(data.int_cue_targ_time(i)-behavGA.time{1}*1000));
    data.stim_phase(i) =  stim_phase(idx);
end









%%

% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% %% Simulate some predictions
% data.response_time_pred = data.response_time * 1.4;
% reponse_time = normrnd(mean(data.response_time) + 200, std(data.response_time)/5, [1 size(data,1)]);
% zeros_tmp = randsample(1:size(data,1),sum(data.response_time == 0));
% reponse_time(zeros_tmp) = 0;
% data.response_time = reponse_time';
% 
% % Count hit rate
% % tvec = min(data.int_cue_targ_time):1:max(data.int_cue_targ_time);
% stepsize = 30; % to be defined
% for t = 1:length(tvec)
%     currentT= [tvec(t)-stepsize tvec(t)+stepsize];
%     tridx = find(data.int_cue_targ_time >= currentT(1) & data.int_cue_targ_time <= currentT(2) & data.targ_type == 1);
%     AC(t) = length(find(data.response_time(tridx) > 0)) / length(tridx);
% end
% % Smooth the data
% AC_sm = nanfastsmooth(AC, length(tvec)/ stepsize);
% 
% mean_hr = mean(AC_sm);
% for i = 1:length(AC_sm)
%     if AC_sm(i) > mean_hr
%         AC_sm(i) = AC_sm(i) * 0.8;
%     else
%         AC_sm(i) = AC_sm(i) * 1.2;
%     end
% end
% AC_sm = AC_sm * 0.5;
% 
% % Prepare fildtrip structure
% behavGA.trial{1} = AC_sm;
% behavGA.time{1} = [tvec ./ 1000];
% behavGA.label = subj_name;
% 
% 
% %% Zero-padded FFT
% cfg = [];
% cfg.method = 'mtmfft';
% cfg.taper = 'hanning';
% cfg.pad = 10;
% cfg.foilim = [0 30];
% behavfft = ft_freqanalysis(cfg, behavGA);
% pw = behavfft.powspctrm;
% powspctrm_z = (pw - min(pw)) / (max(pw) - min(pw));
% 
% 
% subplot(1,3,1)
% histogram(data.response_time_pred(data.response>0), 'FaceColor', 'r')
% xlabel('RT ms')
% ylabel('Frequency')
% set(gca,'fontsize',fontsize)
% alpha(0.8)
% hold on
% plot([mean(data.response_time_pred(data.response>0)) mean(data.response_time_pred(data.response>0))],ylim,'Color', 'r', 'LineWidth',1)
% box on
% xlim([100 1000])
% 
% 
% % behavGA.trial{1} = behavGA.trial{1} * 0.5;
%     
% 
% subplot(1,3,2)
% hold on
% plot(behavGA.time{1}*1000,behavGA.trial{1}, 'LineWidth', linewidth, 'Color', 'r')
% xlim([min(behavGA.time{1}*1000) max(behavGA.time{1}*1000)])
% plot(xlim, [mean(behavGA.trial{1}) mean(behavGA.trial{1})], 'Color', 'r', 'LineWidth',1)
% xlabel('Cue-Target interval ms')
% ylabel('Hit Rate')
% set(gca,'fontsize',fontsize)
% ylim([0 1])
% box on
% 
% 
% %% Zero-padded FFT
% cfg = [];
% cfg.method = 'mtmfft';
% cfg.taper = 'hanning';
% cfg.pad = 10;
% cfg.foilim = [0 30];
% behavfft = ft_freqanalysis(cfg, behavGA);
% pw = behavfft.powspctrm;
% powspctrm_z = (pw - min(pw)) / (max(pw) - min(pw));
% 
% 
% subplot(1,3,3)
% hold on
% frqcutoff = find(behavfft.freq>=2 & behavfft.freq<=10);
% plot(behavfft.freq(frqcutoff), behavfft.powspctrm(frqcutoff), 'LineWidth', linewidth, 'Color', 'r')
% xlabel('Frequency Hz')
% ylabel('Norm. Power')
% set(gca,'fontsize',fontsize)
% % ylim([0 1])
% box on
% 
% set(gcf, 'units', 'normalized', 'outerposition', [0 0 1 .45]) % [0 0 .6 .3]
% 
% % save2pdf([data_dir 'vs_behav_alex_pred2.pdf'], gcf, 600) 
% 
% 
% %% Other
%         % calc mean AC for three cond
% %     AC(t) = length(find(behav(tridx,6) > 0)) / length(tridx);
% %     tridx = find(data.int_cue_targ_time == tvec(t) & data.targ_type == 1);
%     % calc mean AC for three cond
