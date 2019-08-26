%=========================================================
%
%=========================================================

function [RECONWRT,err] = WrtRecon_Basic_v1b_Func(RECONWRT,INPUT)

Status2('busy','Build Recon File',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-------------------------------------------------
% Get input
%-------------------------------------------------
IMP = INPUT.IMP;
TORD = INPUT.TORD;
WRTSYS = INPUT.WRTSYS;
SDCS = INPUT.SDCS;
clear INPUT

%-------------------------------------------------
% Remove k-Space Oversampling
%-------------------------------------------------
WRT = IMP;
WRT.name = WRTSYS.name;

nproj0 = IMP.PROJimp.nproj;
WRT.PROJimp.nproj = length(TORD.projsampscnr);

sz = size(IMP.Kmat);
if length(sz) == 3
    N = 1;
else
    N = sz(4);
end
KArr = zeros(WRT.PROJimp.nproj*WRT.PROJimp.npro,3,N);
for n = 1:N
    KArr(:,:,n) = KMat2Arr(IMP.Kmat(TORD.projsampscnr,:,:,n),WRT.PROJimp.nproj,WRT.PROJimp.npro);
end

SDC = zeros([nproj0,IMP.PROJimp.npro,N]);
for n = 1:N
    SDC(:,:,n) = SDCArr2Mat(SDCS.SDC(:,n),nproj0,IMP.PROJimp.npro);
end

SDCArr = zeros(WRT.PROJimp.nproj*WRT.PROJimp.npro,N);
for n = 1:N
    SDCArr(:,n) = SDCMat2Arr(SDC(TORD.projsampscnr,:,n),WRT.PROJimp.nproj,WRT.PROJimp.npro);
end

WRT.KArr = single(KArr);
WRT.SDCArr = single(SDCArr);
WRT.SDCname = SDCS.name;
WRT.dummies = WRTSYS.dummies;
WRT.projsampscnr = TORD.projsampscnr;
WRT = rmfield(WRT,{'qTscnr','G','Kend','Kmat','samp'});
WRT.TORD = TORD;
WRT.OverProj = 'No';

%--------------------------------------------
% Panel
%--------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',RECONWRT.method,'Output'};
RECONWRT.PanelOutput = cell2struct(Panel,{'label','value','type'},2);

%--------------------------------------------
% Return
%--------------------------------------------
RECONWRT.WRT = WRT;

Status2('done','',2);
Status2('done','',3);

