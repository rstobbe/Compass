%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = LoadMfevoCur(SCRPTipt,SCRPTGBL)

global FIGOBJS

Status('busy','Select MFEVO File');
Status2('done','',2); 
Status2('done','',3); 

INPUT.Extension = {'MFEVO*.mat'};
INPUT.CurFunc = 'LoadMfevoCur';
INPUT.DropExt = 'Yes';
INPUT.Type = 'Mfevo';
INPUT.AssignPath = 'Yes';
[SCRPTipt,SCRPTGBL,saveData0,err] = SelectGeneralFileCur_v5(SCRPTipt,SCRPTGBL,INPUT);
if err.flag
    return
end

if not(isempty(saveData0))
    
    %------------------------------------------
    % Load
    %------------------------------------------
    Status('busy','Load MFEVO File');
    load(saveData0.loc);
    if not(exist('saveData','var'))
        err.flag = 1;
        err.msg = 'Not an RWS Script Output File';
        return
    end
    if not(isfield(saveData,'MFEVO'))
        err.flag = 1;
        err.msg = 'Not an Trajectory Design File';
        return
    end
    saveData0.MFEVO = saveData.MFEVO;
    saveData = saveData0;
    
    %------------------------------------------
    % Show Info
    %------------------------------------------
    FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = saveData.MFEVO.ExpDisp;

    %------------------------------------------
    % Update Name/Path
    %------------------------------------------
    saveData.MFEVO.name = saveData.file(1:end-4);
    saveData.MFEVO.path = saveData.path;

    %--------------------------------------------
    % Save
    %--------------------------------------------
    SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.display = saveData.MFEVO.ExpDisp;
    
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

