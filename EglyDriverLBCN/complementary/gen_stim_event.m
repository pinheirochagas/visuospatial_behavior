%% Catch Trial == 1
function [TB1, TB2] = gen_stim_event(TrialType)
switch TrialType
    case 'Exo'
        type = 1;
    case 'Endo'
        type = 2;
end
tbm = cell(4,9);
stimname = {'TLC' 'BLC' 'TRC' 'BRC'};
tbm(:,1) = repmat({'1'},size(tbm,1),1);
tbm(:,2) = repmat({'1'},size(tbm,1),1);
tbm(:,3) = strsplit(num2str(1:4));
for i = 1:size(tbm,1)
    tbm{i,4} = strcat('allColors_','VB',num2str(i+5));
    tbm{i,5} = strcat('FixsqVB_',stimname{i});
end
tbm = repmat(tbm,2,1);
tbm((size(tbm,1)/2 + 1) :end, 2) = repmat({'2'},size(tbm,1)/2,1);
for i = size(tbm,1)/2+1:size(tbm,1)
    tbm{i,4} = strcat('allColors_','VB',num2str(i-3));
end

tbm = repmat(tbm,2,1);
tbm((size(tbm,1)/2 + 1) :end, 1) = repmat({'2'},size(tbm,1)/2,1);
for i = size(tbm,1)/2+1:size(tbm,1)
    tbm{i,4}(strfind(tbm{i,4},'V')) = 'H';
    tbm{i,5}(strfind(tbm{i,5},'V')) = 'H';
end
id = strcmp(tbm(:,2),num2str(type));
TB1 = cell2table(tbm(id,:),...
    'VariableNames',{'VorH' 'TrialType' 'CuePosition' 'Color1' 'ScreenFix1' 'Color2' 'ScreenFix2' 'TargetPosition' 'NAN'});

%% Catch Trial > 1     
tbmV = tbm(1:4,:);
tbmH = tbm(5:8,:);
tbm2 = [];
for i = 1:4
    pos = i;
    tbm2_ = repmat(tbmV(i,:),10,1);
    tbm2_(1:8,8) = repmat({'1'},8,1);
    tbm2_{9,8} = num2str(2);
    tbm2_{10,8} = num2str(3);
    cuetp=strsplit(tbm2_{1,5},'_');
    cuetp=cuetp{2};tp = cuetp;
    tp(strfind(tp,'C'))='T';
    tartp1 = strcat('FixsqVB_',tp);
    if ~isempty(tp(strfind(tp(1:2),'T')))
        tp(strfind(tp(1:2),'T'))='B';
    else
        tp(strfind(tp(1:2),'B'))='T';
    end
   
    tartp2 = strcat('FixsqVB_',tp);
    if ~isempty(tp(strfind(tp,'R')))
        tp(strfind(tp,'R'))='L';
    else
        tp(strfind(tp,'L'))='R';
    end
    tartp3 = strcat('FixsqVB_',tp);
    tbm2_(1:8,7) = repmat({tartp1},8,1);
    tbm2_{9,7} = tartp2;
    tbm2_{10,7} = tartp3;
    
%     tbm2_(1:8,7) = repmat({'FixsqVB_TLT'},8,1);
%     tbm2_{9,7} = 'FixsqVB_BLT';
%     tbm2_{10,7} = 'FixsqVB_BRT';
     switch pos
        case 1
            tbm2_(1:8,6) = repmat({'allColors_VB10'},8,1);
            tbm2_{9,6} = 'allColors_VB11';
            tbm2_{10,6} = 'allColors_VB12';
        case 2
            tbm2_(1:8,6) = repmat({'allColors_VB11'},8,1);
            tbm2_{9,6} = 'allColors_VB10';
            tbm2_{10,6} = 'allColors_VB13';
        case 3
            tbm2_(1:8,6) = repmat({'allColors_VB12'},8,1);
            tbm2_{9,6} = 'allColors_VB13';
            tbm2_{10,6} = 'allColors_VB10';
        case 4
            tbm2_(1:8,6) = repmat({'allColors_VB13'},8,1);
            tbm2_{9,6} = 'allColors_VB12';
            tbm2_{10,6} = 'allColors_VB11';
    end
    tbm2 = [tbm2;tbm2_];
end  

tbm3 = [];
for i = 1:4
    pos = i;
    tbm3_ = repmat(tbmH(i,:),10,1);
    tbm3_(1:8,8) = repmat({'1'},8,1);
    tbm3_{9,8} = num2str(2);
    tbm3_{10,8} = num2str(3);
    cuetp=strsplit(tbm3_{1,5},'_');
    cuetp=cuetp{2};tp = cuetp;
    tp(strfind(tp,'C'))='T';
    tartp1 = strcat('FixsqVB_',tp);
    if ~isempty(tp(strfind(tp(1:2),'T')))
        tp(strfind(tp(1:2),'T'))='B';
    else
        tp(strfind(tp(1:2),'B'))='T';
    end
    tartp2 = strcat('FixsqVB_',tp);
    if ~isempty(tp(strfind(tp,'R')))
        tp(strfind(tp,'R'))='L';
    else
        tp(strfind(tp,'L'))='R';
    end
    tartp3 = strcat('FixsqVB_',tp);
    tbm3_(1:8,7) = repmat({tartp1},8,1);
    tbm3_{9,7} = tartp2;
    tbm3_{10,7} = tartp3;
    
%     tbm3_(1:8,7) = repmat({'FixsqVB_TLT'},8,1);
%     tbm3_{9,7} = 'FixsqVB_BLT';
%     tbm3_{10,7} = 'FixsqVB_BRT';
    switch pos
        case 1
            tbm3_(1:8,6) = repmat({'allColors_VB10'},8,1);
            tbm3_{9,6} = 'allColors_VB11';
            tbm3_{10,6} = 'allColors_VB12';
        case 2
            tbm3_(1:8,6) = repmat({'allColors_VB11'},8,1);
            tbm3_{9,6} = 'allColors_VB10';
            tbm3_{10,6} = 'allColors_VB13';
        case 3
            tbm3_(1:8,6) = repmat({'allColors_VB12'},8,1);
            tbm3_{9,6} = 'allColors_VB13';
            tbm3_{10,6} = 'allColors_VB10';
        case 4
            tbm3_(1:8,6) = repmat({'allColors_VB13'},8,1);
            tbm3_{9,6} = 'allColors_VB12';
            tbm3_{10,6} = 'allColors_VB11';
    end
            
    tbm3 = [tbm3;tbm3_];
end  
tbm2 = [tbm2;tbm3];
tbm2 = repmat(tbm2,2,1);
tbm2((size(tbm2,1)/2 + 1) :end, 1) = repmat({'2'},size(tbm2,1)/2,1);
for i = size(tbm2,1)/2+1:size(tbm2,1)
    for j = 4:7
    tbm2{i,j}(strfind(tbm2{i,j},'V')) = 'H';
    end
end
id = strcmp(tbm2(:,2),num2str(type));
TB2 = cell2table(tbm2(id,:),...
    'VariableNames',{'VorH' 'TrialType' 'CuePosition' 'Color1' 'ScreenFix1' 'Color2' 'ScreenFix2' 'TargetPosition' 'NAN'});
TB1 = TB1(randperm(size(TB1, 1)), :);
TB2 = TB2(randperm(size(TB2, 1)), :);