%===========================================
% 
%===========================================

function [B0MAP,err] = B0Mapping_v1c_Func(B0MAP,INPUT)

Status('busy','Map B0');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Input
%---------------------------------------------
IMG = INPUT.IMG;
MAP = INPUT.MAP;
DISP = INPUT.DISP;
BASE = INPUT.BASE;
clear INPUT;

%---------------------------------------------
% Sort Out Input
%---------------------------------------------
if iscell(IMG)
    if length(IMG) == 1
        IMG = IMG{1};
    end
end
if iscell(IMG)
    if length(IMG) ~= 2
        err.flag = 1;
        err.msg = 'Load 2 Images';
        return
    end
    IMG1 = IMG{1};
    IMG2 = IMG{2};
    ReconPars1 = IMG1.ReconPars;
    if isfield(IMG1.FID,'Shim')
        Shims1 = IMG1.FID.Shim;
    else 
        Shims1 = 0;
    end
    ExpPars1 = IMG1.ExpPars;
    Im1 = IMG1.Im;
    ReconPars2 = IMG2.ReconPars;
    if isfield(IMG2.FID,'Shim')
        Shims2 = IMG2.FID.Shim;
    else
        Shims2 = 0;
    end
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
    if Shims1 ~= 0 && Shims2 ~= 0
        [~,~,comperr] = comp_struct(Shims1,Shims2,'Shims1','Shims2');
        if not(isempty(comperr))
            err.flag = 1;
            err.msg = 'Image do not have the same shimming';
            return
        end
         %Shims = Shims1;
    end
    tExpPars1 = rmfield(ExpPars1,'Sequence');
    tExpPars2 = rmfield(ExpPars2,'Sequence');    
    [~,~,comperr] = comp_struct(tExpPars1,tExpPars2,'tExpPars1','tExpPars2');
    if not(isempty(comperr))
        err.flag = 1;
        err.msg = 'Images do not have the same experiment paramteres';
        return
    end
    ExpPars = ExpPars1;
    ExpPars.te1 = ExpPars1.Sequence.te;
    ExpPars.te2 = ExpPars2.Sequence.te;
    PanelOutput = IMG1.PanelOutput;
    TEdif = (ExpPars.te2-ExpPars.te1);
    TEorig = (ExpPars.te1);   
    
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
else
    if isfield(IMG.ExpPars,'Array')             % Varian...
        Array = IMG.ExpPars.Array;
        if isfield(Array,'ArrayName')
            if strcmp(Array.ArrayName,'Shim') || strcmp(Array.ArrayName,'B0Map')            
                ArrayParams = IMG.ExpPars.Array.ArrayParams;              
                Im = IMG.Im;
                TEdif = ArrayParams.(ArrayParams.VarNames{1})(2) - ArrayParams.(ArrayParams.VarNames{1})(1);
                TEorig = ArrayParams.(ArrayParams.VarNames{1})(1);
                if strcmp(ArrayParams.VarNames{1},'padel')
                    TEdif = TEdif/1000;
                    TEorig = TEorig/1000;
                end
                ReconPars = IMG.ReconPars;
                ExpPars = IMG.ExpPars;
                PanelOutput = IMG.PanelOutput;
            end
        end
    elseif isfield(IMG.ExpPars.Sequence,'te1') 
        Im = IMG.Im;
        ReconPars = IMG.ReconPars;
        ExpPars = IMG.ExpPars;
        PanelOutput = IMG.PanelOutput;
        ExpPars.te1 = ExpPars.Sequence.te1;
        ExpPars.te2 = ExpPars.Sequence.te2;
        TEdif = (ExpPars.te2-ExpPars.te1);
        TEorig = (ExpPars.te1);   
    end
end

%---------------------------------------------
% Create Base Image for Display
%---------------------------------------------
func = str2func([B0MAP.baseimfunc,'_Func']);  
INPUT.Im = Im;
INPUT.ExpPars = ExpPars;
[BASE,err] = func(BASE,INPUT);
if err.flag
    return
end
clear INPUT;
BaseIm = BASE.Im;

%---------------------------------------------
% Separate
%---------------------------------------------
Im1 = squeeze(Im(:,:,:,1,:));
Im2 = squeeze(Im(:,:,:,2,:));

%---------------------------------------------
% Create B0 Map
%---------------------------------------------
func = str2func([B0MAP.mapfunc,'_Func']);  
INPUT.Im1 = Im1;
INPUT.Im2 = Im2;
INPUT.TEdif = TEdif;
INPUT.TEorig = TEorig;
INPUT.ReconPars = ReconPars;
[MAP,err] = func(MAP,INPUT);
if err.flag
    return
end
clear INPUT;
B0Map = -MAP.fMap;              % account negative rotation (update in B0 Map)
if strcmp(B0MAP.shimcalpol,'AbsFreq')
    fMap = MAP.fMap;
elseif strcmp(B0MAP.shimcalpol,'B0')
    fMap = -MAP.fMap;
end

%---------------------------------------------
% Display
%---------------------------------------------
Im(:,:,:,1) = BaseIm;
Im(:,:,:,2) = B0Map;
Im(:,:,:,3) = zeros(size(B0Map));  
Im(:,:,:,4) = zeros(size(B0Map));  
func = str2func([B0MAP.dispfunc,'_Func']);  
INPUT.Im = Im;
INPUT.Name = 'B0Map';
INPUT.ImInfo = IMG.IMDISP.ImInfo;
[DISP,err] = func(DISP,INPUT);
if err.flag
    return
end
clear INPUT;

%---------------------------------------------
% Convert NaN to zero 
%---------------------------------------------
fMap(isnan(fMap)) = 0;

%---------------------------------------------
% Return
%---------------------------------------------
B0MAP.Im = fMap;
B0MAP.ReconPars = ReconPars;
B0MAP.TEdif = TEdif;
B0MAP.TEorig = TEorig;
B0MAP.PanelOutput = PanelOutput;
B0MAP.ImageType = 'B0Map';

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);

