%====================================================
% 
%====================================================

function [SYS,err] = SysImp_GenTempRot_v1a_Func(SYS,INPUT)

Status2('busy','Determine System Implementation Aspects',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PSMP = INPUT.PSMP;
qTscnr = INPUT.GWFM.qTscnr;
clear INPUT

%----------------------------------------------------
% Gradient Words
%----------------------------------------------------
SYS.gwpproj = length(qTscnr)-1;
SYS.gwpseq = SYS.gwpproj*PSMP.ndiscs;                % gradient words required to produce full set        

%----------------------------------------------------
% Panel Output
%----------------------------------------------------
Panel(1,:) = {'gwpproj',SYS.gwpproj,'Output'};
Panel(2,:) = {'gwpseq',SYS.gwpseq,'Output'};

PanelOutput = cell2struct(Panel,{'label','value','type'},2);
SYS.PanelOutput = PanelOutput;

Status2('done','',2);
Status2('done','',3);

