%=========================================================
% 
%=========================================================

function E = ExpModelRegress_v1b_Reg(V,ECM,INPUT)

%---------------------------------------------
% Get Input
%---------------------------------------------
Time = INPUT.Time;
Gmeas = INPUT.Gmeas;
Gdes = INPUT.Gdes;
gstepdur = INPUT.gstepdur;
scale = INPUT.scale;
clear INPUT

%---------------------------------------------
% Variables
%---------------------------------------------

%---------------------------------------------
% Test Number of Exponentials
%---------------------------------------------
if length(V) == 2
    tc = V(1)/scale;
    mag = V(2);
elseif length(V) == 4
    tc = [V(1) V(3)]/scale;
    mag = [V(2) V(4)];
elseif length(V) == 6
    tc = [V(1) V(3) V(5)]/scale;
    mag = [V(2) V(4) V(6)];
end
    
%---------------------------------------------
% Compensation
%---------------------------------------------
eddydur = 12*max(tc(:));
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
% Plot Eddy Currents
%---------------------------------------------
clf(figure(10));
figure(10); hold on;
plot(t,-squeeze(eddy0(:,:))*100);
plot(t,-eddy*100,'k','linewidth',2);
title('Eddy Current from Regression');
xlabel('(ms)'); ylabel('Gradient (%)'); 

%---------------------------------------------
% Compensate
%---------------------------------------------
gradlen = length(Gdes);
Geddy = zeros(1,gradlen+eddylen);
Teddy = (0:gstepdur:(gradlen+eddylen-1)*gstepdur);
Geddy(1:eddylen) = Gdes(1)*eddy;
for n = 2:gradlen
    Geddy(n:n+eddylen-1) = Geddy(n:n+eddylen-1) + (Gdes(n)-Gdes(n-1))*eddy;
end
Geddyadd = [Gdes;zeros(eddylen,1)]-permute(Geddy,[2 1]);

%---------------------------------------------
% Find Error
%---------------------------------------------
E = permute(Gmeas,[2 1]) - Geddyadd(1:length(Gmeas));  

%---------------------------------------------
% Plot 
%---------------------------------------------
clf(figure(11));
figure(11); hold on;
plot(Time,Gdes,'g');
plot(Time,Gmeas,'k');
plot(Teddy,-Geddy,'r-');
plot(Teddy,Geddyadd,'b-');
title('Regressed Transient Field (red) plus Applied Gradient (green) yeilds Projected Field (blue)');
xlabel('(ms)'); ylabel('Gradient (mT/m)'); 

clf(figure(12));
figure(12); hold on;
plot(Time,E,'k');
title('Error Between Data (black) and Projected Gradient Field (blue)');
xlabel('(ms)'); ylabel('Gradient (mT/m)'); 


