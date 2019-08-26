%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = LoadInvFiltCur(SCRPTipt,SCRPTGBL)

global FIGOBJS

Status('busy','Select Convolution Kernel File');
Status2('done','',2); 
Status2('done','',3); 

INPUT.Extension = 'IF*.mat';
INPUT.CurFunc = 'LoadInvFiltCur';
INPUT.DropExt = 'Yes';
INPUT.Type = 'InvFilt';
INPUT.AssignPath = 'No';
[SCRPTipt,SCRPTGBL,saveData0,err] = SelectGeneralFileCur_v5(SCRPTipt,SCRPTGBL,INPUT);
if err.flag
    return
end

if not(isempty(saveData0))
    
    %------------------------------------------
    % Load
    %------------------------------------------
    Status('busy','Load Inverse Filter File');
    saveData = [];
    load(saveData0.loc);
    if not(exist('saveData','var'))
        err.flag = 1;
        err.msg = 'Not an RWS Script Output File';
        return
    end
    if not(isfield(saveData,'IFprms'))
        err.flag = 1;
        err.msg = 'Not an Inverse Filter File';
        return
    end
    saveData0.IFprms = saveData.IFprms;
    saveData = saveData0;
    
    %------------------------------------------
    % Show Info
    %------------------------------------------
    if isfield(saveData.IFprms,'ExpDisp')
        FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = saveData.IFprms.ExpDisp;
    end

    %------------------------------------------
    % Update Name/Path
    %------------------------------------------
    saveData.IFprms.name = saveData.file(1:end-4);
    saveData.IFprms.path = saveData.path;

    %--------------------------------------------
    % Save
    %--------------------------------------------
    if isfield(saveData.IFprms,'ExpDisp')
        SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.display = saveData.IFprms.ExpDisp;
    else
        SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.display = '';
    end
    
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

