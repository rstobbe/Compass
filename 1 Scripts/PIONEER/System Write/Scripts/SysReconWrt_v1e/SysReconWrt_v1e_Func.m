%=========================================================
% 
%=========================================================

function [WRT,err] = SysReconWrt_v1e_Func(INPUT,WRT)

Status('busy','Write Data');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
WRTSYS = INPUT.WRTSYS;
WRTREC = INPUT.WRTREC;
TORD = INPUT.TORD;
IMP = INPUT.IMP;
SDCS = INPUT.SDCS;
clear INPUT;

%----
% sz = size(IMP.Kmat);
% IMP.PROJimp.npro = sz(2);               % delete
%----

%---------------------------------------------
% Get Trajectory Order
%---------------------------------------------
func = str2func([TORD.method,'_Func']);
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
func = str2func([WRTSYS.method,'_Func']);
INPUT.IMP = IMP;
%INPUT.IMP.projsampscnr = TORD.projsampscnr;        % delete
INPUT.G = IMP.G(TORD.projsampscnr,:,:);
INPUT.recononly = WRT.recononly;
[WRTSYS,err] = func(WRTSYS,INPUT);
if err.flag
    return
end

%---------------------------------------------
% Write Recon
%---------------------------------------------
func = str2func([WRTREC.method,'_Func']);
INPUT.IMP = IMP;
INPUT.TORD = TORD;
INPUT.WRTSYS = WRTSYS;
INPUT.SDCS = SDCS;
[WRTREC,err] = func(WRTREC,INPUT);
if err.flag
    return
end
WRT = WRTREC.WRT;

%---------------------------------------------
% Write Recon 
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'Name',WRT.name,'Output'};
Panel(3,:) = {'','','Output'};
Panel(4,:) = {'IMP',IMP.name,'Output'};
Panel(5,:) = {'SDC',SDCS.name,'Output'};
WRT.PanelOutput = cell2struct(Panel,{'label','value','type'},2);
WRT.PanelOutput = [WRT.PanelOutput;TORD.PanelOutput;WRTREC.PanelOutput;WRTSYS.PanelOutput];

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);



