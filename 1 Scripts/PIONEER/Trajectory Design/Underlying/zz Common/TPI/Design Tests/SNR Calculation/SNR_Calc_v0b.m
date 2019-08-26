%====================================================
% 
%====================================================

function [rSNR] = SNR_Calc_v0b(PROJdgn)

gam = PROJdgn.GamShape;
tatr = PROJdgn.tatr;
r = PROJdgn.r;
p = PROJdgn.p;
tro = PROJdgn.tro;
projlen = PROJdgn.projlen;

tauatr = (tatr/tro)*projlen;
tau = (0:0.01:projlen);
rattau = interp1(tauatr,r,tau,'pchip','extrap');
gamattau = interp1(tauatr,gam,tau,'pchip','extrap'); 
%figure(10); plot(rattau,gamattau,'*'); 

%gamattau = gamattau/p;                                     % make sure Gam proper
%figure(20); plot(rattau,gamattau,'*'); xlim([0 1]);

ind = find(rattau <= p,1,'last');
comparr = ([((rattau(1:ind)).^2 .* gamattau(1:ind)) ones(1,length(rattau)-ind)].^2);
%figure(30); plot(rattau,comparr,'*'); xlim([0 1]); 
comp = sum(comparr);

nSD = sqrt((projlen/tro)*comp);
rSNR = gamattau(1)/nSD;

rSNR = rSNR*(PROJdgn.vox)^3;