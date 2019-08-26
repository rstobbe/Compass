%=========================================================
% 
%=========================================================

function [WRT,err] = SysReconWrt_v1d_Func(INPUT,WRT)

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

%----
sz = size(IMP.Kmat);
IMP.PROJimp.npro = sz(2);               % hack
%----

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
INPUT.recononly = WRT.recononly;
[WRTSYS,err] = func(WRTSYS,INPUT);
if err.flag
    return
end

WRT = IMP;
WRT.name = WRTSYS.name;
sz = size(IMP.Kmat);
if length(sz) == 3
    Arr = 1;
else
    Arr = sz(4);
end
SDC = zeros([IMP.PROJimp.nproj,IMP.PROJimp.npro,Arr]);
for n = 1:Arr
    SDC(:,:,n) = SDCArr2Mat(SDCS.SDC(:,n),IMP.PROJimp.nproj,IMP.PROJimp.npro);
end
WRT.SDC = SDC;
WRT.SDCname = SDCS.name;
WRT.dummies = WRTSYS.dummies;
WRT.projsampscnr = TORD.projsampscnr;
WRT = rmfield(WRT,{'qTscnr','G','Kend'});
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



