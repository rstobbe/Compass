%====================================================
%
%====================================================

function [TF,err] = TF_MatchSD_v1e_Func(TF,INPUT)

Status2('busy','Determine Output Transfer Function',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Working Structures / Variables
%---------------------------------------------
%GAM = INPUT.IMP.DES.TPIT.GAM;
GAM = INPUT.IMP.DES.GAMFUNC;
clear INPUT

%---------------------------------------------
% Copy
%---------------------------------------------
TF.tf = GAM.GamShape/max(GAM.GamShape(:)); 
TF.r = GAM.r;

%---------------------------------------------
% Plot TF
%---------------------------------------------
fh = figure(400); 
fh.Name = 'Sampling Density Compensation Setup';
fh.NumberTitle = 'off';
fh.Position = [400 150 1000 800];
subplot(2,2,1); hold on;
plot(TF.r,TF.tf,'k');
xlabel('Relative Radius'); title('Output Transfer Function');

%---------------------------------------------
% Plot PSF
%---------------------------------------------        
Psf = ifftshift(ifft([TF.tf zeros(1,179999) flip(TF.tf(2:end),2)]));

figure(fh); 
subplot(2,2,2); hold on;
L = length(Psf);
plot(Psf(L/2-300:L/2+299)/max(Psf),'k');
title('Output PSF');

%----------------------------------------------------
% Panel Items
%----------------------------------------------------
Panel(1,:) = {'TF_Shape','MatchSD','Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
TF.PanelOutput = PanelOutput;
