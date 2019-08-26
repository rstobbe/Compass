%==================================================
% 
%==================================================

function [SCRPTipt,SCRPTGBL,err] = Plot_RFPreGrad_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Plot Transient Fields During/After Gradient');
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

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(SCRPTGBL,'GradDes_File_Data'))
    file = SCRPTGBL.CurrentTree.('GradDes_File').Struct.selectedfile;
    if not(exist(file,'file'))
        err.flag = 1;
        err.msg = '(Re) Load GradDes_File';
        ErrDisp(err);
        return
    else
        Status('busy','Load Gradient Design');
        load(file);
        saveData.path = file;
        SCRPTGBL.('GradDes_File_Data') = saveData;
    end
end

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
clr = SCRPTGBL.CurrentTree.('Colour');
type = SCRPTGBL.CurrentTree.('Type');
L = SCRPTGBL.('GradDes_File_Data').GRD.L;
Gvis = SCRPTGBL.('GradDes_File_Data').GRD.Gvis;

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
    plot(Time,-Geddy,clr);     
    %plot(L,Gvis,'k-');
    ylim([-max(abs(Geddy)) max(abs(Geddy))]);
    %ylim([-11 1]); xlim([10.7 11.3]);
    %ylim([-11 1]); xlim([10.5 11.1]);
    xlabel('(ms)'); ylabel('Gradient Evolution (mT/m)'); title('Transient Field (Gradient)'); OutStyle;

    figure(1001); hold on; 
    plot([0 max(Time)],[0 0],'k:'); 
    plot(Time,B0eddy*1000,clr);
    plot(L,10*Gvis/max(Gvis),'k-');
    %ylim([-max(abs(B0eddy*1000)) max(abs(B0eddy*1000))]);
    %ylim([-5 5]); xlim([10 13]);
    xlabel('(ms)'); ylabel('B0 Evolution (uT)'); title('Transient Field (B0)'); OutStyle;
elseif strcmp(type,'Percent')
    figure(1000); hold on; 
    plot([0 max(Time)],[0 0],'k:'); 
    plot(Time,-100*Geddy/gval,clr); 
    %plot(L,Gvis,'k-');
    %ylim([-max(abs(100*Geddy/gval)) max(abs(100*Geddy/gval))]);
    ylim([-1 1]); xlim([9 20]);
    xlabel('(ms)'); ylabel('Gradient Evolution (%)'); title('Transient Field (Gradient)'); OutStyle;

    figure(1001); hold on; 
    plot([0 max(Time)],[0 0],'k:'); 
    plot(Time,B0eddy*1000/rB0cal,clr);
    %ylim([-max(abs(B0eddy*1000/rB0cal)) max(abs(B0eddy*1000/rB0cal))]);
    ylim([-11 0]); xlim([9 20]);
    xlabel('(ms)'); ylabel('B0 Evolution (%)'); title('Transient Field (B0)');  OutStyle;
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