%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = LoadKSampDef(SCRPTipt,SCRPTGBL)

global FIGOBJS

Status('busy','Select File');
Status2('done','',2); 
Status2('done','',3); 

INPUT.Search = '*.mat';
INPUT.Assign = 'PROC';
INPUT.CurFunc = 'LoadKSampCur';
INPUT.DropExt = 'Yes';
INPUT.Type = 'PROC';
INPUT.AssignPath = 'Yes';
[SCRPTipt,SCRPTGBL,saveData0,err] = SelectGeneralFileDef_v5(SCRPTipt,SCRPTGBL,INPUT);
if err.flag
    return
end

if isfield(saveData0,'PROC')
    %------------------------------------------
    % Show Info
    %------------------------------------------
    FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = saveData0.PROC.ExpDisp;
    SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.display = saveData0.PROC.ExpDisp;
end

if not(isempty(saveData0)) && not(isfield(saveData0,'PROC'))
    
    %------------------------------------------
    % Load
    %------------------------------------------
    Status('busy','Load File');
    saveData = [];
    load(saveData0.loc);
    if not(exist('saveData','var'))
        err.flag = 1;
        err.msg = 'Not an RWS Script Output File';
        return
    end
    if not(isfield(saveData,'PROC'))
        err.flag = 1;
        err.msg = 'Not an MRI Processing File';
        return
    end
    saveData0.PROC = saveData.PROC;
    saveData = saveData0;
    
    %------------------------------------------
    % Show Info
    %------------------------------------------
    FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = saveData.PROC.ExpDisp;

    %------------------------------------------
    % Update Name/Path
    %------------------------------------------
    saveData.PROC.name = saveData.file(1:end-4);
    saveData.PROC.path = saveData.path;

    %--------------------------------------------
    % Save
    %--------------------------------------------
    SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.display = saveData.PROC.ExpDisp;
    
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


