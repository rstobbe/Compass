%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = LoadScriptFileCur(SCRPTipt,SCRPTGBL)

global FIGOBJS

Status('busy','Select Script File');
Status2('done','',2); 
Status2('done','',3); 

INPUT.Extension = '*.mat';
INPUT.CurFunc = 'LoadScriptFileCur';
INPUT.DropExt = 'Yes';
INPUT.Type = 'Script';
INPUT.AssignPath = 'Yes';
[SCRPTipt,SCRPTGBL,saveData0,err] = SelectGeneralFileCur_v5(SCRPTipt,SCRPTGBL,INPUT);
if err.flag
    return
end

if not(isempty(saveData0))
    
    %------------------------------------------
    % Load
    %------------------------------------------
    Status('busy','Load Script File');
    saveData = [];
    load(saveData0.loc);
    if not(exist('saveData','var'))
        err.flag = 1;
        err.msg = 'Not an RWS Script Output File';
        return
    end
    name = fieldnames(saveData);
    if length(name) > 1
        error;              % finish
    end
    name = name{1};
    saveData0.(name) = saveData.(name);
    saveData = saveData0;
    
    %------------------------------------------
    % Show Info
    %------------------------------------------
    if not(isfield(saveData.(name),'ExpDisp'))
        saveData.(name).ExpDisp = '';
    end
    
    if strcmp(SCRPTGBL.RWSUI.tab(1:2),'IM')
        FIGOBJS.(SCRPTGBL.RWSUI.tab).InfoL.String = saveData.(name).ExpDisp;
    else
        FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = saveData.(name).ExpDisp;
    end

    %------------------------------------------
    % Update Name/Path
    %------------------------------------------
    saveData.(name).name = saveData.file(1:end-4);
    saveData.(name).path = saveData.path;

    %--------------------------------------------
    % Save
    %--------------------------------------------
    SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.display = saveData.(name).ExpDisp;
    
    funclabel = SCRPTGBL.RWSUI.funclabel;
    callingfuncs = SCRPTGBL.RWSUI.callingfuncs;
    if isempty(callingfuncs)
        SCRPTGBL.([funclabel,'_Data']) = saveData;
    elseif length(callingfuncs) == 1
        SCRPTGBL.([callingfuncs{1},'_Data']).([funclabel,'_Data']) = saveData;
    elseif length(callingfuncs) == 2
        SCRPTGBL.([callingfuncs{1},'_Data']).([callingfuncs{2},'_Data']).([funclabel,'_Data']) = saveData;
    end   
end

Status('done','');
Status2('done','',2); 
Status2('done','',3); 
