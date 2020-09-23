%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = LoadPreloadFidDef(SCRPTipt,SCRPTGBL)

global FIGOBJS

Status('busy','Select PLFID File');
Status2('done','',2); 
Status2('done','',3); 

INPUT.Search = {'PLFID*.mat'};
INPUT.Assign = 'PLFID';
INPUT.CurFunc = 'LoadPreloadFidCur';
INPUT.DropExt = 'Yes';
INPUT.Type = 'TrajImp';
INPUT.AssignPath = 'Yes';
[SCRPTipt,SCRPTGBL,saveData0,err] = SelectGeneralFileDef_v5(SCRPTipt,SCRPTGBL,INPUT);
if err.flag
    return
end

if isfield(saveData0,'PLFID')
    %------------------------------------------
    % Show Info
    %------------------------------------------
    FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = saveData0.PLFID.ExpDisp;
    SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.display = saveData0.PLFID.ExpDisp;
end

if not(isempty(saveData0)) && not(isfield(saveData0,'PLFID'))
    
    %------------------------------------------
    % Load
    %------------------------------------------
    Status('busy','Load PLFID File');
    saveData = [];
    load(saveData0.loc);
    if not(exist('saveData','var'))
        err.flag = 1;
        err.msg = 'Not an RWS Script Output File';
        return
    end
    if not(isfield(saveData,'PLFID'))
        err.flag = 1;
        err.msg = 'Not an PreloadFid File';
        return
    end
    saveData0.PLFID = saveData.PLFID;
    saveData = saveData0;
    
    %------------------------------------------
    % Show Info
    %------------------------------------------
    FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = saveData.PLFID.ExpDisp;

    %------------------------------------------
    % Update Name/Path
    %------------------------------------------
    saveData.PLFID.name = saveData.file(1:end-4);
    saveData.PLFID.path = saveData.path;

    %--------------------------------------------
    % Save
    %--------------------------------------------
    SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.display = saveData.PLFID.ExpDisp;
    
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


