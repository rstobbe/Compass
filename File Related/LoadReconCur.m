%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = LoadReconCur(SCRPTipt,SCRPTGBL)

global FIGOBJS

Status('busy','Select Recon File');
Status2('done','',2); 
Status2('done','',3); 

INPUT.Extension = {'YB*.mat;TPI*.mat'};
INPUT.CurFunc = 'LoadReconCur';
INPUT.DropExt = 'Yes';
INPUT.Type = 'Recon';
INPUT.AssignPath = 'Yes';
[SCRPTipt,SCRPTGBL,saveData0,err] = SelectGeneralFileCur_v5(SCRPTipt,SCRPTGBL,INPUT);
if err.flag
    return
end

if not(isempty(saveData0))
    
    %------------------------------------------
    % Load
    %------------------------------------------
    Status('busy','Load Recon File');
    saveData = [];
    load(saveData0.loc);
    if not(exist('saveData','var'))
        err.flag = 1;
        err.msg = 'Not an RWS Script Output File';
        return
    end
    if not(isfield(saveData,'WRT'))
        err.flag = 1;
        err.msg = 'Not an Trajectory Implementation File';
        return
    end
    saveData0.WRT = saveData.WRT;
    saveData = saveData0;
    
    %------------------------------------------
    % Show Info
    %------------------------------------------
    if strcmp(SCRPTGBL.RWSUI.tab(1:2),'IM')
        FIGOBJS.(SCRPTGBL.RWSUI.tab).InfoL.String = saveData.WRT.ExpDisp;
    else
        FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = saveData.WRT.ExpDisp;
    end
    
    %------------------------------------------
    % Update Name/Path
    %------------------------------------------
    saveData.WRT.name = saveData.file(1:end-4);
    saveData.WRT.path = saveData.path;

    %--------------------------------------------
    % Save
    %--------------------------------------------
    SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.display = saveData.WRT.ExpDisp;
    
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

