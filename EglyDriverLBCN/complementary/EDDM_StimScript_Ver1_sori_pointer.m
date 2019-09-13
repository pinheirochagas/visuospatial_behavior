% Stimulus parameters for EDDM_Ver1.m 
% Manoj Eradath, Princeton Neuroscience Institute, 01/2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% setting up stimuli size 
[screenXpixels, screenYpixels] = Screen('WindowSize', window); % for scanner
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pix_per_deg  = pi * windowRect(3) / atan(p_mon_width/p_v_dist/2) / 360; % pixels per degree
centerX = windowRect(3)/2;  centerY = windowRect(4)/2;
VbarL = 2.0* pix_per_deg;VbarW = 12 * pix_per_deg;
HbarL = 12* pix_per_deg;HbarW = 2.0 * pix_per_deg;
CFixL = 0.7 * pix_per_deg; CFixW = 0.7 *pix_per_deg;
CueL = 2.5 * pix_per_deg; CueW = 2.5 * pix_per_deg;
TarL = 1.8 * pix_per_deg; TarW = 1.8 * pix_per_deg;
BardistCoversionFact=6/55; % Bar distance from center conversion factor taken from control script 
BarDistFromCenter = BardistCoversionFact*p_mon_width; %(in cm ) 
Xleft=(0.5 - (BarDistFromCenter/p_mon_width)); 
Xright=(0.5 + (BarDistFromCenter/p_mon_width)); 
Ytop=(0.5 - (BarDistFromCenter/p_mon_height)); 
Ybot=(0.5 + (BarDistFromCenter/p_mon_height)); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fixation square to begin with 
fixSq=[ 0 0 CFixL CFixW]; 
squareXpos = [screenXpixels * 0.5 ];
squareYpos = [screenYpixels * 0.5 ];
allColors = [WhiteC];
Fix = CenterRectOnPointd_sori(fixSq, squareXpos, squareYpos);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Endogenus cues
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Vertical bars
%%%%%%%%%%%%%%%%%%%%%%
%Vertical bars with central white fixation square
fixSqVB1 = [[0 0 VbarL VbarW]' [0 0 CFixL CFixW]' [0 0 VbarL VbarW]'];
squareXpos_VB1 = [screenXpixels * Xleft  screenXpixels * 0.5  screenXpixels * Xright];
squareYpos_VB1 = [screenYpixels * 0.5 screenYpixels * 0.5 screenYpixels * 0.5 ];
allColors_VB1 = [WhiteC' WhiteC' WhiteC'];
FixsqVB1 = CenterRectOnPointd_sori(fixSqVB1, squareXpos_VB1, squareYpos_VB1);
%Vertical bars with endo cue for topleft target (Red central fix square) 
fixSqVB2 = [[0 0 VbarL VbarW]' [0 0 CFixL CFixW]' [0 0 VbarL VbarW]'];
squareXpos_VB2 = [screenXpixels * Xleft  screenXpixels * 0.5  screenXpixels * Xright];
squareYpos_VB2 = [screenYpixels * 0.5 screenYpixels * 0.5 screenYpixels * 0.5 ];
allColors_VB2 = [WhiteC' RedC' WhiteC'];
FixsqVB_TL = CenterRectOnPointd_sori(fixSqVB2, squareXpos_VB2, squareYpos_VB2);
%Vertical bars with endo cue for bottom left target (Green central fix square) 
fixSqVB3 = [[0 0 VbarL VbarW]' [0 0 CFixL CFixW]' [0 0 VbarL VbarW]'];
squareXpos_VB3 = [screenXpixels * Xleft  screenXpixels * 0.5  screenXpixels * Xright];
squareYpos_VB3 = [screenYpixels * 0.5 screenYpixels * 0.5 screenYpixels * 0.5 ];
allColors_VB3 = [WhiteC' GreenC' WhiteC'];
FixsqVB_BL = CenterRectOnPointd_sori(fixSqVB3, squareXpos_VB3, squareYpos_VB3);
%Vertical bars with endo cue for topright target (Blue central fix square) 
fixSqVB4 = [[0 0 VbarL VbarW]' [0 0 CFixL CFixW]' [0 0 VbarL VbarW]'];
squareXpos_VB4 = [screenXpixels * Xleft  screenXpixels * 0.5  screenXpixels * Xright];
squareYpos_VB4 = [screenYpixels * 0.5 screenYpixels * 0.5 screenYpixels * 0.5 ];
allColors_VB4 = [WhiteC' BlueC' WhiteC'];
FixsqVB_TR = CenterRectOnPointd_sori(fixSqVB4, squareXpos_VB4, squareYpos_VB4);
%Vertical bars with endo cue for bottom right target (Cyan central fix square) 
fixSqVB5 = [[0 0 VbarL VbarW]' [0 0 CFixL CFixW]' [0 0 VbarL VbarW]'];
squareXpos_VB5 = [screenXpixels * Xleft  screenXpixels * 0.5  screenXpixels * Xright];
squareYpos_VB5 = [screenYpixels * 0.5 screenYpixels * 0.5 screenYpixels * 0.5 ];
allColors_VB5 = [WhiteC' CyanC' WhiteC'];
FixsqVB_BR = CenterRectOnPointd_sori(fixSqVB5, squareXpos_VB5, squareYpos_VB5);
%%%%%%%%%%%%%%%%%%%%%%%
%Horizontal bars
%%%%%%%%%%%%%%%%%%%%%%
%Horizontal bars with central white fixation square
fixSqHB1 = [[0 0 HbarL HbarW]' [0 0 CFixL CFixW]' [0 0  HbarL HbarW]'];
squareXpos_HB1 = [screenXpixels * 0.5 screenXpixels * 0.5 screenXpixels * 0.5];
squareYpos_HB1 = [ (screenYpixels * Ybot) screenYpixels * 0.5 (screenYpixels * Ytop)];
allColors_HB1 = [WhiteC' WhiteC' WhiteC'];
FixsqHB1 = CenterRectOnPointd_sori(fixSqHB1, squareXpos_HB1, squareYpos_HB1);
%Horizontal bars with endo cue for topleft target (Red central fix square) 
fixSqHB2 = [[0 0 HbarL HbarW]' [0 0 CFixL CFixW]' [0 0  HbarL HbarW]'];
squareXpos_HB2 = [screenXpixels * 0.5 screenXpixels * 0.5 screenXpixels * 0.5];
squareYpos_HB2 = [ (screenYpixels * Ybot) screenYpixels * 0.5 (screenYpixels * Ytop)];
allColors_HB2 = [WhiteC' RedC' WhiteC'];
FixsqHB_TL = CenterRectOnPointd_sori(fixSqHB2, squareXpos_HB2, squareYpos_HB2);
%Horizontal bars with endo cue for bottomleft target (Green central fix square) 
fixSqHB3 = [[0 0 HbarL HbarW]' [0 0 CFixL CFixW]' [0 0  HbarL HbarW]'];
squareXpos_HB3 = [screenXpixels * 0.5 screenXpixels * 0.5 screenXpixels * 0.5];
squareYpos_HB3 = [ (screenYpixels * Ybot) screenYpixels * 0.5 (screenYpixels * Ytop)];
allColors_HB3 = [WhiteC' GreenC' WhiteC'];
FixsqHB_BL = CenterRectOnPointd_sori(fixSqHB3, squareXpos_HB3, squareYpos_HB3);
%Horizontal bars with endo cue for topright target (Blue central fix square) 
fixSqHB4 = [[0 0 HbarL HbarW]' [0 0 CFixL CFixW]' [0 0  HbarL HbarW]'];
squareXpos_HB4 = [screenXpixels * 0.5 screenXpixels * 0.5 screenXpixels * 0.5];
squareYpos_HB4 = [ (screenYpixels * Ybot) screenYpixels * 0.5 (screenYpixels * Ytop)];
allColors_HB4 = [WhiteC' BlueC' WhiteC'];
FixsqHB_TR = CenterRectOnPointd_sori(fixSqHB4, squareXpos_HB4, squareYpos_HB4);
%Horizontal bars with endo cue for bottomright target (Cyan central fix square) 
fixSqHB5 = [[0 0 HbarL HbarW]' [0 0 CFixL CFixW]' [0 0  HbarL HbarW]'];
squareXpos_HB5 = [screenXpixels * 0.5 screenXpixels * 0.5 screenXpixels * 0.5];
squareYpos_HB5 = [ (screenYpixels * Ybot) screenYpixels * 0.5 (screenYpixels * Ytop)];
allColors_HB5 = [WhiteC' CyanC' WhiteC'];
FixsqHB_BR = CenterRectOnPointd_sori(fixSqHB5, squareXpos_HB5, squareYpos_HB5);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Exogenus cues 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Vertical bars 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fixation square with vertical bars topleft cue
FixSqVB6 = [[0 0 CueL CueW]' [0 0 VbarL VbarW]' [0 0 CFixL CFixW]' [0 0 VbarL VbarW]' ];
squareXpos_VB6 = [screenXpixels * Xleft screenXpixels * Xleft  screenXpixels * 0.5  screenXpixels * Xright ];
squareYpos_VB6 = [screenYpixels * Ytop screenYpixels * 0.5 screenYpixels * 0.5 screenYpixels * 0.5 ];
allColors_VB6 = [BlackC' WhiteC'  WhiteC'  WhiteC' ];
FixsqVB_TLC   = CenterRectOnPointd_sori(FixSqVB6, squareXpos_VB6, squareYpos_VB6);
% fixation square with vertical bars bottomleft cue
FixSqVB7 = [[0 0 CueL CueW]' [0 0 VbarL VbarW]' [0 0 CFixL CFixW]' [0 0 VbarL VbarW]' ];
squareXpos_VB7 = [screenXpixels * Xleft screenXpixels * Xleft  screenXpixels * 0.5  screenXpixels * Xright ];
squareYpos_VB7 = [screenYpixels * Ybot screenYpixels * 0.5 screenYpixels * 0.5 screenYpixels * 0.5 ];
allColors_VB7 = [BlackC' WhiteC'  WhiteC'  WhiteC' ];
FixsqVB_BLC   = CenterRectOnPointd_sori(FixSqVB7, squareXpos_VB7, squareYpos_VB7);
% fixation square with vertical bars topright cue
FixSqVB8 = [[0 0 CueL CueW]' [0 0 VbarL VbarW]' [0 0 CFixL CFixW]' [0 0 VbarL VbarW]' ];
squareXpos_VB8 = [screenXpixels * Xright screenXpixels * Xleft  screenXpixels * 0.5  screenXpixels * Xright ];
squareYpos_VB8 = [screenYpixels * Ytop screenYpixels * 0.5 screenYpixels * 0.5 screenYpixels * 0.5 ];
allColors_VB8 = [BlackC' WhiteC'  WhiteC'  WhiteC' ];
FixsqVB_TRC   = CenterRectOnPointd_sori(FixSqVB8, squareXpos_VB8, squareYpos_VB8);
% fixation square with vertical bars bottomright cue
FixSqVB9 = [[0 0 CueL CueW]' [0 0 VbarL VbarW]' [0 0 CFixL CFixW]' [0 0 VbarL VbarW]' ];
squareXpos_VB9 = [screenXpixels * Xright screenXpixels * Xleft  screenXpixels * 0.5  screenXpixels * Xright ];
squareYpos_VB9 = [screenYpixels * Ybot screenYpixels * 0.5 screenYpixels * 0.5 screenYpixels * 0.5 ];
allColors_VB9 = [BlackC' WhiteC'  WhiteC'  WhiteC' ];
FixsqVB_BRC   = CenterRectOnPointd_sori(FixSqVB9, squareXpos_VB9, squareYpos_VB9);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Horizontal bars 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fixation square with horizontal bars upper left cue 
FixSqHB6 = [[0 0 CueL CueW]' [0 0 HbarL HbarW]' [0 0 CFixL CFixW]' [0 0  HbarL HbarW]'];
squareXpos_HB6 = [screenXpixels * Xleft  screenXpixels * 0.5  screenXpixels * 0.5 screenXpixels * 0.5 ];
squareYpos_HB6 = [ (screenYpixels * Ytop) (screenYpixels * Ytop) screenYpixels * 0.5 (screenYpixels * Ybot)];
allColors_HB6  = [BlackC' WhiteC' WhiteC' WhiteC' ];
FixsqHB_TLC   = CenterRectOnPointd_sori(FixSqHB6, squareXpos_HB6, squareYpos_HB6);
% fixation square with horizontal bars bottom left cue 
FixSqHB7 = [[0 0 CueL CueW]' [0 0 HbarL HbarW]' [0 0 CFixL CFixW]' [0 0  HbarL HbarW]'];
squareXpos_HB7 = [screenXpixels * Xleft  screenXpixels * 0.5  screenXpixels * 0.5 screenXpixels * 0.5 ];
squareYpos_HB7 = [ (screenYpixels * Ybot) (screenYpixels * Ytop) screenYpixels * 0.5 (screenYpixels * Ybot)];
allColors_HB7  = [BlackC' WhiteC' WhiteC' WhiteC' ];
FixsqHB_BLC   = CenterRectOnPointd_sori(FixSqHB7, squareXpos_HB7, squareYpos_HB7);
% fixation square with horizontal bars top right cue 
FixSqHB8 = [[0 0 CueL CueW]' [0 0 HbarL HbarW]' [0 0 CFixL CFixW]' [0 0  HbarL HbarW]'];
squareXpos_HB8 = [screenXpixels * Xright  screenXpixels * 0.5  screenXpixels * 0.5 screenXpixels * 0.5 ];
squareYpos_HB8 = [ (screenYpixels * Ytop) (screenYpixels * Ytop) screenYpixels * 0.5 (screenYpixels * Ybot)];
allColors_HB8  = [BlackC' WhiteC' WhiteC' WhiteC' ];
FixsqHB_TRC   = CenterRectOnPointd_sori(FixSqHB8, squareXpos_HB8, squareYpos_HB8);
% fixation square with horizontal bars bottom right cue 
FixSqHB9 = [[0 0 CueL CueW]' [0 0 HbarL HbarW]' [0 0 CFixL CFixW]' [0 0  HbarL HbarW]'];
squareXpos_HB9 = [screenXpixels * Xright  screenXpixels * 0.5  screenXpixels * 0.5 screenXpixels * 0.5 ];
squareYpos_HB9 = [ (screenYpixels * Ybot) (screenYpixels * Ytop) screenYpixels * 0.5 (screenYpixels * Ybot)];
allColors_HB9  = [BlackC' WhiteC' WhiteC' WhiteC' ];
FixsqHB_BRC  = CenterRectOnPointd_sori(FixSqHB9, squareXpos_HB9, squareYpos_HB9);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Targets 
%%%%%%%%%%%%%%%%%%%%%%%
%Vertical bars 
% fixation square with vertical bars top Left  Target
FixSqVB10 = [ [0 0 VbarL VbarW]' [0 0 CFixL CFixW]' [0 0 VbarL VbarW]' [0 0 TarL TarW]'];
squareXpos_VB10 = [ screenXpixels * Xleft  screenXpixels * 0.5  screenXpixels * Xright screenXpixels * Xleft];
squareYpos_VB10 = [screenYpixels * 0.5 screenYpixels * 0.5 screenYpixels * 0.5 screenYpixels * (Ytop) ];
allColors_VB10  = [ WhiteC' WhiteC' WhiteC' [targ_contrast targ_contrast targ_contrast]'];
FixsqVB_TLT   = CenterRectOnPointd_sori(FixSqVB10, squareXpos_VB10, squareYpos_VB10);

% fixation square with vertical bars bottom left Target
FixSqVB11 = [ [0 0 VbarL VbarW]' [0 0 CFixL CFixW]' [0 0 VbarL VbarW]' [0 0 TarL TarW]'];
squareXpos_VB11 = [ screenXpixels * Xleft  screenXpixels * 0.5  screenXpixels * Xright screenXpixels * Xleft];
squareYpos_VB11 = [screenYpixels * 0.5 screenYpixels * 0.5 screenYpixels * 0.5 screenYpixels * (Ybot) ];
allColors_VB11  = [ WhiteC' WhiteC' WhiteC' [targ_contrast targ_contrast targ_contrast]'];
FixsqVB_BLT   = CenterRectOnPointd_sori(FixSqVB11, squareXpos_VB11, squareYpos_VB11);

% fixation square with vertical bars topright Target
FixSqVB12 = [ [0 0 VbarL VbarW]' [0 0 CFixL CFixW]' [0 0 VbarL VbarW]'  [0 0 TarL TarW]' ];
squareXpos_VB12 = [ screenXpixels * Xleft  screenXpixels * 0.5  screenXpixels * Xright screenXpixels * Xright];
squareYpos_VB12 = [screenYpixels * 0.5 screenYpixels * 0.5 screenYpixels * 0.5 screenYpixels * (Ytop) ];
allColors_VB12= [ WhiteC' WhiteC' WhiteC' [targ_contrast targ_contrast targ_contrast]'];
FixsqVB_TRT = CenterRectOnPointd_sori(FixSqVB12, squareXpos_VB12, squareYpos_VB12);

% fixation square with vertical bars bottom right target 
FixSqVB13 = [ [0 0 VbarL VbarW]' [0 0 CFixL CFixW]' [0 0 VbarL VbarW]'  [0 0 TarL TarW]' ];
squareXpos_VB13 = [ screenXpixels * Xleft  screenXpixels * 0.5  screenXpixels * Xright screenXpixels * Xright];
squareYpos_VB13 = [screenYpixels * 0.5 screenYpixels * 0.5 screenYpixels * 0.5 screenYpixels * (Ybot)];
allColors_VB13  = [ WhiteC' WhiteC' WhiteC' [targ_contrast targ_contrast targ_contrast]'];
FixsqVB_BRT   = CenterRectOnPointd_sori(FixSqVB13, squareXpos_VB13, squareYpos_VB13);
%%%%%%%%%%%%
%%% Horizontal bars
%%%%%%%%%%%%
% fixation square with horizontal bars upper left Targets
FixSqHB10 = [[0 0 HbarL HbarW]' [0 0 CFixL CFixW]' [0 0  HbarL HbarW]' [0 0 TarL TarW]'];
squareXpos_HB10 =[screenXpixels * 0.5  screenXpixels * 0.5 screenXpixels * 0.5 screenXpixels * (Xleft )+0.15 ];
squareYpos_HB10 = [ (screenYpixels * Ytop) screenYpixels * 0.5 (screenYpixels * Ybot) (screenYpixels * Ytop) ];
allColors_HB10 = [WhiteC' WhiteC' WhiteC' [targ_contrast targ_contrast targ_contrast]' ];
FixsqHB_TLT   = CenterRectOnPointd_sori(FixSqHB10, squareXpos_HB10, squareYpos_HB10);

% fixation square with horizontal bars bottom left Targets 
FixSqHB11 =[[0 0 HbarL HbarW]' [0 0 CFixL CFixW]' [0 0  HbarL HbarW]' [0 0 TarL TarW]'];
squareXpos_HB11 = [screenXpixels * 0.5  screenXpixels * 0.5 screenXpixels * 0.5 screenXpixels * (Xleft)+0.15  ];
squareYpos_HB11 = [ (screenYpixels * Ytop) screenYpixels * 0.5 (screenYpixels * Ybot) (screenYpixels * Ybot) ];
allColors_HB11 = [ WhiteC' WhiteC' WhiteC' [targ_contrast targ_contrast targ_contrast]' ];
FixsqHB_BLT   = CenterRectOnPointd_sori(FixSqHB11, squareXpos_HB11, squareYpos_HB11);

% fixation square with horizontal bars upper right Targets 
FixSqHB12 = [[0 0 HbarL HbarW]' [0 0 CFixL CFixW]' [0 0  HbarL HbarW]' [0 0 TarL TarW]'];
squareXpos_HB12 = [screenXpixels * 0.5  screenXpixels * 0.5 screenXpixels * 0.5 screenXpixels * (Xright)-0.15 ];
squareYpos_HB12 = [ (screenYpixels * Ytop) screenYpixels * 0.5 (screenYpixels * Ybot) (screenYpixels * Ytop) ];
allColors_HB12  = [ WhiteC' WhiteC' WhiteC' [targ_contrast targ_contrast targ_contrast]' ];
FixsqHB_TRT   = CenterRectOnPointd_sori(FixSqHB12, squareXpos_HB12, squareYpos_HB12);

% fixation square with horizontal bars Bottom right Targets 
FixSqHB13 = [[0 0 HbarL HbarW]' [0 0 CFixL CFixW]' [0 0  HbarL HbarW]' [0 0 TarL TarW]'];
squareXpos_HB13 = [screenXpixels * 0.5  screenXpixels * 0.5 screenXpixels * 0.5 screenXpixels * (Xright)-0.15 ];
squareYpos_HB13 = [ (screenYpixels * Ytop) screenYpixels * 0.5 (screenYpixels * Ybot) (screenYpixels * Ybot) ];
allColors_HB13  = [ WhiteC' WhiteC' WhiteC' [targ_contrast targ_contrast targ_contrast]' ];
FixsqHB_BRT   = CenterRectOnPointd_sori(FixSqHB13, squareXpos_HB13, squareYpos_HB13);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
