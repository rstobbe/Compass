%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = LoadConvKernDef(SCRPTipt,SCRPTGBL)

global FIGOBJS

Status('busy','Select Convolution Kernel File');
Status2('done','',2); 
Status2('done','',3); 

INPUT.Search = 'Kern*.mat';
INPUT.Assign = 'KRNprms';
INPUT.CurFunc = 'LoadConvKernCur';
INPUT.DropExt = 'Yes';
INPUT.Type = 'ConvKern';
INPUT.AssignPath = 'No';
[SCRPTipt,SCRPTGBL,saveData0,err] = SelectGeneralFileDef_v5(SCRPTipt,SCRPTGBL,INPUT);

if not(isempty(saveData0))
    
    %------------------------------------------
    % Load
    %------------------------------------------
    Status('busy','Load Convolution Kernel File');
    saveData = [];
    load(saveData0.loc);
    if not(exist('saveData','var'))
        err.flag = 1;
        err.msg = 'Not an RWS Script Output File';
        return
    end
    if not(isfield(saveData,'KRNprms'))
        err.flag = 1;
        err.msg = 'Not an Convolution Kernel File';
        return
    end
    saveData0.KRNprms = saveData.KRNprms;
    saveData = saveData0;
    
    %------------------------------------------
    % Show Info
    %------------------------------------------
    FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = saveData.KRNprms.ExpDisp;

    %------------------------------------------
    % Update Name/Path
    %------------------------------------------
    saveData.KRNprms.name = saveData.file(1:end-4);
    saveData.KRNprms.path = saveData.path;

    %--------------------------------------------
    % Save
    %--------------------------------------------
    SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.display = saveData.KRNprms.ExpDisp;
    
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


