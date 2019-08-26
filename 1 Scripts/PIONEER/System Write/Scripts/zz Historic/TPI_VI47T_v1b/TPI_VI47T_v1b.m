%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = TPI_VI47T_v1b(SCRPTipt,SCRPTGBL)

err.flag = 0;
err.msg = '';

if not(isfield(SCRPTGBL,'Imp_File'))
    err.flag = 1;
    err.msg = '(Re)Load Implementation File';
    return
end

wrtgradfunc = str2func(SCRPTGBL.CurrentTree.WrtGradfunc.Func);
wrtparamfunc = str2func(SCRPTGBL.CurrentTree.WrtParamfunc.Func);
wrtrefocusfunc = str2func(SCRPTGBL.CurrentTree.WrtRefocusfunc.Func);

WRT.wrtgradfunc = SCRPTGBL.CurrentTree.WrtGradfunc;
WRT.wrtparamfunc = SCRPTGBL.CurrentTree.WrtParamfunc;
WRT.wrtrefocusfunc = SCRPTGBL.CurrentTree.WrtRefocusfunc;
WRT.G = SCRPTGBL.Imp_File.G;
GQNT = SCRPTGBL.Imp_File.PROJimp.GQNT;
WRT.rdur = [GQNT.idivno GQNT.twdivno*(ones(1,GQNT.twwords+1))];
WRT.Kend = SCRPTGBL.Imp_File.Kend;
WRT.gamma = SCRPTGBL.Imp_File.PROJimp.gamma;
WRT.sym = SCRPTGBL.Imp_File.PROJimp.sym;
WRT.dwell = SCRPTGBL.Imp_File.PROJimp.dwell;
WRT.npro = SCRPTGBL.Imp_File.PROJimp.npro;
WRT.tro = SCRPTGBL.Imp_File.PROJimp.tro;
WRT.sampstart = SCRPTGBL.Imp_File.PROJimp.sampstart;
WRT.tgwfm = SCRPTGBL.Imp_File.PROJimp.tgwfm;
WRT.split = SCRPTGBL.Imp_File.PROJimp.split;
WRT.projmult = SCRPTGBL.Imp_File.PROJimp.projmult;
WRT.filBW = SCRPTGBL.Imp_File.PROJimp.filBW;
WRT.vox = SCRPTGBL.Imp_File.PROJdgn.vox;
WRT.fov = SCRPTGBL.Imp_File.PROJdgn.fov;
WRT.elip = SCRPTGBL.Imp_File.PROJdgn.elip;
WRT.nproj = SCRPTGBL.Imp_File.PROJdgn.nproj;
WRT.ProjSet = SCRPTGBL.Imp_File.PROJdgn.Name;

[SCRPTipt,WRT,err] = wrtgradfunc(SCRPTipt,WRT);
if err.flag
    return
end
[GradLabel] = TruncFileNameForDisp_v1(WRT.GradLoc);

[SCRPTipt,WRT,err] = wrtrefocusfunc(SCRPTipt,WRT);
if err.flag == 1
    return
end
[RefocusLabel] = TruncFileNameForDisp_v1(WRT.RefocusLoc);

[WRT,SCRPTipt,err] = wrtparamfunc(WRT,SCRPTipt,err);
if err.flag == 1
    return
end
[ParamLabel] = TruncFileNameForDisp_v1(WRT.ParamLoc);

SCRPTGBL.RWSUI.LocalOutput(1).label = 'GradLoc';
SCRPTGBL.RWSUI.LocalOutput(1).value = GradLabel;
SCRPTGBL.RWSUI.LocalOutput(2).label = 'RefocusLoc';
SCRPTGBL.RWSUI.LocalOutput(2).value = RefocusLabel;
SCRPTGBL.RWSUI.LocalOutput(3).label = 'ParamLoc';
SCRPTGBL.RWSUI.LocalOutput(3).value = ParamLabel;

