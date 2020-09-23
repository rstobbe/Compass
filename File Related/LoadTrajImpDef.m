%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = LoadTrajImpDef(SCRPTipt,SCRPTGBL)

global FIGOBJS

Status('busy','Select IMP File');
Status2('done','',2); 
Status2('done','',3); 

INPUT.Search = {'IMP*.mat;YB*.mat;TPI*.mat'};
INPUT.Assign = 'IMP';
INPUT.CurFunc = 'LoadTrajImpCur';
INPUT.DropExt = 'Yes';
INPUT.Type = 'TrajImp';
INPUT.AssignPath = 'Yes';
[SCRPTipt,SCRPTGBL,saveData0,err] = SelectGeneralFileDef_v5(SCRPTipt,SCRPTGBL,INPUT);
if err.flag
    return
end

if isfield(saveData0,'IMP')
    %------------------------------------------
    % Show Info
    %------------------------------------------
    FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = saveData0.IMP.ExpDisp;
    SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.display = saveData0.IMP.ExpDisp;
end

if not(isempty(saveData0)) && not(isfield(saveData0,'IMP'))
    
    %------------------------------------------
    % Load
    %------------------------------------------
    Status('busy','Load IMP File');
    saveData = [];
    load(saveData0.loc);
    if not(exist('saveData','var'))
        err.flag = 1;
        err.msg = 'Not an RWS Script Output File';
        return
    end
    if not(isfield(saveData,'IMP'))
        err.flag = 1;
        err.msg = 'Not an Trajectory Implementation File';
        return
    end
    saveData0.IMP = saveData.IMP;
    saveData = saveData0;
    
    %------------------------------------------
    % Show Info
    %------------------------------------------
    FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = saveData.IMP.ExpDisp;

    %------------------------------------------
    % Update Name/Path
    %------------------------------------------
    saveData.IMP.name = saveData.file(1:end-4);
    saveData.IMP.path = saveData.path;

    %--------------------------------------------
    % Save
    %--------------------------------------------
    SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.display = saveData.IMP.ExpDisp;
    
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


