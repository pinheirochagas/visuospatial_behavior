%% Define paths
addpath(genpath('/Users/pinheirochagas/Pedro/Stanford/code/visuospatial_behavior/'))
addpath('/Users/pinheirochagas/Pedro/Stanford/code/fieldtrip/')
ft_defaults

%% Analyze
subj_name = 's137';
prms.tvec = 500:1200;
prms.metric = 'RT';
prms.frqcutoff = [2 10];
prms.data_dir = '/Users/pinheirochagas/Pedro/Stanford/code/visuospatial_behavior/data/';
BehaviorOscillation(subj_name, prms)
