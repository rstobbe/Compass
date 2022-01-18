%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = LoadSDCCur(SCRPTipt,SCRPTGBL)

global FIGOBJS

Status('busy','Select SDC File');
Status2('done','',2); 
Status2('done','',3); 

INPUT.Extension = 'SDC*.mat';
INPUT.CurFunc = 'LoadSDCCur';
INPUT.DropExt = 'Yes';
INPUT.Type = 'SDC';
INPUT.AssignPath = 'Yes';
[SCRPTipt,SCRPTGBL,saveData0,err] = SelectGeneralFileCur_v5(SCRPTipt,SCRPTGBL,INPUT);
if err.flag
    return
end

if not(isempty(saveData0))
    
    %------------------------------------------
    % Load
    %------------------------------------------
    Status('busy','Load SDC File');
    saveData = [];
    load(saveData0.loc);
    if not(exist('saveData','var'))
        err.flag = 1;
        err.msg = 'Not an RWS Script Output File';
        return
    end
    if not(isfield(saveData,'SDCS') || isfield(saveData,'SDC'))
        err.flag = 1;
        err.msg = 'Not a Sampling Density Compensation File';
        return
    end
    if isfield(saveData,'SDC')
        Struct = 'SDC';
    elseif isfield(saveData,'SDCS')
        Struct = 'SDCS';
    end
    saveData0.(Struct) = saveData.(Struct);
    saveData = saveData0;
    
    %------------------------------------------
    % Show Info
    %------------------------------------------
    FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = saveData.(Struct).ExpDisp;

    %------------------------------------------
    % Update Name/Path
    %------------------------------------------
    saveData.(Struct).name = saveData.file(1:end-4);
    saveData.(Struct).path = saveData.path;

    %--------------------------------------------
    % Save
    %--------------------------------------------
    SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.display = saveData.(Struct).ExpDisp;
    
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

