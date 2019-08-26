%==================================================
% 
%==================================================

function [SCRPTipt,SCRPTGBL,err] = Plot_QA_v1a(SCRPTipt,SCRPTGBL)

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
% Test
%-----------------------------------------------------
if not(isfield(EDDY,'Geddy'))
    err.flag = 1;
    err.msg = 'Global does not contain eddy currents';
    return
end

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
% Test for B0 Plotting
%-----------------------------------------------------
Params = EDDY.TF.Params;
if strcmp(Params.graddir,Params.position)
    plotB0 = 1;
else
    plotB0 = 0;
end

%-----------------------------------------------------
% Calibration
%-----------------------------------------------------
B0cal = EDDY.B0cal;
gval = EDDY.gval;
rB0cal = B0cal*gval;

%-----------------------------------------------------
% Plot Long Eddy
%-----------------------------------------------------
Time = EDDY.TF.LongEddyTime;
Geddy = EDDY.TF.LongGeddy;
B0eddy = EDDY.TF.LongB0eddy;
if strcmp(type,'Abs')
    figure(1000); hold on; 
    plot([0 max(Time/1000)],[0 0],'k:'); 
    plot(Time/1000,Geddy*1000,clr);     
    ylim([-max(abs(Geddy*1000)) max(abs(Geddy*1000))]);  xlim([0 max(Time/1000)]);
    xlabel('(seconds)'); ylabel('Gradient Evolution (uT/m)'); title('Transient Field (Gradient)'); OutStyle;
    if plotB0 == 1
        figure(1001); hold on; 
        plot([0 max(Time/1000)],[0 0],'k:'); 
        plot(Time/1000,B0eddy*1000,clr); 
        ylim([-max(abs(B0eddy*1000)) max(abs(B0eddy*1000))]); xlim([0 max(Time/1000)]); 
        xlabel('(seconds)'); ylabel('B0 Evolution (uT)'); title('Transient Field (B0)'); OutStyle;
    end
elseif strcmp(type,'VPercent')
    figure(1000); hold on; 
    plot([0 max(Time/1000)],[0 0],'k:'); 
    plot(Time/1000,100*Geddy/gval,clr);     
    %ylim([-max(abs(100*Geddy/gval)) max(abs(100*Geddy/gval))]);
    ylim([-0.1 0.1]); xlim([0 max(Time/1000)]);
    xlabel('(seconds)'); ylabel('Gradient Evolution (%)'); title('Transient Field (Gradient)'); OutStyle;
    if plotB0 == 1
        figure(1001); hold on; 
        plot([0 max(Time/1000)],[0 0],'k:'); 
        plot(Time/1000,B0eddy*1000/rB0cal,clr);
        ylim([-max(abs(B0eddy*1000/rB0cal)) max(abs(B0eddy*1000/rB0cal))]); xlim([0 max(Time/1000)]);
        xlabel('(seconds)'); ylabel('B0 Evolution (%)'); title('Transient Field (B0)'); OutStyle;
    end
elseif strcmp(type,'Relative')
    figure(1000); hold on; 
    plot([0 max(Time/1000)],[0 0],'k:'); 
    plot(Time/1000,100*Geddy/gval,clr);     
    %ylim([-max(abs(100*Geddy/gval)) max(abs(100*Geddy/gval))]);  xlim([0 max(Time/1000)]);
    ylim([-0.1 0.1]); xlim([0 max(Time/1000)]);
    xlabel('(seconds)'); ylabel('Gradient Evolution (%)'); title('Transient Field (Gradient)'); OutStyle;
    if plotB0 == 1
        figure(1001); hold on; 
        plot([0 max(Time/1000)],[0 0],'k:'); 
        plot(Time/1000,B0eddy*1000/gval,clr);
        %ylim([-max(abs(B0eddy*1000/gval)) max(abs(B0eddy*1000/gval))]); xlim([0 max(Time/1000)]);
        ylim([-0.02 0.02]); xlim([0 max(Time/1000)]);
        xlabel('(seconds)'); ylabel('B0 Evolution (uT)/(mT/m)'); title('Transient Field (B0)'); OutStyle;
    end
elseif strcmp(type,'RelativeHz')
    figure(1000); hold on; 
    plot([0 max(Time/1000)],[0 0],'k:'); 
    plot(Time/1000,100*Geddy/gval,clr);     
    %ylim([-max(abs(100*Geddy/gval)) max(abs(100*Geddy/gval))]);  xlim([0 max(Time/1000)]);
    ylim([-0.1 0.1]); xlim([0 max(Time/1000)]);
    xlabel('(seconds)'); ylabel('Gradient Evolution (%)'); title('Transient Field (Gradient)'); OutStyle;
    if plotB0 == 1
        figure(1001); hold on; 
        plot([0 max(Time/1000)],[0 0],'k:'); 
        plot(Time/1000,42.577*B0eddy*1000/gval,clr);
        %ylim([-max(abs(B0eddy*1000/gval)) max(abs(B0eddy*1000/gval))]); xlim([0 max(Time/1000)]);
        ylim([-1 1]); xlim([0 max(Time/1000)]);
        xlabel('(seconds)'); ylabel('B0 Evolution (Hz/mT/m)'); title('Transient Field (B0)'); OutStyle;
    end       
end

%-----------------------------------------------------
% Plot Short Eddy
%-----------------------------------------------------
Time = EDDY.TF.ShortEddyTime;
Geddy = EDDY.TF.ShortGeddy;
B0eddy = EDDY.TF.ShortB0eddy;
if strcmp(type,'Abs')
    figure(2000); hold on; 
    plot([0 max(Time)],[0 0],'k:'); 
    plot(Time,Geddy*1000,clr);     
    xlim([0 max(Time)]); ylim([-max(abs(Geddy*1000)) max(abs(Geddy*1000))]);
    xlabel('(ms)'); ylabel('Gradient Evolution (uT/m)'); title('Transient Field (Gradient)'); OutStyle;
    if plotB0 == 1
        figure(2001); hold on; 
        plot([0 max(Time)],[0 0],'k:'); 
        plot(Time,B0eddy*1000,clr); 
        ylim([-max(abs(B0eddy*1000)) max(abs(B0eddy*1000))]); xlim([0 max(Time)]);
        xlabel('(ms)'); ylabel('B0 Evolution (uT)'); title('Transient Field (B0)'); OutStyle;
    end
elseif strcmp(type,'VPercent')
    figure(2000); hold on; 
    plot([0 max(Time)],[0 0],'k:'); 
    plot(Time,100*Geddy/gval,clr);     
    %ylim([-max(abs(100*Geddy/gval)) max(abs(100*Geddy/gval))]);
    ylim([-0.1 0.1]); xlim([0 max(Time)]);
    xlabel('(ms)'); ylabel('Gradient Evolution (%)'); title('Transient Field (Gradient)'); OutStyle;
    if plotB0 == 1
        figure(2001); hold on; 
        plot([0 max(Time)],[0 0],'k:'); 
        plot(Time,B0eddy*1000/rB0cal,clr);
        ylim([-max(abs(B0eddy*1000/rB0cal)) max(abs(B0eddy*1000/rB0cal))]); xlim([0 max(Time)]);
        xlabel('(ms)'); ylabel('B0 Evolution (%)'); title('Transient Field (B0)'); OutStyle;
    end
elseif strcmp(type,'Relative')
    figure(2000); hold on; 
    plot([0 max(Time)],[0 0],'k:'); 
    plot(Time,100*Geddy/gval,clr);     
    %ylim([-max(abs(100*Geddy/gval)) max(abs(100*Geddy/gval))]);  xlim([0 max(Time)]);
    ylim([-0.1 0.1]); xlim([0 max(Time)]);
    xlabel('(ms)'); ylabel('Gradient Evolution (%)'); title('Transient Field (Gradient)'); OutStyle;
    if plotB0 == 1
        figure(2001); hold on; 
        plot([0 max(Time)],[0 0],'k:'); 
        plot(Time,B0eddy*1000/gval,clr);
        %ylim([-max(abs(B0eddy*1000/gval)) max(abs(B0eddy*1000/gval))]); xlim([0 max(Time)]);
        ylim([-0.02 0.02]); xlim([0 max(Time)]);
        xlabel('(ms)'); ylabel('B0 Evolution (uT)/(mT/m)'); title('Transient Field (B0)'); OutStyle;
    end
elseif strcmp(type,'RelativeHz')
    figure(2000); hold on; 
    plot([0 max(Time)],[0 0],'k:'); 
    plot(Time,100*Geddy/gval,clr);     
    %ylim([-max(abs(100*Geddy/gval)) max(abs(100*Geddy/gval))]);  xlim([0 max(Time)]);
    ylim([-0.1 0.1]); xlim([0 max(Time)]);
    xlabel('(ms)'); ylabel('Gradient Evolution (%)'); title('Transient Field (Gradient)'); OutStyle;
    if plotB0 == 1
        figure(2001); hold on; 
        plot([0 max(Time)],[0 0],'k:'); 
        plot(Time,42.577*B0eddy*1000/gval,clr);
        %ylim([-max(abs(B0eddy*1000/gval)) max(abs(B0eddy*1000/gval))]); xlim([0 max(Time)]);
        %ylim([-1 1]); xlim([0 max(Time)]);
        ylim([-4 4]); xlim([0 20]);
        xlabel('Time Past Gradient (ms)'); ylabel('B0 Evolution (Hz/mT/m)'); title('Transient Field (B0)'); OutStyle;
    end      
end

%===============================================
function OutStyle
outstyle = 1;
if outstyle == 1
    set(gcf,'units','inches');
    set(gcf,'position',[4 4 4 4]);
    set(gcf,'paperpositionmode','auto');
    set(gca,'units','inches');
    set(gca,'position',[0.75 0.5 2.5 2.5]);
    set(gca,'fontsize',10,'fontweight','bold');
    box on;
end