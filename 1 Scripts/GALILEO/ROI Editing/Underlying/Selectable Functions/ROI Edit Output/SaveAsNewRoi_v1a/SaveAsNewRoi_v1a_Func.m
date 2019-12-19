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
LOAD = INPUT.LOAD;
clear INPUT;

%---------------------------------------------
% Create ROI
%--------------------------------------------- 
for n = 1:length(ROIARR)
    ROI = ROIARR(n);
    if isfield(LOAD,'path')
        path = [LOAD.path,'\'];
    else
        path = LOAD.ROI(n).path;
    end
    [file,path] = uiputfile('*.mat','Save ROI',[path,'m',ROI.roiname]);
    roiname = file(1:end-4);
    ROI.SetROIName(roiname);
    if path == 0
        err.flag = 4;
        err.msg = '';
        return
    end
    save([path,file],'ROI');

    if isfield(LOAD,'tab')
        LoadROIExternal(LOAD.tab,LOAD.axnum,ROI);
    end

end

Status2('done','',2);
Status2('done','',3);

