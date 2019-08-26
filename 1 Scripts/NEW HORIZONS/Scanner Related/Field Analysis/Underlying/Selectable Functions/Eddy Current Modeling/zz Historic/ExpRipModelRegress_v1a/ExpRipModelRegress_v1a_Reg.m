%=========================================================
% 
%=========================================================

function E = ExpRipModelRegress_v1a_Reg(V,ECM,INPUT)

%---------------------------------------------
% Get Input
%---------------------------------------------
TimeSub = INPUT.TimeSub;
eddySub = INPUT.eddySub;
GdesSub = INPUT.GdesSub;
gstepdur = INPUT.gstepdur;
clear INPUT

%---------------------------------------------
% Variables
%---------------------------------------------

%---------------------------------------------
% Test Number of Exponentials
%---------------------------------------------
if length(V) == 5
    tc = V(1);
    mag = V(2)*1000;
    sincfreq = V(3)*1000;
    sinctc = V(4);    
    sincmag = V(5)*1000;   
elseif length(V) == 7
    tc = [V(1) V(3)];
    mag = [V(2) V(4)]*1000;
    sincfreq = V(5)*1000;
    sinctc = V(6);    
    sincmag = V(7)*1000;       
end
    
%---------------------------------------------
% Exponenetial Decay
%---------------------------------------------
eddydur = 6*max(tc(:));
t = (0:gstepdur:eddydur);
eddylen = length(t);
N = length(tc);
eddy0 = zeros(N,eddylen);
    for n = 1:N
        if tc(n) == 0
            if mag(n) ~= 0
                error();
            end   
            tc(n) = 1;
        end
        eddy0(n,:) = 0.01*mag(n)*exp(-t/tc(n));
    end
eddy = squeeze(sum(eddy0,1));

%---------------------------------------------
% Sinc
%---------------------------------------------
expdecay = 0.01*sincmag*exp(-t/sinctc);
sincresp = sinc(pi*sincfreq*t).*expdecay;
totresp = sincresp - eddy;

%---------------------------------------------
% Plot Eddy Currents
%---------------------------------------------
clf(figure(1));
figure(1); hold on;
%plot(t,-squeeze(eddy0(:,:)));
plot(t,sincresp,'r','linewidth',2);
plot(t,-eddy,'g','linewidth',2);
plot(t,totresp,'k','linewidth',2);
title('x-eddy');


%---------------------------------------------
% Compensate
%---------------------------------------------
gradlen = length(GdesSub);
Geddy = zeros(1,gradlen+eddylen);
Teddy = (0:gstepdur:(gradlen+eddylen-1)*gstepdur);
Geddy(1:eddylen) = 0*totresp;
for n = 2:gradlen
    %test = (GdesSub(m,n)-GdesSub(m,n-1))
    Geddy(n:n+eddylen-1) = Geddy(n:n+eddylen-1) + (GdesSub(n)-GdesSub(n-1))*totresp;
end
Geddyadd = [GdesSub;zeros(eddylen,1)]+permute(Geddy,[2 1]);

%---------------------------------------------
% Find Error
%---------------------------------------------
E = permute(eddySub,[2 1]) - Geddyadd(1:length(eddySub));  

%---------------------------------------------
% Plot 
%---------------------------------------------
clf(figure(11));
figure(11); hold on;
plot(Teddy,Geddy,'r-');
plot(Teddy,Geddyadd,'b-');
plot(TimeSub,eddySub,'k');
plot(TimeSub,GdesSub,'g');

clf(figure(12));
figure(12); hold on;
plot(TimeSub,E,'k');
test = 0;

  