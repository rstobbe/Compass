%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = LoadKSampDef(SCRPTipt,SCRPTGBL)

global FIGOBJS

Status('busy','Select Simulated Sampling File');
Status2('done','',2); 
Status2('done','',3); 

INPUT.Search = 'KSMP*.mat';
INPUT.Assign = 'SAMP';
INPUT.CurFunc = 'LoadKSampCur';
INPUT.DropExt = 'Yes';
INPUT.Type = 'SAMP';
INPUT.AssignPath = 'Yes';
[SCRPTipt,SCRPTGBL,saveData0,err] = SelectGeneralFileDef_v5(SCRPTipt,SCRPTGBL,INPUT);
if err.flag
    return
end

if isfield(saveData0,'SAMP')
    %------------------------------------------
    % Show Info
    %------------------------------------------
    FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = saveData0.SAMP.ExpDisp;
    SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.display = saveData0.SAMP.ExpDisp;
end

if not(isempty(saveData0)) && not(isfield(saveData0,'SAMP'))
    
    %------------------------------------------
    % Load
    %------------------------------------------
    Status('busy','Load Simulated Sampling File');
    saveData = [];
    load(saveData0.loc);
    if not(exist('saveData','var'))
        err.flag = 1;
        err.msg = 'Not an RWS Script Output File';
        return
    end
    if not(isfield(saveData,'SAMP'))
        err.flag = 1;
        err.msg = 'Not an Simulated Sampling File';
        return
    end
    saveData0.SAMP = saveData.SAMP;
    saveData = saveData0;
    
    %------------------------------------------
    % Show Info
    %------------------------------------------
    FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = saveData.SAMP.ExpDisp;

    %------------------------------------------
    % Update Name/Path
    %------------------------------------------
    saveData.SAMP.name = saveData.file(1:end-4);
    saveData.SAMP.path = saveData.path;

    %--------------------------------------------
    % Save
    %--------------------------------------------
    SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.display = saveData.SAMP.ExpDisp;
    
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


