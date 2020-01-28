%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = LoadScriptFileDef(SCRPTipt,SCRPTGBL)

global FIGOBJS

Status('busy','Load Script File');
Status2('done','',2); 
Status2('done','',3); 

INPUT.Search = '*.mat';
INPUT.Assign = '';
INPUT.CurFunc = 'LoadScriptFileCur';
INPUT.DropExt = 'Yes';
INPUT.Type = 'Script';
INPUT.AssignPath = 'Yes';
[SCRPTipt,SCRPTGBL,saveData0,err] = SelectGeneralFileDef_v5(SCRPTipt,SCRPTGBL,INPUT);
if err.flag
    return
end

%error;      % seems to work...?

if isfield(saveData0,'structname')
    %------------------------------------------
    % Show Info
    %------------------------------------------
    Struct = saveData0.structname;    
    FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = saveData0.(Struct).ExpDisp;
    SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.display = saveData0.(Struct).ExpDisp;
end

Status('done','');
Status2('done','',2); 
Status2('done','',3); 


