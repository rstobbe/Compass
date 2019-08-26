%=========================================================
%
%=========================================================

function [RECONWRT,err] = WrtRecon_Basic_v1a_Func(RECONWRT,INPUT)

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
WRT.Kmat = IMP.Kmat(TORD.projsampscnr,:,:,:);
nproj0 = IMP.PROJimp.nproj;
WRT.PROJimp.nproj = length(TORD.projsampscnr);
sz = size(IMP.Kmat);
if length(sz) == 3
    Arr = 1;
else
    Arr = sz(4);
end
SDC = zeros([nproj0,IMP.PROJimp.npro,Arr]);
for n = 1:Arr
    SDC(:,:,n) = SDCArr2Mat(SDCS.SDC(:,n),nproj0,IMP.PROJimp.npro);
end
SDC = SDC(TORD.projsampscnr,:,:);
WRT.SDC = SDC;
WRT.SDCname = SDCS.name;
WRT.dummies = WRTSYS.dummies;
WRT.projsampscnr = TORD.projsampscnr;
WRT = rmfield(WRT,{'qTscnr','G','Kend'});
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

