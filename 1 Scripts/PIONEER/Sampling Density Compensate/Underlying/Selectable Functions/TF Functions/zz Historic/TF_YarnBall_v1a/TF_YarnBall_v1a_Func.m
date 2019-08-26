%====================================================
% 
%====================================================

function [TF,err] = TF_YarnBall_v1a_Func(TF,INPUT)

Status2('busy','Return YarnBall Transfer Function',2);
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
rmax = ceil(PROJdgn.spiralaccom*100)/100;
r = (0:0.0001/rmax:1);
Kaiser = besseli(0,TF.beta * sqrt(1 - r.^2)); 
Kaiser = Kaiser/Kaiser(1);
figure(400); hold on;
TF.r = (0:0.0001:rmax);
plot(TF.r,Kaiser);

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
ind = find(Plank0 < 1e-2,1,'first');
Plank = ones(1,N);
Plank(N-ind+1:N) = Plank0(1:ind);
figure(400); hold on;
plot(TF.r,Plank);        

%---------------------------------------------
% Combine
%---------------------------------------------  
KaiserPlank = Plank.*Kaiser;
figure(400); hold on;
plot(TF.r,KaiserPlank);

%---------------------------------------------
% Plot Profiles
%---------------------------------------------        
psfKaiser = ifftshift(ifft([Kaiser zeros(1,179999) flip(Kaiser(2:end),2)]));
psfPlank = ifftshift(ifft([Plank zeros(1,179999) flip(Plank(2:end),2)]));
psfKaiserPlank = ifftshift(ifft([KaiserPlank zeros(1,179999) flip(KaiserPlank(2:end),2)]));
figure(500); hold on;
L = length(psfKaiser);
plot(psfKaiser(L/2-200:L/2+199)/max(psfPlank));
plot(psfPlank(L/2-200:L/2+199)/max(psfPlank));
plot(psfKaiserPlank(L/2-200:L/2+199)/max(psfPlank));

%---------------------------------------------
% Output
%---------------------------------------------  
TF.tf = KaiserPlank;

%----------------------------------------------------
% Panel Items
%----------------------------------------------------
Panel(1,:) = {'TF_Shape','KaiserPlank','Output'};
Panel(2,:) = {'TF_beta',TF.beta,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
TF.PanelOutput = PanelOutput;


