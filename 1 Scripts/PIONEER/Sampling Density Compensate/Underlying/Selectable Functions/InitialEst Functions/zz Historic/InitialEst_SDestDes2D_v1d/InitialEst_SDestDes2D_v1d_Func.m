%====================================================
% 
%====================================================

function [IE,err] = InitialEst_SDestDes2D_v1d_Func(IE,INPUT)

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

%----------------------------------------
% Tests
%----------------------------------------
if size(Kmat,2) == 3 
    if sum(Kmat,3) ~= 0
        err.flag = 1;
        err.msg = '''InitialEst_SDestDes2D'' is for 2D kSpace Sampling';
        return 
    end
end

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
r = sqrt(Kmat(:,:,1).^2 + Kmat(:,:,2).^2)/kmax;
relsamp = projlen*(samp/tro);
dr = zeros(nproj,npro);
for n = 1:nproj
    for m = 2:npro
        dr(n,m) = (r(n,m)-r(n,m-1))/(relsamp(m)-relsamp(m-1));
    end
end
SDest = zeros(nproj,npro);
SDest(:,2:npro) = p./(dr(:,2:npro).*r(:,2:npro));
SDest(:,1) = SDest(:,2);

%figure(39); hold on; 
%plot(r,'k','linewidth',2); 
%figure(40); hold on; 
%plot(r(1,:),dr(1,:),'k','linewidth',2); 
%plot(r(1,:),SDest(1,:),'k','linewidth',2); ylim([0 10]);

%--------------------------------------------
% Interp at Sampling Points
%--------------------------------------------
rKmat = zeros(nproj,npro);
SDestKmat = zeros(nproj,npro);
iSDC = zeros(nproj,npro);
for n = 1:nproj
    rKmat(n,:) = squeeze(sqrt(Kmat(n,:,1).^2 + Kmat(n,:,2).^2))/kmax;
    SDestKmat(n,:) = interp1(r(n,:),SDest(n,:),rKmat(n,:),'linear','extrap');

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
