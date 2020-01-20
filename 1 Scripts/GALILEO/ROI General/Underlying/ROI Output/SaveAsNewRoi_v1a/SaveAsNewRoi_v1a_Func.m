%===========================================
% 
%===========================================

function [SAVE,err] = SaveAsNewRoi_v1a_Func(SAVE,INPUT)

Status2('busy','Save',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%--------------------------------------------- 
ROIARR = INPUT.ROI;
Suffix = INPUT.Suffix;
PathArr = INPUT.Path;
clear INPUT;

%---------------------------------------------
% Create ROI
%--------------------------------------------- 
for n = 1:length(ROIARR)
    ROI = ROIARR(n);
    if not(isempty(ROI.savepath))
        Path = ROI.savepath;
    else
        Path = GetRoiSearchPath;
    end
    if isempty(ROI.roiname)
        [file,path] = uiputfile('*.mat','Save ROI',[Path,'ROI_',Suffix]);
    else
        if ~strcmp(ROI.roiname(1:4),'ROI_')
            [file,path] = uiputfile('*.mat','Save ROI',[Path,'ROI_',ROI.roiname,Suffix]);
        else
            [file,path] = uiputfile('*.mat','Save ROI',[Path,ROI.roiname,Suffix]);
        end
    end
    roiname = file(1:end-4);
    ROI.SetROIName(roiname);
    ROI.SetROIPath(path);
    if path == 0
        err.flag = 4;
        err.msg = '';
        return
    end
    ROIARR(n) = ROI;
end
SetRoiSearchPath(path);

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'ROI Name',roiname,'Output'};
Panel(3,:) = {'ROI Path',path,'Output'};
SAVE.PanelOutput = cell2struct(Panel,{'label','value','type'},2);
SAVE.ExpDisp = PanelStruct2Text(SAVE.PanelOutput);

SAVE.SaveRois = 'Yes';
SAVE.LoadRois = 'Yes';
SAVE.ROIARR = ROIARR;

Status2('done','',2);
Status2('done','',3);

