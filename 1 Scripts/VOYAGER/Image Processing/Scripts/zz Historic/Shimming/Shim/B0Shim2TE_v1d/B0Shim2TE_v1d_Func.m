%===========================================
% 
%===========================================

function [SHIM,err] = B0Shim2TE_v1d_Func(SHIM,INPUT)

Status('busy','B0 Shimming');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Input
%---------------------------------------------
IMG = INPUT.IMG;
RESZ = INPUT.RESZ;
BASE = INPUT.BASE;
CAL = INPUT.CAL;
MAP = INPUT.MAP;
MASK = INPUT.MASK;
FIT = INPUT.FIT;
DISP = INPUT.DISP;
SCRPTipt = INPUT.SCRPTipt;
SCRPTGBL = INPUT.SCRPTGBL;
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
    if length(IMG)~= 2
        err.flag = 1;
        err.msg = 'Load 2 Images';
        return
    end
    IMG1 = IMG{1};
    IMG2 = IMG{2};
    ReconPars1 = IMG1.ReconPars;
    Shims1 = IMG1.FID.Shim;
    ExpPars1 = IMG1.ExpPars;
    Im1 = IMG1.Im;
    ReconPars2 = IMG2.ReconPars;
    Shims2 = IMG2.FID.Shim;
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
    [~,~,comperr] = comp_struct(Shims1,Shims2,'Shims1','Shims2');
    if not(isempty(comperr))
        err.flag = 1;
        err.msg = 'Image do not have the same shimming';
        return
    end
    Shims = Shims1;
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
    if isfield(IMG.ExpPars,'Array')
        test = IMG.ExpPars.Array;
        if isfield(IMG.ExpPars.Array,'ArrayName')
            if strcmp(IMG.ExpPars.Array.ArrayName,'Shim')            
                Im = IMG.Im;
                TEdif = (IMG.ExpPars.Array.te(2) - IMG.ExpPars.Array.te(1));
                TEorig = IMG.ExpPars.Array.te(1);
                ReconPars = IMG.ReconPars;
                ExpPars = IMG.ExpPars;
                Shims = IMG.FID.Shim;
                PanelOutput = IMG.PanelOutput;
            end
            if strcmp(IMG.ExpPars.Array.ArrayName,'B0Map')            
                Im = IMG.Im;
                TEdif = (IMG.ExpPars.Array.ArrayParams.padel(2) - IMG.ExpPars.Array.ArrayParams.padel(1))/1000;
                TEorig = IMG.ExpPars.Array.ArrayParams.padel(1)/1000;
                ReconPars = IMG.ReconPars;
                ExpPars = IMG.ExpPars;
                Shims = IMG.FID.Shim;
                PanelOutput = IMG.PanelOutput;
            end
        elseif isfield(IMG.ExpPars.Array,'padel')           % delete in future
            Im = IMG.Im;
            TEdif = (IMG.ExpPars.Array.padel(2) - IMG.ExpPars.Array.padel(1))/1000;
            TEorig = IMG.ExpPars.Array.padel(1)/1000;
            ReconPars = IMG.ReconPars;
            ExpPars = IMG.ExpPars;
            Shims = IMG.FID.Shim;
            PanelOutput = IMG.PanelOutput;            
        elseif isfield(IMG.ExpPars.Array,'te')
            Im = IMG.Im;
            TEdif = (IMG.ExpPars.Array.te(2) - IMG.ExpPars.Array.te(1));
            TEorig = IMG.ExpPars.Array.te(1);
            ReconPars = IMG.ReconPars;
            ExpPars = IMG.ExpPars;
            Shims = IMG.FID.Shim;
            PanelOutput = IMG.PanelOutput;
        end
    else
        error();  % not supported
    end
end

%---------------------------------------------
% Resize Images If Needed
%---------------------------------------------
func = str2func([SHIM.resizefunc,'_Func']);  
INPUT.ReconPars0 = ReconPars;
INPUT.ReconPars1 = CAL.ReconPars(1);
INPUT.Im = Im;
[RESZ,err] = func(RESZ,INPUT);
if err.flag
    return
end
clear INPUT;
Im = RESZ.Im;

%---------------------------------------------
% Create Base Image for Display
%---------------------------------------------
func = str2func([SHIM.baseimfunc,'_Func']);  
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
func = str2func([SHIM.mapfunc,'_Func']);  
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
if strcmp(SHIM.shimcalpol,'AbsFreq')
    fMap = MAP.fMap;
elseif strcmp(SHIM.shimcalpol,'B0')
    fMap = -MAP.fMap;
end
    
%---------------------------------------------
% Mask
%---------------------------------------------
func = str2func([SHIM.maskfunc,'_Func']);  
INPUT.Im = BaseIm;
INPUT.AbsIm = BaseIm;
INPUT.fMap = B0Map;
INPUT.ReconPars = ReconPars;
INPUT.figno = 100;
INPUT.SCRPTipt = SCRPTipt;
INPUT.SCRPTGBL = SCRPTGBL;
INPUT.IMDISP = IMG.IMDISP;
[MASK,err] = func(MASK,INPUT);
if err.flag
    return
end
if isfield(MASK,'SCRPTipt')
    SCRPTipt = MASK.SCRPTipt;
end
Mask = MASK.Mask;
clear INPUT;

%---------------------------------------------
% Display
%---------------------------------------------
Im(:,:,:,1) = BaseIm;
Im(:,:,:,2) = B0Map;
if isempty(Mask)
    Im(:,:,:,3) = zeros(size(B0Map));  
else
    Im(:,:,:,3) = Mask;
end
Im(:,:,:,4) = zeros(size(B0Map));  
func = str2func([SHIM.dispfunc,'_Func']);  
INPUT.Im = Im;
INPUT.Name = 'Test';
INPUT.ImInfo = IMG.IMDISP.ImInfo;
[DISP,err] = func(DISP,INPUT);
if err.flag
    return
end
clear INPUT;

%---------------------------------------------
% Get Previous Shims
%---------------------------------------------
for n = 1:length(CAL.CalData)
    PrevShims(n) = Shims.(CAL.CalData(n).Shim);
    ShimsUsed{n} = CAL.CalData(n).Shim;
end

%---------------------------------------------
% Shim
%---------------------------------------------
func = str2func([SHIM.fitfunc,'_Func']);  
if isempty(Mask)
    INPUT.Im = fMap;                            % historically did not include negative rotation in shimming calibration
else
    INPUT.Im = fMap.*Mask;
end
INPUT.CalData = CAL.CalData;
INPUT.PrevShims = PrevShims;
INPUT.ShimsUsed = ShimsUsed;
[FIT,err] = func(FIT,INPUT);
if err.flag
    return
end
clear INPUT;
Vfit = -round(FIT.V);
if strcmp(SHIM.shimcalpol,'AbsFreq')
    Prof = -FIT.Prof;                               % convert to negative rotation
elseif strcmp(SHIM.shimcalpol,'B0')
    Prof = FIT.Prof;
end

%---------------------------------------------
% Display
%---------------------------------------------
Im(:,:,:,1) = BaseIm;
Im(:,:,:,2) = B0Map;
if isempty(Mask)
    Im(:,:,:,3) = zeros(size(B0Map));  
else
    Im(:,:,:,3) = Mask;
end
Im(:,:,:,4) = Prof;
func = str2func([SHIM.dispfunc,'_Func']);  
INPUT.Im = Im;
INPUT.Name = 'Test';
INPUT.ImInfo = IMG.IMDISP.ImInfo;
[DISP,err] = func(DISP,INPUT);
if err.flag
    return
end
clear INPUT;

%---------------------------------------------
% Add to Previous Shims
%---------------------------------------------
for n = 1:length(Vfit)
    V(n) = Shims.(CAL.CalData(n).Shim) + Vfit(n);
end
    
%--------------------------------------------
% Panel
%--------------------------------------------
for n = 1:length(V)
    Panel(n,:) = {['Update_',CAL.CalData(n).Shim],Vfit(n),'Output'};
end
n = n+1;
Panel(n,:) = {'','','Output'};
N = n;
for n = 1:length(V)
    Panel(n+N,:) = {['New_',CAL.CalData(n).Shim],V(n),'Output'};
end
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
SHIM.PanelOutput = PanelOutput;

%---------------------------------------------
% Write System Structure
%---------------------------------------------
NewShims = Shims;
for n = 1:length(CAL.CalData)
    NewShims.(CAL.CalData(n).Shim) = V(n);
end

%---------------------------------------------
% Return
%---------------------------------------------
SHIM.CalData = CAL.CalData;
SHIM.Vfit = Vfit;
SHIM.V = V;
SHIM.ShimsUsed = ShimsUsed;
SHIM.Im = Im;
SHIM.PrevShims = Shims;
SHIM.NewShims = NewShims;
SHIM.SCRPTipt = SCRPTipt;
SHIM.ImageType = 'Shim';

Status2('done','',2);
Status2('done','',3);

