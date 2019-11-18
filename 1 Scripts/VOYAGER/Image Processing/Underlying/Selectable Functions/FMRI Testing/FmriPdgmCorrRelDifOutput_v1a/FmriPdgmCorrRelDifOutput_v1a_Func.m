%===========================================
% 
%===========================================

function [PDGM,err] = FmriPdgmCorrRelDifOutput_v1a_Func(PDGM,INPUT)

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
%Im = abs(IMG.Im);
%-
Im = angle(IMG.Im);
%-
sz = size(Im);
if sz(4) < LenPdgm
    err.flag = 1;
    err.msg = 'Experiment too short for paradigm';
end

LogPdgm = logical(Pdgm);
ImAct = Im(:,:,:,LogPdgm);
ImRest = Im(:,:,:,not(LogPdgm));

ImOut = NaN*ones(size(Im(:,:,:,1)));
for n = 1:sz(1)
    for m = 1:sz(2)
        for p = 1:sz(3)
            Dat = squeeze(Im(n,m,p,1:LenPdgm));
            Dat = unwrap(Dat);
            
            Slope = [ones(LenPdgm,1) (0:LenPdgm-1).']\Dat;
            out = (Slope(1)+(0:LenPdgm-1)*Slope(2));  
            %fitobject = fit((0:LenPdgm-1).',Dat,'poly1');
            %out = fitobject((0:LenPdgm-1));
%             figure(12341235); hold on;
%             plot(Dat);
%             plot(out);
            Dat = Dat - out.';
            
%             if Dat(1) < PDGM.MinSigVal
%                 continue
%             end
            [R,P] = corrcoef(Dat,Pdgm);
            if P(2,1) < PDGM.Significance
                ImOut(n,m,p) = R(2,1);
                %ImOut(n,m,p) = (mean(ImAct(n,m,p,:)-ImRest(n,m,p,:)))/PDGM.RefSigVal;
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

