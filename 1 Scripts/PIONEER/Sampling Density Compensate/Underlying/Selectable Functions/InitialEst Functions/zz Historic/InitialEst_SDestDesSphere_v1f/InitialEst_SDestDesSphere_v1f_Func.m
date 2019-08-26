%====================================================
% 
%====================================================

function [IE,err] = InitialEst_SDestDesSphere_v1f_Func(IE,INPUT)

Status2('busy','Determine Initial Estimate',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMP = INPUT.IMP;
samp = IMP.samp;
Kmat = IMP.Kmat;
if isfield(IMP,'impPROJdgn');
    PROJdgn = IMP.impPROJdgn;
else
    PROJdgn = IMP.PROJdgn;
end
PROJimp = IMP.PROJimp;
TFO = INPUT.TFO;
clear INPUT

%--------------------------------------------
% Common Variables
%--------------------------------------------
p = PROJdgn.p;
tro = PROJdgn.tro;
projlen = PROJdgn.projlen;
kmax = PROJdgn.kmax;
npro = PROJimp.npro;
nproj = PROJimp.nproj;

%--------------------------------------------
% Get SD Shape
%--------------------------------------------
r = sqrt(Kmat(:,:,1).^2 + Kmat(:,:,2).^2 + Kmat(:,:,3).^2)/kmax;
rprof = mean(r,1);
rprof = smooth(rprof,IE.smoothing).';
relsamp = projlen*(samp/tro);
dr = zeros(1,npro);
for m = 2:npro
    dr(m) = (rprof(m)-rprof(m-1))/(relsamp(m)-relsamp(m-1));
end
dr = smooth(dr,IE.smoothing).';
dr(end-IE.smoothing+1:end) = mean(dr(end-(2*IE.smoothing):end-IE.smoothing))*ones(1,IE.smoothing);

SDest = zeros(1,npro);
SDest(2:npro) = p^2./(dr(2:npro).*rprof(2:npro).^2);
SDest(1) = SDest(2);

%--------------------------------------------
% Interp at Sampling Points
%--------------------------------------------
SDestKmat = interp1(rprof,SDest,rprof,'linear','extrap');
TFOKmat = interp1(TFO.r,TFO.tf,rprof,'linear','extrap');
iSDC = TFOKmat./SDestKmat;   

%--------------------------------------------
% Plot 
%--------------------------------------------
visuals = 1;
if visuals == 1
    %figure(40); hold on; 
    %plot(rprof(1,:),SDestKmat(1,:),'k','linewidth',2); xlim([0 1]); 
    %ylim([0 50]); 
    %xlabel('Relative k-Space Radius'); 
    %ylabel('Sampling Density'); 
    %title('Relative Sampling Density Estimate'); 
    figure(400); 
    subplot(2,2,3);
    plot(iSDC,'k'); 
    xlabel('Sampling Point'); 
    title('Initial SDC Estimate');
end

iSDC = meshgrid(iSDC,1:nproj);

IE.iSDC = iSDC;
IE.iterations = 0;
