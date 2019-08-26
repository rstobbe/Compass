%==================================
% 
%==================================

function [SCRPTipt,SCRPTGBL,err] = MonoExp_v1a(SCRPTipt,SCRPTGBL)

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
datastart = str2double(SCRPTGBL.CurrentTree.('DataStart'));
datastop = str2double(SCRPTGBL.CurrentTree.('DataStop'));
timepastg = SCRPTGBL.CurrentTree.('TimePastG');
tcest = str2double(SCRPTGBL.CurrentTree.('Tc_Estimate'));
figno = str2double(SCRPTGBL.CurrentTree.('Figure_Number'));
seleddy = SCRPTGBL.CurrentTree.('SelectEddy');

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
if strcmp(seleddy,'B0eddy') && goodB0 == 0
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
eddy = EDDY.(seleddy);

%-----------------------------------------------------
% Other (Testing)
%-----------------------------------------------------
%time = EDDY.TF.LongEddyTime;
%eddy = EDDY.TF.LongB0eddy;

%-----------------------------------------------------
% Isolate Segment
%-----------------------------------------------------
ind1 = find(time>=datastart,1,'first');
ind2 = find(time<=datastop,1,'last');
if isempty(ind2)
    ind2 = length(time);
end
if strcmp(timepastg,'na')
    timeSub = time;
    eddySub = NaN*zeros(size(timeSub));
    eddySub(ind1:ind2) = eddy(ind1:ind2);
    timepastg = 0;
else
    timepastg = str2double(timepastg);
    timeSub = time(ind1:ind2);
    timeSub = timeSub - timeSub(1) + timepastg;
    eddySub = eddy(ind1:ind2);
end

%-----------------------------------------------------
% Initial Plot
%-----------------------------------------------------
figure(figno); hold on;
%plot(time,eddy*1000,'k:');
plot(timeSub,eddySub*1000,'k');
plot([0 max(time)],[0 0],'k:'); 
ylim([-max(abs(eddy*1000)) max(abs(eddy*1000))]);

%-----------------------------------------------------
% Regression
%-----------------------------------------------------
ind = find(not(isnan(eddySub)),1,'first');
magest = eddySub(ind);
func = @(P,t) P(1)*exp(-t/P(2)); 
Est = [magest tcest];
options = statset('Robust','off','WgtFun','');
[beta,resid,jacob,sigma,mse] = nlinfit(timeSub,eddySub,func,Est,options);
beta
ci = nlparci(beta,resid,'covar',sigma)

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
Fit.interptime = (0:step:timeSub(length(timeSub)));
Fit.interpvals = beta(1)*(exp(-(Fit.interptime)/beta(2)));
Fit.interptime = Fit.interptime;
%Fit.interptime = Fit.interptime + datastart - timepastg;

clr = 'r';
figure(figno); hold on;
plot(Fit.interptime,Fit.interpvals*1000,[clr,'-'],'linewidth',2);
%plot(time,eddy*1000,'k*');

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
Panel(1,:) = {'Tc (ms)',beta(2),'Output'};
if strcmp(seleddy,'B0eddy') 
    Panel(2,:) = {'Mag (uT)',beta(1)*1000,'Output'};
    Panel(3,:) = {'CompVal (%)',beta(1)*1000/(B0cal*gval),'Output'};
else
    Panel(2,:) = {'Mag (uT/m)',beta(1)*1000,'Output'};
    Panel(3,:) = {'CompVal (%)',-100*Gcal*beta(1)/gval,'Output'};    
end
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
RGRS.PanelOutput = PanelOutput;
SCRPTGBL.RWSUI.LocalOutput = RGRS.PanelOutput;

%--------------------------------------------
% Output Structure
%--------------------------------------------

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


