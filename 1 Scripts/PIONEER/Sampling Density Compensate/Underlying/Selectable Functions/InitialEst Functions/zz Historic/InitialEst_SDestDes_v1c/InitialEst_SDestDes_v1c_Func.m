%====================================================
% 
%====================================================

function [IE,err] = InitialEst_SDestDes_v1c_Func(IE,INPUT)

Status2('busy','Determine Initial Estimate',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMP = INPUT.IMP;
DES = IMP.DES;
T = DES.T;
KSA = DES.KSA;
Kmat = IMP.Kmat;
PROJdgn = DES.PROJdgn;
TFO = INPUT.TFO;
clear INPUT

%--------------------------------------------
% Common Variables
%--------------------------------------------
p = PROJdgn.p;
tro = PROJdgn.tro;
projlen0 = DES.CACC.projlen0;
relprojleninc = DES.CACC.relprojleninc;
kmax = PROJdgn.kmax;

%--------------------------------------------
% Get SD Shape
%--------------------------------------------
slvno = length(T);
KSA = squeeze(KSA);
r = sqrt(KSA(:,1).^2 + KSA(:,2).^2 + KSA(:,3).^2);
rT = projlen0*relprojleninc*(T/tro);
dr = zeros(slvno,1);
for m = 2:slvno
    dr(m) = (r(m)-r(m-1))/(rT(m)-rT(m-1));
end
SDest = zeros(1,slvno);
SDest(2:slvno) = p^2./(dr(2:slvno).*r(2:slvno).^2);
SDest(1) = SDest(2);

%--------------------------------------------
% Interp at Sampling Points
%--------------------------------------------
rKmat = squeeze(sqrt(Kmat(1,:,1).^2 + Kmat(1,:,2).^2 + Kmat(1,:,3).^2))/kmax;
SDestKmat = interp1(r,SDest,rKmat,'linear','extrap');

%--------------------------------------------
% Initial SDC estimate
%--------------------------------------------
iSDC = 1./SDestKmat;
TFOKmat = interp1(TFO.r,TFO.tf,rKmat,'linear','extrap');
iSDC = iSDC.*TFOKmat;

%--------------------------------------------
% Plot 
%--------------------------------------------
visuals = 1;
if visuals == 1
    figure(40); hold on; 
    plot(rKmat,SDestKmat,'k','linewidth',2); xlim([0 1]); 
    ylim([0 50]); 
    xlabel('Relative k-Space Radius'); 
    ylabel('Sampling Density'); 
    title('Relative Sampling Density Estimate');
        
    figure(41); plot(rKmat,iSDC,'k','linewidth',2); 
    xlabel('Relative k-Space Radius'); 
    ylabel('Initial SDC Estimate');
end

iSDC = meshgrid(iSDC,(1:PROJdgn.nproj));
IE.iSDC = iSDC;

