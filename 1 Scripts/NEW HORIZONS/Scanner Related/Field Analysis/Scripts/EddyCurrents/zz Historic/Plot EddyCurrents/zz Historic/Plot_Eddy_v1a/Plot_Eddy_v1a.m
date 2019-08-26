%==================================================
% 
%==================================================

function [SCRPTipt,SCRPTGBL,err] = Plot_Eddy_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Plot Eddy Currents');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get EDDY Currents
%---------------------------------------------
global TOTALGBL
val = get(findobj('tag','totalgbl'),'value');
if isempty(val) || val == 0
    err.flag = 1;
    err.msg = 'No EDDY in Global Memory';
    return  
end
EDDY = TOTALGBL{2,val};

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
clr = SCRPTGBL.CurrentTree.('Colour');
type = SCRPTGBL.CurrentTree.('Type');

%-----------------------------------------------------
% Display Experiment Parameters
%-----------------------------------------------------
set(findobj('tag','TestBox'),'string',EDDY.ExpDisp);

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
Time = EDDY.Time;
Geddy = EDDY.Geddy;
B0eddy = EDDY.B0eddy;
B0cal = EDDY.B0cal;
gval = EDDY.gval;

rB0cal = B0cal*gval;
if strcmp(type,'Abs')
    figure(1000); hold on; 
    plot([0 max(Time)],[0 0],'k:'); 
    plot(Time,Geddy*1000,clr);     
    ylim([-max(abs(Geddy*1000)) max(abs(Geddy*1000))]);
    xlabel('(ms)'); ylabel('Gradient Evolution (uT/m)'); xlim([0 max(Time)]); title('Transient Field (Gradient)');

    figure(1001); hold on; 
    plot([0 max(Time)],[0 0],'k:'); 
    plot(Time,B0eddy*1000,clr); 
    ylim([-max(abs(B0eddy*1000)) max(abs(B0eddy*1000))]);
    xlabel('(ms)'); ylabel('B0 Evolution (uT)'); xlim([0 max(Time)]); title('Transient Field (B0)');
elseif strcmp(type,'Percent')
    figure(1000); hold on; 
    plot([0 max(Time)],[0 0],'k:'); 
    plot(Time,100*Geddy/gval,clr);     
    ylim([-max(abs(100*Geddy/gval)) max(abs(100*Geddy/gval))]);
    xlabel('(ms)'); ylabel('Gradient Evolution (%)'); xlim([0 max(Time)]); title('Transient Field (Gradient)');

    figure(1001); hold on; 
    plot([0 max(Time)],[0 0],'k:'); 
    plot(Time,B0eddy*1000/rB0cal,clr);
    ylim([-max(abs(B0eddy*1000/rB0cal)) max(abs(B0eddy*1000/rB0cal))]);
    xlabel('(ms)'); ylabel('B0 Evolution (%)'); xlim([0 max(Time)]); title('Transient Field (B0)');
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