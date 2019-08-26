%====================================================
% 
%====================================================

function [IE,err] = InitialEst_SDestDesSphere_v1e_Func(IE,INPUT)

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
relsamp = projlen*(samp/tro);
dr = zeros(1,npro);
for m = 2:npro
    dr(m) = (rprof(m)-rprof(m-1))/(relsamp(m)-relsamp(m-1));
end
dr = smooth(dr,29).';
dr(end-28:end) = mean(dr(end-80:end-29))*ones(1,29);

SDest = zeros(1,npro);
SDest(2:npro) = p^2./(dr(2:npro).*rprof(2:npro).^2);
SDest(1) = SDest(2);

%--------------------------------------------
% Interp at Sampling Points
%--------------------------------------------
rKmat = zeros(nproj,npro);
SDestKmat = zeros(nproj,npro);
iSDC = zeros(nproj,npro);
for n = 1:nproj
    rKmat(n,:) = squeeze(sqrt(Kmat(n,:,1).^2 + Kmat(n,:,2).^2 + Kmat(n,:,3).^2))/kmax;
    SDestKmat(n,:) = interp1(rprof,SDest,rKmat(n,:),'linear','extrap');

    rKmat2 = rKmat(n,:)/(max(rKmat(n,:)));
    iSDC0 = 1./SDestKmat(n,:);
    TFOKmat = interp1(TFO.r,TFO.tf,rKmat2,'linear','extrap');
    iSDC(n,:) = iSDC0.*TFOKmat;    
end
   

%--------------------------------------------
% Plot 
%--------------------------------------------
visuals = 1;
if visuals == 1
    figure(40); hold on; 
    plot(rKmat(1,:),SDestKmat(1,:),'k','linewidth',2); xlim([0 1]); 
    ylim([0 50]); 
    xlabel('Relative k-Space Radius'); 
    ylabel('Sampling Density'); 
    title('Relative Sampling Density Estimate');
        
    figure(41); plot(rKmat(1,:),iSDC(1,:),'k','linewidth',2); 
    xlabel('Relative k-Space Radius'); 
    ylabel('Initial SDC Estimate');
end

IE.iSDC = iSDC;
IE.iterations = 0;
