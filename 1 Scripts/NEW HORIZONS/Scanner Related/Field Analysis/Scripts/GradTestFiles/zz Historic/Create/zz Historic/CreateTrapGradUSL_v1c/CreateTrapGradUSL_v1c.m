%=====================================================
% 
%=====================================================

function [SCRPTipt,SCRPTGBL,err] = CreateTrapGradUSL_v1c(SCRPTipt,SCRPTGBL)

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
GRD.pregdur0 = str2double(SCRPTGBL.CurrentTree.('PreGDur'));
GRD.gatmaxdur0 = str2double(SCRPTGBL.CurrentTree.('GatMaxDur'));
GRD.gstepdur = str2double(SCRPTGBL.CurrentTree.('GStepDur'));
GRD.gsl = str2double(SCRPTGBL.CurrentTree.('Gsl'));
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
% Build Gradient Shape
%---------------------------------------------
gstepdur = GRD.gstepdur/1000;
t = (gstepdur:gstepdur:GRD.gmax*GRD.gsl*1.1);
ramp = GRD.gsl*t;
ind = find(ramp >= GRD.gmax,1,'first');
grampup = ramp(1:ind-1);
ramp = GRD.gmax - GRD.gsl*t;
ind = find(ramp <= 0,1,'first');
grampdown = ramp(1:ind-1);

preglen = round(GRD.pregdur0/gstepdur);
GRD.pregdur = preglen*gstepdur;
gatmaxlen = round(GRD.gatmaxdur0/gstepdur);
GRD.gatmaxdur = gatmaxlen*gstepdur;

G0 = [zeros(1,preglen) grampup GRD.gmax*ones(1,gatmaxlen) grampdown 0];
G = [G0;G0;G0]';
T = (0:gstepdur:gstepdur*(length(G0)-1));

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
plot([0 L(length(L))],[0 0],':');

%---------------------------------------------
% Write to Structure
%---------------------------------------------
GRD.G = G;
GRD.T = T;
GRD.L = L;
GRD.Gvis = Gvis;
GRD.graddur = gstepdur*length(G0); 

%---------------------------------------------
% Test
%---------------------------------------------
test = GRD.T(length(GRD.T)) + gstepdur;
if GRD.graddur ~= test
    error();
end

%---------------------------------------------
% Write Gradients
%---------------------------------------------
WRTG.G = G;
WRTG.rdur = ones(1,length(G));
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

    