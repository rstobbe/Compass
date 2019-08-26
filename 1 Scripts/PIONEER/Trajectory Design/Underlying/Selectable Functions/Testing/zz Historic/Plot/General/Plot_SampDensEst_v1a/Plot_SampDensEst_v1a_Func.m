%=========================================================
% 
%=========================================================

function [OUTPUT,err] = Plot_SampDensEst_v1a_Func(INPUT)

Status('busy','Plot Sampling Density Estimate');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';
OUTPUT = struct();

%---------------------------------------------
% Get Input
%---------------------------------------------
DES = INPUT.DES;
T = DES.T;
KSA = DES.KSA;
PROJdgn = DES.PROJdgn;
clear INPUT;

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
% Plot 
%--------------------------------------------
figure(40); hold on; 
plot(r,SDest,'k','linewidth',2); xlim([0 1]); 
plot([0 1],[1 1],'k:');
ylim([0 10]); 
xlabel('Relative k-Space Radius'); 
ylabel('Relative Sampling Density'); 
title('Relative Sampling Density Estimate');


