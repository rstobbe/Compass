%==============================================
% 
%==============================================

function [CALC,err] = AccCalc_ArrROISphereDiam_v1a_Func(CALC,INPUT)

Status2('busy','Analyze ROI array',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
zf = INPUT.zf;
fov = INPUT.fov;
Im = INPUT.Im;
ROI = CALC.ROI;
clear INPUT

%---------------------------------------------
% Diam
%---------------------------------------------
ind = strfind(CALC.diam,':');
start = str2double(CALC.diam(1:ind(1)-1));
step = str2double(CALC.diam(ind(1)+1:ind(2)-1));
stop = str2double(CALC.diam(ind(2)+1:end));

%---------------------------------------------
% Test ROIs
%---------------------------------------------   
func = str2func([CALC.roifunc,'_Func']);
INPUT.zf = zf;
INPUT.fov = fov;

m = 1;
for n = start:step:stop
    Status2('busy','Build ROI',2);
    INPUT.diam = n;
    [ROI,err] = func(ROI,INPUT);
    if err.flag
        return
    end
    
    ROIprof = squeeze(ROI.roi(zf/2+1,zf/2+1,:));
    figure(10); hold on; 
    plot(ROIprof,'k:'); 
    
    Status2('busy','Calculate Mean Acc',2);
    ImMask = Im.*ROI.roi;
    ImMask = ImMask(ImMask~=0);
    AccArr(m) = mean(ImMask);
    m = m+1;
end

%---------------------------------------------
% Return
%---------------------------------------------  
CALC.DiamArr = (start:step:stop);
CALC.AccArr = AccArr;

Status2('done','',2);
Status2('done','',3);
