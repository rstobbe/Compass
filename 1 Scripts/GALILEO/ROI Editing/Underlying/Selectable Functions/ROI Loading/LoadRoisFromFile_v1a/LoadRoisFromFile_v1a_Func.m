%===========================================
% 
%===========================================

function [LOAD,err] = LoadRoisFromFile_v1a_Func(LOAD,INPUT)

Status2('busy','Load',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%--------------------------------------------- 
RoiInfo = LOAD.RoiInfo;
clear INPUT;

%---------------------------------------------
% Return ROI
%---------------------------------------------
for n = 1:length(RoiInfo)
    load(RoiInfo(n).loc,'ROI');
    LOAD.ROI(n) = ROI;
end

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Status2('done','',2);
Status2('done','',3);

