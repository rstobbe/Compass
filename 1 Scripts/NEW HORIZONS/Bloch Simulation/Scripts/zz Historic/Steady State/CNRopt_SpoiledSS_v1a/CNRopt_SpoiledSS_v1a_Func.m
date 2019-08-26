%=========================================================
% 
%=========================================================

function [SIMDES,err] = CNRopt_SpoiledSS_v1a_Func(SIMDES,INPUT)

Status('busy','Optimize Spoiled Steady-State CNR');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
clear INPUT

%---------------------------------------------
% Common Variables;
%---------------------------------------------
T1_A = SIMDES.T1_A;
T1_B = SIMDES.T1_B;
TR = SIMDES.TR;
flip = pi*SIMDES.flip/180;

%---------------------------------------------
% Calculate
%---------------------------------------------
for m = 1:length(TR)
    for p = 1:length(flip)
        Sig_A(m,p) = ((1-(exp(-TR(m)/T1_A)))/(1-cos(flip(p))*exp(-TR(m)/T1_A)))*sin(flip(p));
        Sig_B(m,p) = ((1-(exp(-TR(m)/T1_B)))/(1-cos(flip(p))*exp(-TR(m)/T1_B)))*sin(flip(p));
        SigDiff(m,p) = Sig_B(m,p) - Sig_A(m,p);
        RelDiff(m,p) = Sig_B(m,p)/Sig_A(m,p);
        CNR(m,p) = SigDiff(m,p)/sqrt(TR(m));
    end
end

[X,Y] = meshgrid(180*flip/pi,TR);

figure(1000);
surf(X,Y,CNR);
figure(1001);
surf(X,Y,RelDiff);

figure(1002); hold on;
plot(180*flip/pi,squeeze(RelDiff(1,:)),'b');
plot(180*flip/pi,squeeze(RelDiff(length(TR),:)),'r');
xlabel('flip angle');
title('Relative Difference');

figure(1003); hold on;
plot(180*flip/pi,squeeze(CNR(1,:)),'b');
plot(180*flip/pi,squeeze(CNR(length(TR),:)),'r');
xlabel('flip angle');
title('CNR');

Test = 0;
