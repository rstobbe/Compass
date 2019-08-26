%=========================================================
% 
%=========================================================

function [AEXT,err] = ImageArrayExtract_v1b_Func(AEXT,INPUT)

Status2('busy','Images Array Extract',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMG = INPUT.IMG;
clear INPUT;

%---------------------------------------------
% Test
%---------------------------------------------
if length(IMG) > 1
    err.flag = 1;
    err.msg = 'Procfunc runs on single image';
    return
end
IMG = IMG{1};

%---------------------------------------------
% Extract Dimensions
%---------------------------------------------
sz = size(IMG.Im);
if length(sz) == 4
    sz(5) = 1;
end
if length(sz) == 5
    sz(6) = 1;
end
if strcmp(AEXT.dim4,':')
    sz4 = 1:sz(4);
else
    ind = strfind(AEXT.dim4,':');
    if isempty(ind)
        sz4 = str2double(AEXT.dim4);
    end
end
if strcmp(AEXT.dim5,':')
    sz5 = 1:sz(5);
else
    ind = strfind(AEXT.dim5,':');
    if isempty(ind)
        sz5 = str2double(AEXT.dim5);
    end
end 
if strcmp(AEXT.dim6,':')
    sz6 = 1:sz(6);
else
    ind = strfind(AEXT.dim6,':');
    if isempty(ind)
        sz6 = str2double(AEXT.dim6);
    end
end 

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',AEXT.method,'Output'};
Panel(3,:) = {'Dim4',AEXT.dim4,'Output'};
Panel(4,:) = {'Dim5',AEXT.dim5,'Output'};
Panel(5,:) = {'Dim6',AEXT.dim6,'Output'};
AEXT.PanelOutput = cell2struct(Panel,{'label','value','type'},2);

PanelOutput = IMG.PanelOutput;
IMG.PanelOutput = [PanelOutput;AEXT.PanelOutput];
IMG.ExpDisp = PanelStruct2Text(PanelOutput);

%---------------------------------------------
% Name
%---------------------------------------------
ind = strfind(IMG.name,'.');
if not(isempty(ind))
    name = IMG.name(1:ind-1);
end 
IMG.name = [name,'_AEXT'];

%---------------------------------------------
% Return
%---------------------------------------------
IMG.Im = IMG.Im(:,:,:,sz4,sz5,sz6);
AEXT.IMG = IMG;
AEXT.FigureName = 'Array Extract';

Status2('done','',2);
Status2('done','',3);
