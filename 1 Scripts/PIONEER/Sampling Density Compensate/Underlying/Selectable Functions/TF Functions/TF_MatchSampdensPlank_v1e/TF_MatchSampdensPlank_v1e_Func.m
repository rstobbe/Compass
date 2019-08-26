%====================================================
%
%====================================================

function [TF,err] = TF_MatchSampdensPlank_v1e_Func(TF,INPUT)

Status2('busy','Determine Output Transfer Function',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Working Structures / Variables
%---------------------------------------------
GAM = INPUT.IMP.DES.TPIT.GAM;
PROJdgn = INPUT.IMP.impPROJdgn;
clear INPUT

%---------------------------------------------
% Copy
%---------------------------------------------
GamShape = GAM.GamShape/max(GAM.GamShape(:)); 
TF.r = GAM.r;

%---------------------------------------------
% Plot GamShape
%---------------------------------------------
fh = figure(400); 
fh.Name = 'Sampling Density Compensation Setup';
fh.NumberTitle = 'off';
fh.Position = [400 150 1000 800];
subplot(2,2,1); hold on;
plot(TF.r,GamShape);
xlabel('Relative Radius'); title('Output Transfer Function');

%---------------------------------------------
% Plank Taper
%---------------------------------------------
reldrop = TF.enddrop/PROJdgn.rad;
N = length(TF.r);
Plank0 = ones(1,N);
for n = 1:N
    if n > (1-reldrop)*N
        Plank0(n) = 1/((exp(reldrop*(1/(1-n/N) + 1/(1-reldrop-n/N))))+1);
    end
end     
ind = find(Plank0 < 1e-2,1,'first');
Plank = ones(1,N);
Plank(N-ind+1:N) = Plank0(1:ind);
plot(TF.r,Plank);    

%---------------------------------------------
% Combine
%---------------------------------------------  
GamPlank = Plank.*GamShape;
GamPlank = GamPlank/max(GamPlank);
plot(TF.r,GamPlank);

%---------------------------------------------
% Plot PSF
%---------------------------------------------        
GamPsf = ifftshift(ifft([GamShape zeros(1,179999) flip(GamShape(2:end),2)]));
PlankPsf = ifftshift(ifft([Plank zeros(1,179999) flip(Plank(2:end),2)]));
GamPlankPsf = ifftshift(ifft([GamPlank zeros(1,179999) flip(GamPlank(2:end),2)]));

figure(fh); 
subplot(2,2,2); hold on;
L = length(GamPsf);
plot(GamPsf(L/2-300:L/2+299)/max(PlankPsf));
plot(PlankPsf(L/2-300:L/2+299)/max(PlankPsf));
plot(GamPlankPsf(L/2-300:L/2+299)/max(PlankPsf));
title('Output PSF');

%---------------------------------------------
% Output
%---------------------------------------------  
TF.tf = GamPlank;
TF.forsdcest = GamShape/max(GamShape);

%----------------------------------------------------
% Panel Items
%----------------------------------------------------
Panel(1,:) = {'TF_Shape','MatchSampdensPlank','Output'};
Panel(2,:) = {'TF_EndDrop',TF.enddrop,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
TF.Panel = Panel;
TF.PanelOutput = PanelOutput;
