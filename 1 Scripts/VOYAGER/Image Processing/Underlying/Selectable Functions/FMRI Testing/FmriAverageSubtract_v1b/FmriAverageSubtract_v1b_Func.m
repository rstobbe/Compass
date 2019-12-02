%===========================================
% 
%===========================================

function [PDGM,err] = FmriAverageSubtract_v1b_Func(PDGM,INPUT)

Status2('busy','FMRI Average Subtract',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%--------------------------------------------- 
IMG = INPUT.IMG{1};
clear INPUT;

%---------------------------------------------
% Read Excel
%---------------------------------------------
PdgmTable = readtable([PDGM.ParadigmExcelFile.path,PDGM.ParadigmExcelFile.file]);
PdgmCell = table2cell(PdgmTable);
Pdgm = cell2mat(PdgmCell);
LenPdgm = length(Pdgm);

%---------------------------------------------
% Test
%--------------------------------------------- 
Im = abs(IMG.Im);
sz = size(Im);
if sz(4) < LenPdgm
    err.flag = 1;
    err.msg = 'Experiment too short for paradigm';
end

LogPdgm = logical(Pdgm);
ImAct = Im(:,:,:,LogPdgm);
ImRest = Im(:,:,:,not(LogPdgm));

%IMG.Im = mean(ImAct,4) - mean(ImRest,4);

ImOut = NaN*ones(size(Im(:,:,:,1)));
for n = 1:sz(1)
    for m = 1:sz(2)
        for p = 1:sz(3)
            [h,pval] = ttest(ImAct(n,m,p,:)-ImRest(n,m,p,:));
            if h == 1
                ImOut(n,m,p) = mean(ImAct(n,m,p,:)-ImRest(n,m,p,:));
            end
        end
    end
    Status2('busy',num2str(n),3);
end
%--
RefSig = 3.9;
%--
IMG.Im = ImOut/RefSig;

%IMG.Im(IMG.Im < 0.0075) = NaN;

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',PDGM.method,'Output'};
PDGM.PanelOutput = cell2struct(Panel,{'label','value','type'},2);

%---------------------------------------------
% Return
%---------------------------------------------
PDGM.FigureName = 'FMRI Subtraction';
PDGM.IMG = IMG;

Status2('done','',2);
Status2('done','',3);
