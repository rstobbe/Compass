%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = LoadScriptFileDisp(SCRPTipt,SCRPTGBL)

global FIGOBJS
err.flag = 0;

%------------------------------------------
% Display Info
%------------------------------------------
if isfield(SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct,'display')
    SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.display;
    FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.display;
else
    FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = '';
end


