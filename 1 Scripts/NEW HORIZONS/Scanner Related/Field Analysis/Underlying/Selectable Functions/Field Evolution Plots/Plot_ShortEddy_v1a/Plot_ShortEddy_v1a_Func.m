%==================================================
% 
%==================================================

function [PLOT,err] = Plot_ShortEddy_v1a_Func(PLOT,INPUT)

Status2('busy','Plot Short Eddy Currents',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
MFEVO = INPUT.MFEVO;
clear INPUT;

%-----------------------------------------------------
% Load Data
%-----------------------------------------------------
Time = MFEVO.TF.Time/1000;
Geddy = MFEVO.TF.Geddy;
B0eddy = MFEVO.TF.B0eddy;
gval = MFEVO.gval;

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
figure(1002); 
clr = 'k';

Time = Time*1000;
subplot(2,1,1); hold on;
plot([0 max(Time)],[0 0],'k:'); 
plot(Time,100*Geddy/gval,clr);     
if max(abs(100*Geddy/gval)) > 0.1
    ylim([-max(abs(100*Geddy/gval)) max(abs(100*Geddy/gval))]);
else
    ylim([-0.1 0.1]);
end
xlabel('(ms)'); ylabel('Gradient Evolution (%)'); xlim([0 max(Time)]); title('Transient Field (Gradient)');

subplot(2,1,2); hold on;
plot([0 max(Time)],[0 0],'k:'); 
plot(Time,B0eddy*1000/gval,clr); 
if max(abs(B0eddy*1000/gval)) > 0.1
    ylim([-max(B0eddy*1000/gval) max(B0eddy*1000/gval)]);
else
    ylim([-0.1 0.1]);
end
xlabel('(ms)'); ylabel('B0 Evolution (uT)/(mT/m)'); xlim([0 max(Time)]); title('Transient Field (B0)');

set(gcf,'units','inches');
set(gcf,'position',[5 1 10 8]);

Status2('done','',2);
Status2('done','',3);