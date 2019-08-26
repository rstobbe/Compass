%==================================================
% 
%==================================================

function [PLOT,err] = Plot_RFPostGrad_v1c_Func(PLOT,INPUT)

Status('busy','Plot Transient Fields After Gradient');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
EDDY = INPUT.EDDY;
clear INPUT;

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
Time = EDDY.Time;
Geddy = EDDY.Geddy;
B0eddy = EDDY.B0eddy;
B0cal = EDDY.B0cal;
gval = EDDY.gval;

rB0cal = B0cal*gval;

if Time(end) > 5000
    Time = Time/1000;
    Timelab = '(s)';
else
    Timelab = '(ms)';
end

if strcmp(PLOT.type,'Abs')
    figure(1000); hold on; 
    plot([0 max(Time)],[0 0],'k:'); 
    plot(Time,Geddy*1000,PLOT.clr);     
    ylim([-max(abs(Geddy*1000)) max(abs(Geddy*1000))]);
    xlabel(Timelab); ylabel('Gradient Evolution (uT/m)'); xlim([0 max(Time)]); title('Transient Field (Gradient)');

    figure(1001); hold on; 
    plot([0 max(Time)],[0 0],'k:'); 
    plot(Time,B0eddy*1000,PLOT.clr); 
    ylim([-max(abs(B0eddy*1000)) max(abs(B0eddy*1000))]);
    xlabel(Timelab); ylabel('B0 Evolution (uT)'); xlim([0 max(Time)]); title('Transient Field (B0)');

elseif strcmp(PLOT.type,'Percent')
    figure(1000); hold on; 
    plot([0 max(Time)],[0 0],'k:'); 
    plot(Time,100*Geddy/gval,PLOT.clr);     
    ylim([-max(abs(100*Geddy/gval)) max(abs(100*Geddy/gval))]);
    xlabel(Timelab); ylabel('Gradient Evolution (%)'); xlim([0 max(Time)]); title('Transient Field (Gradient)');

    figure(1001); hold on; 
    plot([0 max(Time)],[0 0],'k:'); 
    plot(Time,B0eddy*1000/rB0cal,PLOT.clr);
    ylim([-max(abs(B0eddy*1000/rB0cal)) max(abs(B0eddy*1000/rB0cal))]);
    xlabel(Timelab); ylabel('B0 Evolution (%)'); xlim([0 max(Time)]); title('Transient Field (B0)');
end
    
outstyle = 0;
if outstyle == 1
    set(gcf,'units','inches');
    set(gcf,'position',[4 4 4 4]);
    set(gcf,'paperpositionmode','auto');
    set(gca,'units','inches');
    set(gca,'position',[0.75 0.5 2.5 2.5]);
    set(gca,'fontsize',10,'fontweight','bold');
end