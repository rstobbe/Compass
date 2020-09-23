%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = LoadInvFiltDef(SCRPTipt,SCRPTGBL)

global FIGOBJS

Status('busy','Select Convolution Kernel File');
Status2('done','',2); 
Status2('done','',3); 

INPUT.Search = 'IF*.mat';
INPUT.Assign = 'IFprms';
INPUT.CurFunc = 'LoadInvFiltCur';
INPUT.DropExt = 'Yes';
INPUT.Type = 'InvFilt';
[SCRPTipt,SCRPTGBL,saveData0,err] = SelectGeneralFileDef_v5(SCRPTipt,SCRPTGBL,INPUT);

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
    FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = saveData.IFprms.ExpDisp;

    %------------------------------------------
    % Update Name/Path
    %------------------------------------------
    saveData.IFprms.name = saveData.file(1:end-4);
    saveData.IFprms.path = saveData.path;

    %--------------------------------------------
    % Save
    %--------------------------------------------
    SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.display = saveData.IFprms.ExpDisp;
    
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


