%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = Plot_Object_v1a(SCRPTipt,SCRPTGBL)

SCRPTGBL.TextBox = '';
SCRPTGBL.Figs = [];
SCRPTGBL.Data = [];
err.flag = 0;
err.msg = '';

obfunc = (SCRPTipt(strcmp('Objectfunc',{SCRPTipt.labelstr})).entrystr); 
func = str2func(obfunc);
[SCRPTipt,SCRPTGBL,err] = func(SCRPTipt,SCRPTGBL);

Ob = SCRPTGBL.Ob;
ObMatSz = SCRPTGBL.ObMatSz;

IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = ObMatSz; 
IMSTRCT.rows = 8; IMSTRCT.lvl = [0 2]; IMSTRCT.docolor = 0; IMSTRCT.SLab = 1; IMSTRCT.figno = 1; 

AxialMontage_v2a(Ob,IMSTRCT);
