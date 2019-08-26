%===========================================
% 
%===========================================

function [B0MAP,err] = B0Mapping_v1d_Func(B0MAP,INPUT)

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
if not(strcmp(IMG.type,'Image'))
    err.flag = 1;
    err.msg = ['Input is type  ''',(IMG.type),''''];
    return
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
% Create B0 Map
%---------------------------------------------
func = str2func([B0MAP.mapfunc,'_Func']);  
INPUT.Im1 = squeeze(Im(:,:,:,1,:));
INPUT.Im2 = squeeze(Im(:,:,:,2,:));
INPUT.TEdif = TEdif;
INPUT.TEorig = TEorig;
INPUT.ReconPars = ReconPars;
[MAP,err] = func(MAP,INPUT);
if err.flag
    return
end
clear INPUT;
if strcmp(B0MAP.shimcalpol,'AbsFreq')
    fMap = MAP.fMap;
elseif strcmp(B0MAP.shimcalpol,'B0')
    fMap = -MAP.fMap;
end

%---------------------------------------------
% Plot
%---------------------------------------------
if strcmp(B0MAP.plot,'Yes')
    INPUT.numberslices = 16;
    INPUT.Image = cat(4,fMap,BaseIm);
    INPUT.MSTRCT.ImInfo = IMG.IMDISP.ImInfo;
    [MCHRS,err] = DefaultMontageChars_v1a(INPUT);
    if err.flag
        return
    end
    MCHRS.MSTRCT.fhand = figure;
    INPUT = MCHRS;
%     if max(abs(fMap(:))) > 100
%         dispwid = [-100 100];
%         INPUT.dispwid = dispwid;
%     end
    INPUT.Name = 'B0Map';
    B0mapOverlayWithHist_v1a(INPUT);
    truesize(MCHRS.MSTRCT.fhand,[500 600]);
end

%----------------------------------------------
% Naming
%----------------------------------------------
if isfield(IMG,'name')
    B0MAP.name = IMG.name;
    if strfind(B0MAP.name,'.mat');
        B0MAP.name = B0MAP.name(1:end-4);
    end
    if strfind(B0MAP.name,'IMG_');
        B0MAP.name = B0MAP.name(5:end);
    end
else
    B0MAP.name = '';
end

%----------------------------------------------
% Panel Items
%----------------------------------------------
B0MAP.PanelOutput = [PanelOutput;MAP.PanelOutput];
B0MAP.ExpDisp = PanelStruct2Text(B0MAP.PanelOutput);

%----------------------------------------------
% Set Up Compass Display
%----------------------------------------------
MSTRCT.type = 'map';
MSTRCT.colour = 'Yes';
MSTRCT.dispwid = [-max(abs(fMap(:))) max(abs(fMap(:)))];
MSTRCT.ImInfo.pixdim = [IMG.ReconPars.ImvoxTB,IMG.ReconPars.ImvoxLR,IMG.ReconPars.ImvoxIO];
MSTRCT.ImInfo.vox = IMG.ReconPars.ImvoxTB*IMG.ReconPars.ImvoxLR*IMG.ReconPars.ImvoxIO;
MSTRCT.ImInfo.info = B0MAP.ExpDisp;
MSTRCT.ImInfo.baseorient = 'Axial';             % all images should be oriented axially
INPUT.Image = fMap;
INPUT.MSTRCT = MSTRCT;
IMDISP = ImagingPlotSetup(INPUT);
B0MAP.IMDISP = IMDISP;

%---------------------------------------------
% Return
%---------------------------------------------
MAP = rmfield(MAP,'fMap');
B0MAP.MAP = MAP;
B0MAP.Im = cat(4,fMap,BaseIm);
B0MAP.ReconPars = ReconPars;
B0MAP.TEdif = TEdif;
B0MAP.TEorig = TEorig;

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);

