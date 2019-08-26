%====================================================
% (v1a)
%   
%====================================================

function [SCRPTipt,SCRPTGBL,err] = GradEddy_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Determine Gradient Eddies (RF pulse after gradient)');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
Sys = SCRPTGBL.CurrentTree.System;
B0cal = str2double(SCRPTGBL.CurrentTree.B0);
Gcal = str2double(SCRPTGBL.CurrentTree.G);
psbgfunc = SCRPTGBL.CurrentTree.PosBgrndfunc.Func;
tgfunc = SCRPTGBL.CurrentTree.TransGradfunc.Func;

%-----------------------------------------------------
% Determine Probe Displacement and BackGround Fields
%-----------------------------------------------------
func = str2func(psbgfunc);
[SCRPTipt,SCRPTGBL,err] = func(SCRPTipt,SCRPTGBL);
if err.flag
    ErrDisp(err);
    return
end

%-----------------------------------------------------
% Determine Transient Gradient Fields
%-----------------------------------------------------
func = str2func(tgfunc);
[SCRPTipt,SCRPTGBL,err] = func(SCRPTipt,SCRPTGBL);
if err.flag
    ErrDisp(err);
    return
end

%-----------------------------------------------------
% Display Experiment Parameters
%-----------------------------------------------------
set(findobj('tag','TestBox'),'string',[SCRPTGBL.PosBG.ExpDisp SCRPTGBL.TF.ExpDisp]);

%---------------------------------------------
% Display
%---------------------------------------------
SCRPTGBL.RWSUI.LocalOutput(1).label = 'Loc1 (cm)';
SCRPTGBL.RWSUI.LocalOutput(1).value = num2str(SCRPTGBL.PosBG.Loc1*100);
SCRPTGBL.RWSUI.LocalOutput(2).label = 'Loc2 (cm)';
SCRPTGBL.RWSUI.LocalOutput(2).value = num2str(SCRPTGBL.PosBG.Loc2*100);
SCRPTGBL.RWSUI.LocalOutput(3).label = 'Sep (cm)';
SCRPTGBL.RWSUI.LocalOutput(3).value = num2str(SCRPTGBL.PosBG.Sep*100);
SCRPTGBL.RWSUI.LocalOutput(4).label = 'BG_Grad (uT/m)';
SCRPTGBL.RWSUI.LocalOutput(4).value = num2str(SCRPTGBL.PosBG.meanBGGrad*1000);
SCRPTGBL.RWSUI.LocalOutput(5).label = 'BG_B0 (uT)';
SCRPTGBL.RWSUI.LocalOutput(5).value = num2str(SCRPTGBL.PosBG.meanBGB0*1000);

%--------------------------------------------
% Output
%--------------------------------------------
ExpDisp = [SCRPTGBL.PosBG.ExpDisp SCRPTGBL.TF.ExpDisp];
Eddy.ExpDisp = ExpDisp;
Eddy.Params.Sys = Sys;
Eddy.Params.B0cal = B0cal;
Eddy.Params.gcal = Gcal;
Eddy.Params.Loc1 = SCRPTGBL.PosBG.Loc1;
Eddy.Params.Loc2 = SCRPTGBL.PosBG.Loc1;
Eddy.Params.Sep = SCRPTGBL.PosBG.Sep;
Eddy.Params.gval = SCRPTGBL.TF.gval;
Eddy.Output.Time = SCRPTGBL.TF.Time;
Eddy.Output.Geddy = SCRPTGBL.TF.Geddy;
Eddy.Output.B0eddy = SCRPTGBL.TF.B0eddy;
Eddy.PosBG = SCRPTGBL.PosBG;
Eddy.TF = SCRPTGBL.TF;

SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = SCRPTGBL.TF.Path;
SCRPTGBL.RWSUI.SaveVariables = {Eddy};
SCRPTGBL.RWSUI.SaveVariableNames = {'Eddy'};


