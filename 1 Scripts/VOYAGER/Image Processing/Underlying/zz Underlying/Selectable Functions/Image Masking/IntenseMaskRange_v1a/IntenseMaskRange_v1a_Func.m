%===========================================
% 
%===========================================

function [MASK,err] = IntenseMaskRange_v1a_Func(MASK,INPUT)

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
Mask = NaN*ones(size(Im));
Mask(abs(Im) > MASK.threshbot & abs(Im) < MASK.threshtop) = 1;

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',MASK.method,'Output'};
Panel(3,:) = {'ThreshBot',MASK.threshbot,'Output'};
Panel(4,:) = {'ThreshTop',MASK.threshtop,'Output'};
MASK.PanelOutput = cell2struct(Panel,{'label','value','type'},2);

%---------------------------------------------
% Return
%---------------------------------------------
MASK.Mask = Mask;
MASK.Name = ['Mask',num2str(MASK.threshbot),num2str(MASK.threshtop)];

Status2('done','',2);
Status2('done','',3);

