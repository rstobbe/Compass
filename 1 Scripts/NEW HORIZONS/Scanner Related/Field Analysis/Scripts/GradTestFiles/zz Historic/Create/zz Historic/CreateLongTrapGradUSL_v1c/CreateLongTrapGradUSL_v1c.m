%=====================================================
% 
%=====================================================

function [SCRPTipt,SCRPTGBL,err] = CreateLongTrapGradUSL_v1c(SCRPTipt,SCRPTGBL)

Status('busy','Create Trapazoid Gradient File');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
SCRPTipt(strcmp('Gradient_Name',{SCRPTipt.labelstr})).entrystr = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
GRD.gatmaxdur0 = str2double(SCRPTGBL.CurrentTree.('GatMaxDur'));
GRD.maxgstepdur = str2double(SCRPTGBL.CurrentTree.('MaxGStepDur'));
GRD.gsl = str2double(SCRPTGBL.CurrentTree.('Gsl'));
GRD.rampgstepdur = str2double(SCRPTGBL.CurrentTree.('RampGStepDur'));
GRD.gmax = str2double(SCRPTGBL.CurrentTree.('Gmax'));
GRD.wrtgradfunc = SCRPTGBL.CurrentTree.('WrtGradfunc').Func; 
GRD.wrtparamfunc = SCRPTGBL.CurrentTree.('WrtParamfunc').Func; 

%---------------------------------------------
% Get Working Structures
%---------------------------------------------
WRTG = SCRPTGBL.CurrentTree.('WrtGradfunc');
if isfield(SCRPTGBL,('WrtGradfunc_Data'))
    WRTG.WrtGradfunc_Data = SCRPTGBL.WrtGradfunc_Data;
end
WRTP = SCRPTGBL.CurrentTree.('WrtParamfunc');
if isfield(SCRPTGBL,('WrtParamfunc_Data'))
    WRTP.WrtParamfunc_Data = SCRPTGBL.WrtParamfunc_Data;
end

%---------------------------------------------
% Test
%---------------------------------------------
if rem(GRD.maxgstepdur,GRD.rampgstepdur)
    err.flag = 1;
    err.msg = 'MaxGStepDur must be a multiple of RampGStepDur';
    return
end
if GRD.maxgstepdur/GRD.rampgstepdur > 255
    err.flag = 1;
    err.msg = 'GRD.maxgstepdur/GRD.rampgstepdur must be smaller than 255';
    return
end

%---------------------------------------------
% Build Gradient Shape
%---------------------------------------------
rampgstepdur = GRD.rampgstepdur/1000;
t = (rampgstepdur:rampgstepdur:GRD.gmax*GRD.gsl*1.1);
ramp = GRD.gsl*t;
ind = find(ramp >= GRD.gmax,1,'first');
grampup = ramp(1:ind-1);
ramp = GRD.gmax - GRD.gsl*t;
ind = find(ramp <= 0,1,'first');
grampdown = ramp(1:ind-1);
ramplen = length(grampup);

maxgstepdur = GRD.maxgstepdur/1000;
gatmaxlen = round(GRD.gatmaxdur0/maxgstepdur);
GRD.gatmaxdur = gatmaxlen*maxgstepdur;

G0 = [grampup GRD.gmax*ones(1,gatmaxlen) grampdown 0];
G = [G0;G0;G0]';
Tramp = (0:rampgstepdur:rampgstepdur*(ramplen-1));
Tmax = (0:maxgstepdur:maxgstepdur*(gatmaxlen-1));
T = [Tramp (rampgstepdur*ramplen)+Tmax (rampgstepdur*ramplen)+(maxgstepdur*gatmaxlen)+Tramp ...
        2*(rampgstepdur*ramplen)+(maxgstepdur*gatmaxlen)];

%---------------------------------------------
% Visualize
%---------------------------------------------
Gvis = []; L = [];
for n = 1:length(T)-1
    L = [L [T(n) T(n+1)]];
    Gvis = [Gvis [G(n) G(n)]];
end
L = [L T(length(T))];
Gvis = [Gvis G(length(G))];
figure(1); hold on; 
plot(L,Gvis);
plot(T,G,'*');
plot([0 L(length(L))],[0 0],':');

%---------------------------------------------
% Write to Structure
%---------------------------------------------
GRD.G = G;
GRD.T = T;
GRD.L = L;
GRD.Gvis = Gvis;
GRD.graddur = GRD.T(length(GRD.T)) + rampgstepdur;

%---------------------------------------------
% Relative Duration
%---------------------------------------------
rdur = [ones(1,ramplen) (GRD.maxgstepdur/GRD.rampgstepdur)*ones(1,gatmaxlen) ones(1,ramplen) 1];

%---------------------------------------------
% Test
%---------------------------------------------
test = sum(rdur)*rampgstepdur;
if test ~= GRD.graddur
    error();
end

%---------------------------------------------
% Write Gradients
%---------------------------------------------
WRTG.G = G;
WRTG.rdur = rdur;
func = str2func(GRD.wrtgradfunc);
[SCRPTipt,WRTG,err] = func(SCRPTipt,WRTG);
if err.flag
    return
end

%---------------------------------------------
% Write Parameter File
%--------------------------------------------- 
WRTP.graddur = GRD.graddur;
WRTP.pnum = 1;
WRTP.GradLoc = WRTG.GradLoc;
func = str2func(GRD.wrtparamfunc);
[SCRPTipt,WRTP,err] = func(SCRPTipt,WRTP);
if err.flag 
    return
end

%---------------------------------------------
% Output Structure
%--------------------------------------------- 
GRD.WRTG = WRTG;
GRD.WRTP = WRTP;

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Gradient File:');
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
SCRPTipt(strcmp('Gradient_Name',{SCRPTipt.labelstr})).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {GRD};
SCRPTGBL.RWSUI.SaveVariableNames = {'GRD'};

SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;

SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name{1};

    