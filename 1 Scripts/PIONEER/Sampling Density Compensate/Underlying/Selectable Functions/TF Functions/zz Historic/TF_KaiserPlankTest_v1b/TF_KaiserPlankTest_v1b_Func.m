%====================================================
% 
%====================================================

function [TF,err] = TF_KaiserPlankTest_v1b_Func(TF,INPUT)

Status2('busy','Return KaiserPlank Transfer Function',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMP = INPUT.IMP;
if not(isfield(IMP,'impPROJdgn'))
    PROJdgn = IMP.PROJdgn;
else
    PROJdgn = IMP.impPROJdgn;
end

%---------------------------------------------
% Create Base Transfer Function
%---------------------------------------------
% if not(isfield(PROJdgn,'spiralaccom'))
%     PROJdgn.spiralaccom = 1;
% end
% rmax = ceil(PROJdgn.spiralaccom*100)/100;

%---
rmax = 0.9;
%---
r = (0:0.0001/rmax:1);
Kaiser0 = besseli(0,TF.beta * sqrt(1 - r.^2)); 
Kaiser0 = Kaiser0/Kaiser0(1);

fh = figure(400); 
fh.Name = 'Sampling Density Compensation Setup';
fh.NumberTitle = 'off';
fh.Position = [400 150 1000 800];
subplot(2,2,1); hold on;
TF.r = (0:0.0001:1);
KaiserFull = zeros(size(TF.r));
KaiserFull(1:length(Kaiser0)) = Kaiser0;
plot(TF.r,KaiserFull);

%---------------------------------------------
% Plank Taper
%---------------------------------------------
reldrop = TF.enddrop/PROJdgn.rad;
N = length(r);
Plank0 = ones(1,N);
for n = 1:N
    if n > (1-reldrop)*N
        Plank0(n) = 1/((exp(reldrop*(1/(1-n/N) + 1/(1-reldrop-n/N))))+1);
    end
end     
ind = find(Plank0 < 1e-6,1,'first');
Plank = ones(1,N);
Plank(N-ind+1:N) = Plank0(1:ind);
PlankFull = zeros(size(TF.r));
PlankFull(1:length(Plank)) = Plank;
plot(TF.r,PlankFull);        

%---------------------------------------------
% Combine
%---------------------------------------------  
%KaiserPlankFull = PlankFull.*KaiserFull + 0.01;
KaiserPlankFull = PlankFull.*KaiserFull;
KaiserPlankFull = KaiserPlankFull/max(KaiserPlankFull);
plot(TF.r,KaiserPlankFull);
xlabel('Relative Radius'); title('Output Transfer Function');

%---------------------------------------------
% Plot Profiles
%---------------------------------------------        
psfKaiser = ifftshift(ifft([KaiserFull zeros(1,179999) flip(KaiserFull(2:end),2)]));
psfPlank = ifftshift(ifft([PlankFull zeros(1,179999) flip(PlankFull(2:end),2)]));
psfKaiserPlank = ifftshift(ifft([KaiserPlankFull zeros(1,179999) flip(KaiserPlankFull(2:end),2)]));

figure(fh); 
subplot(2,2,2); hold on;
L = length(psfKaiser);
plot(psfKaiser(L/2-300:L/2+299)/max(psfPlank));
plot(psfPlank(L/2-300:L/2+299)/max(psfPlank));
plot(psfKaiserPlank(L/2-300:L/2+299)/max(psfPlank));
box on;
title('Output PSF (Cart-1D)');

%---------------------------------------------
% Output
%---------------------------------------------  
TF.tf = KaiserPlankFull;
TF.forsdcest = ones(size(KaiserPlankFull));

%----------------------------------------------------
% Panel Items
%----------------------------------------------------
Panel(1,:) = {'TF_Shape','KaiserPlank','Output'};
Panel(2,:) = {'TF_beta',TF.beta,'Output'};
Panel(3,:) = {'TF_enddrop',TF.enddrop,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
TF.Panel = Panel;
TF.PanelOutput = PanelOutput;


