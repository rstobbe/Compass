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


IMG.Im = mean(ImAct,4) - mean(ImRest,4);

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

