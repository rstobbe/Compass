%=========================================================
% 
%=========================================================

function [WRT,err] = IdeaWfmTestWrt_v1a_Func(INPUT,WRT)

Status('busy','Write Data');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
WRTSYS = INPUT.WRTSYS;
%TORD = INPUT.TORD;
IMP = INPUT.IMP;
clear INPUT;

%---------------------------------------------
% Order Trajectories
%---------------------------------------------
% func = str2func([WRT.trajorderfunc,'_Func']);
% INPUT.IMP = IMP;
% [TORD,err] = func(TORD,INPUT);
% if err.flag
%     return
% end
% clear INPUT
sz = size(IMP.G);

%---------------------------------------------
% Write SYS
%---------------------------------------------
func = str2func([WRT.wrtsysfunc,'_Func']);
INPUT.IMP = IMP;
%INPUT.IMP.projsampscnr = TORD.projsampscnr;
INPUT.IMP.projsampscnr = 1:sz(1);
%INPUT.G = IMP.G(TORD.projsampscnr,:,:);
INPUT.G = IMP.G;
INPUT.recononly = 'no';
[WRTSYS,err] = func(WRTSYS,INPUT);
if err.flag
    return
end
WRT.name = WRTSYS.name;

%---------------------------------------------
% Write Recon 
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'Name',WRT.name,'Output'};
Panel(3,:) = {'','','Output'};
Panel(4,:) = {'IMP',IMP.name,'Output'};
WRT.PanelOutput = cell2struct(Panel,{'label','value','type'},2);
%WRT.PanelOutput = [WRT.PanelOutput;TORD.PanelOutput;WRTSYS.PanelOutput];
WRT.PanelOutput = [WRT.PanelOutput;WRTSYS.PanelOutput];

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);



