%==================================
% 
%==================================

function [SCRPTipt,SCRPTGBL,err] = MonoExp_v1b(SCRPTipt,SCRPTGBL)

Status('busy','Regress Eddy Currents');
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
RGRS.datastart = str2double(SCRPTGBL.CurrentTree.('DataStart'));
RGRS.datastop = str2double(SCRPTGBL.CurrentTree.('DataStop'));
RGRS.timepastg = SCRPTGBL.CurrentTree.('TimePastG');
RGRS.tcest = str2double(SCRPTGBL.CurrentTree.('Tc_Estimate'));
RGRS.seleddy = SCRPTGBL.CurrentTree.('SelectEddy');
figno = str2double(SCRPTGBL.CurrentTree.('Figure_Number'));

%-----------------------------------------------------
% Display Experiment Parameters
%-----------------------------------------------------
set(findobj('tag','TestBox'),'string',EDDY.ExpDisp);

%-----------------------------------------------------
% Test for B0 Viability
%-----------------------------------------------------
Params = EDDY.TF.Params;
if strcmp(Params.graddir,Params.position)
    goodB0 = 1;
else
    goodB0 = 0;
end
if strcmp(RGRS.seleddy,'B0eddy') && goodB0 == 0
    err.flag = 1;
    err.msg = 'Experiment not compatible with B0 measurement';
    return
end

%-----------------------------------------------------
% Get Values
%-----------------------------------------------------
B0cal = EDDY.B0cal;
Gcal = EDDY.Gcal;
gval = EDDY.gval;
time = EDDY.Time;
eddy = EDDY.(RGRS.seleddy);

%-----------------------------------------------------
% Other (Testing)
%-----------------------------------------------------
%time = EDDY.TF.ShortEddyTime;
%eddy = EDDY.TF.ShortB0eddy;
%eddy = EDDY.TF.ShortGeddy;
%time = EDDY.TF.LongEddyTime;
%eddy = EDDY.TF.LongB0eddy;
%eddy = EDDY.TF.LongGeddy;

%-----------------------------------------------------
% Isolate Segment
%-----------------------------------------------------
ind1 = find(time>=RGRS.datastart,1,'first');
ind2 = find(time<=RGRS.datastop,1,'last');
if isempty(ind2)
    ind2 = length(time);
end
if strcmp(RGRS.timepastg,'na')
    RGRS.timepastg = 0;
    timeSub = time(ind1:ind2);
    eddySub = eddy(ind1:ind2);
    timePlot = timeSub;
    eddyPlot = eddySub; 
    scale = 1000;
else
    RGRS.timepastg = str2double(RGRS.timepastg);
    timeSub = time(ind1:ind2);
    timeSub = timeSub - timeSub(1) + RGRS.timepastg;
    eddySub = eddy(ind1:ind2);
    timePlot = time(ind1:ind2);
    eddyPlot = eddy(ind1:ind2);
    scale = 1;
end

%-----------------------------------------------------
% Initial Plot
%-----------------------------------------------------
figure(figno); hold on;
plot(timePlot,eddyPlot*scale,'b','linewidth',2);
plot([0 max(time)],[0 0],'k:'); 
ylim([-max(abs(eddy*scale)) max(abs(eddy*scale))]);

%-----------------------------------------------------
% Save
%-----------------------------------------------------
RGRS.timeSub = timeSub;
RGRS.eddySub = eddySub;

%-----------------------------------------------------
% Regression
%-----------------------------------------------------
ind = find(not(isnan(eddySub)),1,'first');
magest = eddySub(ind);
func = @(P,t) P(1)*exp(-t/P(2)); 
Est = [magest RGRS.tcest];
options = statset('Robust','off','WgtFun','');
[beta,resid,jacob,sigma,mse] = nlinfit(timeSub,eddySub,func,Est,options);
beta
ci = nlparci(beta,resid,'covar',sigma)
RGRS.beta = beta;
RGRS.ci = ci;

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
step = 0.01;
if timeSub(length(timeSub)) > 10000
    step = 10;
elseif timeSub(length(timeSub)) > 1000
    step = 1;
elseif timeSub(length(timeSub)) > 100
    step = 0.1;
end
RGRS.interptime = (0:step:timeSub(length(timeSub)));
RGRS.interpvals = beta(1)*(exp(-(RGRS.interptime)/beta(2)));
RGRS.interptime = RGRS.interptime + RGRS.datastart - RGRS.timepastg;

clr = 'r';
figure(figno); hold on;
plot(RGRS.interptime,RGRS.interpvals*scale,[clr,'-'],'linewidth',2);
%plot(time,eddy*scale,'k*');

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
Panel(1,:) = {'Tc (ms)',beta(2),'Output'};
if strcmp(RGRS.seleddy,'B0eddy') 
    Panel(2,:) = {'Mag (uT)',beta(1)*scale,'Output'};
    RGRS.CompVpcnt = beta(1)*scale/(B0cal*gval);
    Panel(3,:) = {'CompVal (%)',beta(1)*scale/(B0cal*gval),'Output'};
else
    Panel(2,:) = {'Mag (mT/m)',beta(1)*scale,'Output'};
    RGRS.CompPcnt = -100*beta(1)/gval;
    RGRS.CompVpcnt = -100*Gcal*beta(1)/gval;
    Panel(3,:) = {'CompPcnt (%)',-100*beta(1)/gval,'Output'};  
    Panel(4,:) = {'CompVPcnt (%)',-100*Gcal*beta(1)/gval,'Output'};    
end
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
RGRS.PanelOutput = PanelOutput;
SCRPTGBL.RWSUI.LocalOutput = RGRS.PanelOutput;

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Eddy Current Regression:');
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
SCRPTipt(strcmp('Rgrs_Name',{SCRPTipt.labelstr})).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {RGRS};
SCRPTGBL.RWSUI.SaveVariableNames = {'RGRS'};

SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;

SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name{1};

