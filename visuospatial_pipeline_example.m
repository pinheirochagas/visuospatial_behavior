%% Define paths
addpath(genpath('/Users/pinheirochagas/Pedro/Stanford/code/visuospatial_behavior/'))
addpath('/Users/pinheirochagas/Pedro/Stanford/code/fieldtrip/')
ft_defaults

%% Analyze
subj_name = 's137';
prms.tvec = 500:1200;
prms.metric = 'RT';
prms.frqcutoff = [2 10];
prms.data_dir = '/Users/pinheirochagas/Pedro/Stanford/code/visuospatial_behavior/behavior_analysis/data/';
BehaviorOscillation(subj_name, prms)
% prms.tvec =  cue-target interval range of interest, (e.g. 500:1200)
% prms.metric = bahevioral metric, 'hit_rate' or 'RT'
% prms.frqcutoff = frequency range to plot the behavioral fft (e.g. 2:10);
% prms.data_dir =  (e.g. '/Users/pinheirochagas/Pedro/drive/Stanford/projects/visuospatial_attention/EglyDriver/Data/')
