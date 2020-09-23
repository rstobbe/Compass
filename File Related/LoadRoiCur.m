%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = LoadRoiCur(SCRPTipt,SCRPTGBL)

INPUT.Extension = 'ROI*.mat*';
INPUT.CurFunc = 'LoadRoiCur';
INPUT.Type = 'Roi';
INPUT.AssignPath = 'Yes';
[SCRPTipt,SCRPTGBL,saveData0,err] = SelectGeneralFileCur_v5(SCRPTipt,SCRPTGBL,INPUT);

if not(isempty(saveData0))
    
    %------------------------------------------
    % Load
    %------------------------------------------
    Status('busy','Load ROI File');
    load(saveData0.loc);
    whos
    if not(exist('ROI','var'))
        err.flag = 1;
        err.msg = 'File does not contain an ROI';
        return
    end
    saveData.ROI = ROI;
    
    %------------------------------------------
    % Update Name/Path
    %------------------------------------------
    saveData.file = saveData0.file;
    saveData.path = saveData0.path;
    saveData.loc = saveData0.loc;
    saveData.label = saveData0.label;
    saveData.ROI.SetROIName(saveData.file(1:end-4));
    saveData.ROI.SetROIPath(saveData.path);

    %--------------------------------------------
    % Save
    %--------------------------------------------    
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
