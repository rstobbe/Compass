%===========================================
% 
%===========================================

function [B1MAP,err] = B1Mapping_v1b_Func(B1MAP,INPUT)

Status('busy','Map B1');
Status2('busy','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Test
%---------------------------------------------
IMG = INPUT.IMG;
MAP = INPUT.MAP;
DISP = INPUT.DISP;
clear INPUT;

%---------------------------------------------
% Sort Out Input
%---------------------------------------------
type = 1;
if iscell(IMG)
    type = 2;
end
if type == 1
    if isfield(IMG,'ImageType');
        if not(strcmp(IMG.ImageType,'Image'))
            err.flag = 1;
            err.msg = 'Input File Not Image';
            return
        end
    end
    if isfield(IMG.ExpPars,'Array')
        Array = IMG.ExpPars.Array;
        if Array.ArrLen ~= 2
            err.flag = 1;
            err.msg = 'Image Array Not Supported';
            return
        end
        if not(strcmp(Array.ArrayName,'B1Map'))
            if isempty(Array.ArrayName)
                button = questdlg('Image Array Undefined, Continue?'); 
            else
                button = questdlg(['Image Array: "',Array.ArrayName,'", Continue?']);
            end
            if not(strcmp(button,'Yes'))
                return
            end
        end
        if not(isfield(Array.ArrayParams,'fa'));
            err.flag = 1;
            err.msg = 'Image Array Not Supported';
            return
        end
        Im = IMG.Im;
        flipangle = Array.ArrayParams.fa;
        PanelOutput = IMG.PanelOutput;
        ReconPars = IMG.ReconPars;
        ExpPars = IMG.ExpPars;
        ExpDisp = IMG.ExpDisp;
        FID = IMG.FID;
    end
elseif type ==2
    if iscell(IMG)
        if length(IMG) ~= 2
            err.flag = 1;
            err.msg = 'Input Must Have 2 Images';
            return
        end
        IMG1 = IMG{1};
        IMG2 = IMG{2};
        ReconPars1 = IMG1.ReconPars;
        ExpPars1 = IMG1.ExpPars;
        Im1 = IMG1.Im;
        ReconPars2 = IMG2.ReconPars;
        ExpPars2 = IMG2.ExpPars;
        Im2 = IMG2.Im;  

        %----------------------------------------
        % Compare
        [~,~,comperr] = comp_struct(ReconPars1,ReconPars2,'ReconPars1','ReconPars2');
        if not(isempty(comperr))
            err.flag = 1;
            err.msg = 'Image recons do not match';
            return
        end
        ReconPars = ReconPars1;
        tExpPars1 = rmfield(ExpPars1,'Sequence');
        tExpPars2 = rmfield(ExpPars2,'Sequence');    
        [~,~,comperr] = comp_struct(tExpPars1,tExpPars2,'tExpPars1','tExpPars2');
        if not(isempty(comperr))
            err.flag = 1;
            err.msg = 'Images do not have the same experiment paramteres';
            return
        end
        flipangle = [ExpPars1.Sequence.flip_angle ExpPars2.Sequence.flip_angle];

        %----------------------------------------
        % Image Array   
        sz = size(Im1);
        if length(sz) == 3
            Im = zeros([sz 2]);
            Im(:,:,:,1) = Im1;
            Im(:,:,:,2) = Im2;  
        end
        if length(sz) == 4    
            Im = zeros([sz(1) sz(2) sz(3) 2 sz(4)]);
            Im(:,:,:,1,:) = Im1;
            Im(:,:,:,2,:) = Im2;
        end
        PanelOutput = IMG1.PanelOutput;
    else
        error();    % not supported
    end
end 

%---------------------------------------------
% Create Base Image for Display
%---------------------------------------------
BaseIm = abs(mean(Im,4));

%---------------------------------------------
% B1 Map
%---------------------------------------------
func = str2func([B1MAP.mapfunc,'_Func']);  
INPUT.Image = Im;
INPUT.ReconPars = ReconPars;
INPUT.flipangle = flipangle;
[MAP,err] = func(MAP,INPUT);
if err.flag
    return
end
clear INPUT;
B1Map = MAP.Im;

%---------------------------------------------
% Display
%---------------------------------------------
Im(:,:,:,1) = BaseIm;
Im(:,:,:,2) = B1Map;
func = str2func([B1MAP.dispfunc,'_Func']);  
INPUT.Im = Im;
[DISP,err] = func(DISP,INPUT);
if err.flag
    return
end
clear INPUT;

%---------------------------------------------
% Return
%---------------------------------------------
B1MAP.Im = Im;
B1MAP.ImageType = 'B1Map';
B1MAP.FID = FID;
B1MAP.ReconPars = ReconPars;
B1MAP.ExpPars = ExpPars;
B1MAP.ExpDisp = ExpDisp;
B1MAP.PanelOutput = PanelOutput;

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);

