%=========================================================
% 
%=========================================================

function [WRT,err] = SysReconWrt_v1b_Func(INPUT,WRT)

Status('busy','Write Data');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
WRTSYS = INPUT.WRTSYS;
TORD = INPUT.TORD;
IMP = INPUT.IMP;
SDCS = INPUT.SDCS;
clear INPUT;

%---------------------------------------------
% Write Recon 
%---------------------------------------------
func = str2func([WRT.trajorderfunc,'_Func']);
INPUT.IMP = IMP;
INPUT.SDCS = SDCS;
[TORD,err] = func(TORD,INPUT);
if err.flag
    return
end
clear INPUT

%---------------------------------------------
% Write SYS
%---------------------------------------------
func = str2func([WRT.wrtsysfunc,'_Func']);
INPUT.IMP = IMP;
INPUT.IMP.projsampscnr = TORD.projsampscnr;
INPUT.G = IMP.G(TORD.projsampscnr,:,:);
[WRTSYS,err] = func(WRTSYS,INPUT);
if err.flag
    return
end

WRT = IMP;
WRT.name = WRTSYS.name;
WRT.SDC = SDCArr2Mat(SDCS.SDC,IMP.PROJimp.nproj,IMP.PROJimp.npro);
WRT.SDCname = SDCS.name;
WRT.dummies = WRTSYS.dummies;
WRT.projsampscnr = TORD.projsampscnr;
WRT = rmfield(WRT,{'qTscnr','G','samp','Kend'});
WRT.TORD = TORD;

%---------------------------------------------
% Write Recon 
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'Name',WRT.name,'Output'};
Panel(3,:) = {'','','Output'};
Panel(4,:) = {'IMP',IMP.name,'Output'};
Panel(5,:) = {'SDC',SDCS.name,'Output'};
WRT.PanelOutput = cell2struct(Panel,{'label','value','type'},2);
WRT.PanelOutput = [WRT.PanelOutput;TORD.PanelOutput;WRTSYS.PanelOutput];

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);



