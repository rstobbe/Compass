%==============================================
% 
%==============================================

function [CALC,err] = AccCalc_FixedROISphereDiam_v1a_Func(CALC,INPUT)

Status2('busy','Analyze ROI array',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
zf = INPUT.zf;
fov = INPUT.fov;
voxdim = INPUT.voxdim;
Im = INPUT.Im;
diam = CALC.diam;
clear INPUT

%---------------------------------------------
% Build ROI
%--------------------------------------------- 
ROI.fov = fov;
ROI.zerofill = zf;
ROI.diam = diam;
[ROI,err] = SphereROI_ParForBuild_v1a(ROI);

%---------------------------------------------
% Plot
%---------------------------------------------  
%ROIprof = squeeze(ROI.roi(zf/2+1,zf/2+1,:));
%figure(10); hold on; 
%plot((voxdim:voxdim:fov),ROIprof,'c'); 

%---------------------------------------------
% Calculate PSFA
%---------------------------------------------  
psfa = Im(logical(ROI.roi));
psfa = mean(psfa);

%---------------------------------------------
% Return
%---------------------------------------------  
CALC.psfa = psfa




Status2('done','',2);
Status2('done','',3);
