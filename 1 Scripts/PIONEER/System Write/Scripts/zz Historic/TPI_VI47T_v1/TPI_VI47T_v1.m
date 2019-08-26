%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = TPI_VI47T_v1(SCRPTipt,SCRPTGBL)

SCRPTGBL.TextBox = '';
SCRPTGBL.Figs = [];
SCRPTGBL.Data = [];

err.flag = 0;
err.msg = '';

wrtgradfunc = str2func(SCRPTipt(strcmp('WrtGradfunc',{SCRPTipt.labelstr})).entrystr);
wrtparamfunc = str2func(SCRPTipt(strcmp('WrtParamfunc',{SCRPTipt.labelstr})).entrystr);
wrtrefocusfunc = str2func(SCRPTipt(strcmp('WrtRefocusfunc',{SCRPTipt.labelstr})).entrystr);

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
WRT.nproj = SCRPTGBL.Imp_File.PROJdgn.nproj;

[WRT,SCRPTipt,err] = wrtgradfunc(WRT,SCRPTipt,err);
if err.flag == 1
    return
end
[Label] = TruncFileNameForDisp_v1(WRT.GradLoc);
SCRPTipt = AddToPanelOutput(SCRPTipt,'GradLoc','0output',Label,'0text'); 

[WRT,SCRPTipt,err] = wrtrefocusfunc(WRT,SCRPTipt,err);
if err.flag == 1
    return
end
[Label] = TruncFileNameForDisp_v1(WRT.RefocusLoc);
SCRPTipt = AddToPanelOutput(SCRPTipt,'RefocusLoc','0output',Label,'0text'); 

[WRT,SCRPTipt,err] = wrtparamfunc(WRT,SCRPTipt,err);
if err.flag == 1
    return
end
[Label] = TruncFileNameForDisp_v1(WRT.ParamLoc);
SCRPTipt = AddToPanelOutput(SCRPTipt,'ParamLoc','0output',Label,'0text'); 



