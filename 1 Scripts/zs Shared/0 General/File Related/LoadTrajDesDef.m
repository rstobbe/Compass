%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = LoadTrajDesDef(SCRPTipt,SCRPTGBL)

global FIGOBJS

Status('busy','Load DES File');
Status2('done','',2); 
Status2('done','',3); 

INPUT.Search = 'DES*.mat';
INPUT.Assign = 'DES';
INPUT.CurFunc = 'LoadTrajDesCur';
INPUT.DropExt = 'Yes';
INPUT.Type = 'TrajDes';
INPUT.AssignPath = 'Yes';
[SCRPTipt,SCRPTGBL,saveData0,err] = SelectGeneralFileDef_v5(SCRPTipt,SCRPTGBL,INPUT);
if err.flag
    return
end

if isfield(saveData0,'DES')
    %------------------------------------------
    % Show Info
    %------------------------------------------
    FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = saveData0.DES.ExpDisp;
    SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.display = saveData0.DES.ExpDisp;
end

if not(isempty(saveData0)) && not(isfield(saveData0,'DES'))
    
    %------------------------------------------
    % Load
    %------------------------------------------
    Status('busy','Load DES File');
    saveData = [];
    load(saveData0.loc);
    if not(exist('saveData','var'))
        err.flag = 1;
        err.msg = 'Not an RWS Script Output File';
        return
    end
    if not(isfield(saveData,'DES'))
        err.flag = 1;
        err.msg = 'Not an Trajectory Design File';
        return
    end
    saveData0.DES = saveData.DES;
    saveData = saveData0;
    
    %------------------------------------------
    % Show Info
    %------------------------------------------
    FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = saveData.DES.ExpDisp;

    %------------------------------------------
    % Update Name/Path
    %------------------------------------------
    saveData.DES.name = saveData.file(1:end-4);
    saveData.DES.path = saveData.path;

    %--------------------------------------------
    % Save
    %--------------------------------------------
    SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.display = saveData.DES.ExpDisp;
    
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


