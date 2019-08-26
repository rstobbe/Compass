%=========================================================
% 
%=========================================================

function [WRT,err] = SysReconWrt_v1a_Func(INPUT,WRT)

Status('busy','Write Data');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
WRTSYS = INPUT.WRTSYS;
WRTRCN = INPUT.WRTRCN;
IMP = INPUT.IMP;
SDCS = INPUT.SDCS;
clear INPUT;

%---------------------------------------------
% Write Recon 
%---------------------------------------------
func = str2func([WRT.wrtreconfunc,'_Func']);
INPUT.IMP = IMP;
INPUT.SDCS = SDCS;
[WRTRCN,err] = func(WRTRCN,INPUT);
if err.flag
    return
end
clear INPUT

%---------------------------------------------
% Write SYS
%---------------------------------------------
func = str2func([WRT.wrtsysfunc,'_Func']);
INPUT.IMP = IMP;
INPUT.IMP.projsampscnr = WRTRCN.projsampscnr;
INPUT.G = IMP.G(WRTRCN.projsampscnr,:,:);
[WRTSYS,err] = func(WRTSYS,INPUT);
if err.flag
    return
end

WRT = IMP;
WRT.name = WRTSYS.name;
WRT.SDC = SDCArr2Mat(SDCS.SDC,IMP.PROJimp.nproj,IMP.PROJimp.npro);
WRT.SDCname = SDCS.name;
WRT.dummies = WRTSYS.dummies;
WRT.projsampscnr = WRTRCN.projsampscnr;
WRT = rmfield(WRT,{'qTscnr','G','samp','Kend'});
WRT.WRTRCN = WRTRCN;

%---------------------------------------------
% Write Recon 
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'Name',WRT.name,'Output'};
Panel(3,:) = {'','','Output'};
Panel(4,:) = {'IMP',IMP.name,'Output'};
Panel(5,:) = {'SDC',SDCS.name,'Output'};
WRT.PanelOutput = cell2struct(Panel,{'label','value','type'},2);
WRT.PanelOutput = [WRT.PanelOutput;WRTRCN.PanelOutput;WRTSYS.PanelOutput];

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);



