%===========================================
% 
%===========================================

function [PDGM,err] = FmriParadigmCorrelation_v1a_Func(PDGM,INPUT)

Status2('busy','FMRI Paradigm Correlation',2);
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

% LogPdgm = logical(Pdgm);
% ImAct = Im(:,:,:,LogPdgm);
% sz = size(ImAct);
% ImRest = Im(:,:,:,not(LogPdgm));
% sz = size(ImAct);

ImOut = NaN*ones(size(Im(:,:,:,1)));
for n = 1:sz(1)
    for m = 1:sz(2)
        for p = 1:sz(3)
            Dat = squeeze(Im(n,m,p,1:LenPdgm));
            if Dat(1) < PDGM.MinSigVal
                continue
            end
            [R,P] = corrcoef(Dat,Pdgm);
            if P(2,1) < 0.05
                ImOut(n,m,p) = R(2,1);
            end
        end
    end
    Status2('busy',num2str(n),3);
end
IMG.Im = ImOut;

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

