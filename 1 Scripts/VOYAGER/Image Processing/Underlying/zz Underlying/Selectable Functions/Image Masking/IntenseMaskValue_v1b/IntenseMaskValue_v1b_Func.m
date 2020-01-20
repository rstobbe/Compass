%===========================================
% 
%===========================================

function [MASK,err] = IntenseMaskValue_v1b_Func(MASK,INPUT)

Status2('busy','Mask',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%--------------------------------------------- 
Im = INPUT.Im;
clear INPUT;

%---------------------------------------------
% Intensity Mask
%---------------------------------------------
Mask = abs(Im);
if strcmp(MASK.direction,'Positive')
    Mask(Mask < MASK.thresh) = NaN;
    Mask(Mask >= MASK.thresh) = 1;
elseif strcmp(MASK.direction,'Negative')
    Mask(Mask > MASK.thresh) = NaN;
    Mask(Mask <= MASK.thresh) = 1;
end


%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',MASK.method,'Output'};
Panel(3,:) = {'AbsThresh',MASK.thresh,'Output'};
Panel(4,:) = {'ThreshDirection',MASK.direction,'Output'};
MASK.PanelOutput = cell2struct(Panel,{'label','value','type'},2);

%---------------------------------------------
% Return
%---------------------------------------------
MASK.Mask = Mask;
MASK.Name = ['Mask',num2str(MASK.thresh)];

Status2('done','',2);
Status2('done','',3);

