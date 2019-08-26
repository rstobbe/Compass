%===========================================
% 
%===========================================

function [MIP,err] = MipProjection_v1a_Func(MIP,INPUT)

Status2('busy','Mip Projection',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%--------------------------------------------- 
IMG = INPUT.IMG{1};
clear INPUT;

%---------------------------------------------
% Build
%--------------------------------------------- 
Im = abs(IMG.Im);
Im = permute(Im,[3 2 1]);
Im = flip(Im,1);
Im = Im(:,:,110:200);
Im2 = max(Im,[],3);
IMG.Im = Im2;

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',MIP.method,'Output'};
MIP.PanelOutput = cell2struct(Panel,{'label','value','type'},2);

%---------------------------------------------
% Return
%---------------------------------------------
MIP.FigureName = 'Mip Image';
MIP.IMG = IMG;

Status2('done','',2);
Status2('done','',3);

