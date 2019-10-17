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

ImOut = NaN*ones(size(Im(:,:,:,1)));
for n = 1:sz(1)
    for m = 1:sz(2)
        for p = 1:sz(3)
            Dat = squeeze(Im(n,m,p,1:LenPdgm));
            if Dat(1) < PDGM.MinSigVal
                continue
            end
            tSlope = [ones(LenPdgm,1) (0:LenPdgm-1).']\Dat;
            [b,bint,r,rint,stats] = regress(Dat,[ones((sz(4)-1),1) (0:(sz(4)-2)).']);
            if stats(3) > 0.05
                continue
            end
            ImOut(n,m,p) = tSlope(2)/tSlope(1);
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

