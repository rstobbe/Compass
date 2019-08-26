%====================================================
% (v1a)
%   - update for RWS_BA
%====================================================

function [SCRPTipt,SCRPTGBL,err] = PostGradEddy_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Determine Gradient Eddies (RF pulse after gradient)');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

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

%-------------------------------------
% Return
%-------------------------------------
Eddy.ExpDisp = [SCRPTGBL.PosBG.ExpDisp SCRPTGBL.TF.ExpDisp];
Eddy.Sys = Sys;
Eddy.B0cal = B0cal;
Eddy.gcal = Gcal;
Eddy.Loc1 = SCRPTGBL.PosBG.Loc1;
Eddy.Loc2 = SCRPTGBL.PosBG.Loc1;
Eddy.Sep = SCRPTGBL.PosBG.Sep;
Eddy.gval = SCRPTGBL.TF.gval;
Eddy.Time = SCRPTGBL.TF.Time;
Eddy.Geddy = SCRPTGBL.TF.Geddy;
Eddy.B0eddy = SCRPTGBL.TF.B0eddy;

SCRPTGBL.Eddy = Eddy;

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
PosBG = SCRPTGBL.PosBG;
TF = SCRPTGBL.TF;
Eddy = SCRPTGBL.Eddy;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = '';
SCRPTGBL.RWSUI.SaveVariables = {PosBG,TF,Eddy};
SCRPTGBL.RWSUI.SaveVariableNames = {'PosBG','TF','Eddy'};


