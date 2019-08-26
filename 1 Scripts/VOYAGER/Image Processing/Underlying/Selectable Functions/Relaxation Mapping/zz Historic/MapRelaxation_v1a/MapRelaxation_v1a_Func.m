%====================================================
%  
%====================================================

function [RLXMAP,err] = MapRelaxation_v1a_Func(RLXMAP,INPUT)

Status('busy','Map Relaxation');
Status2('busy','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Test
%---------------------------------------------
IMG = INPUT.IMG;
MAPFUNC = RLXMAP.MAPFUNC;
BASE = RLXMAP.BASE;
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
    IMG0 = IMG{1};
    ReconPars0 = IMG0.ReconPars;
    if isfield(IMG0.FID,'Shim')
        Shims0 = IMG0.FID.Shim;
    else 
        Shims0 = struct();
    end
    ExpPars0 = IMG0.ExpPars;
    tExpPars0 = rmfield(ExpPars0,'Sequence');
    Te(1) = ExpPars0.Sequence.te;    
    Im0 = IMG0.Im;
    sz = size(Im0);
    if length(sz) > 3
        err.flag = 1 ;
        err.msg = 'Multidimensional images not currently supported';
        return
    end
    Im = zeros([sz length(IMG)]);
    Im(:,:,:,1) = IMG0.Im;  
    for n = 2:length(IMG)
        ExpPars = IMG{n}.ExpPars;
        ReconPars = IMG{n}.ReconPars;
        if isfield(IMG{n}.FID,'Shim')
            Shims = IMG{n}.FID.Shim;
        else
            Shims = struct();
        end
        %----------------------------------------
        % Compare
        %----------------------------------------
        [~,~,comperr] = comp_struct(ReconPars0,ReconPars,'ReconPars0','ReconPars');
        if not(isempty(comperr))
            err.flag = 1;
            err.msg = 'Image recons do not match';
            return
        end
        if not(isempty(Shims0)) || not(isempty(Shims))
            [~,~,comperr] = comp_struct(Shims0,Shims,'Shims0','Shims');
            if not(isempty(comperr))
                err.flag = 1;
                err.msg = 'Image do not have the same shimming';
                return
            end
        end
        tExpPars = rmfield(ExpPars,'Sequence');    
        [~,~,comperr] = comp_struct(tExpPars0,tExpPars,'tExpPars0','tExpPars');
        if not(isempty(comperr))
            err.flag = 1;
            err.msg = 'Images do not have the same experiment paramteres';
            return
        end
        Te(n) = ExpPars.Sequence.te;  
        Im(:,:,:,n) = IMG{n}.Im;  
    end
    IMG = IMG0;
    PanelOutput = IMG.PanelOutput;        
    ExpPars = ExpPars0;
    ReconPars = ReconPars0;
else
%     if isfield(IMG,'ImageType')
%         if not(strcmp(IMG.ImageType,'Image'))
%             err.flag = 1;
%             err.msg = 'Input File Not Image';
%             return
%         end
%     end
%     if isfield(IMG.ExpPars,'Array')
%         Array = IMG.ExpPars.Array;
%         if Array.ArrLen ~= 2
%             err.flag = 1;
%             err.msg = 'Image Array Not Supported';
%             return
%         end
%         if not(strcmp(Array.ArrayName,'B1Map'))
%             if isempty(Array.ArrayName)
%                 button = questdlg('Image Array Undefined, Continue?'); 
%             else
%                 button = questdlg(['Image Array: "',Array.ArrayName,'", Continue?']);
%             end
%             if not(strcmp(button,'Yes'))
%                 return
%             end
%         end
%         if not(isfield(Array.ArrayParams,'fa'))
%             err.flag = 1;
%             err.msg = 'Image Array Not Supported';
%             return
%         end
%         Im = IMG.Im;
%         flipangle = Array.ArrayParams.fa;
%         PanelOutput = IMG.PanelOutput;
%         ReconPars = IMG.ReconPars;
%         ExpPars = IMG.ExpPars;
%         ExpDisp = IMG.ExpDisp;
%         FID = IMG.FID;
%     end       
end

%---------------------------------------------
% Create Base Image for Display
%---------------------------------------------
func = str2func([RLXMAP.baseimfunc,'_Func']);  
INPUT.Im = Im;
INPUT.ExpPars = ExpPars;
[BASE,err] = func(BASE,INPUT);
if err.flag
    return
end
clear INPUT;
BaseIm = BASE.Im;

%---------------------------------------------
% Relaxation Map
%---------------------------------------------
func = str2func([RLXMAP.mapfunc,'_Func']);  
INPUT.Im = Im;
INPUT.ReconPars = ReconPars;
INPUT.Te = Te;
INPUT.ExpPars = ExpPars;
[MAPFUNC,err] = func(MAPFUNC,INPUT);
if err.flag
    return
end
clear INPUT;
T2Map = MAPFUNC.T2Map;

%---------------------------------------------
% Plot
%---------------------------------------------
if strcmp(RLXMAP.plot,'Yes')
    INPUT.numberslices = 16;
    INPUT.Image = cat(4,T2Map,BaseIm);
    INPUT.MSTRCT.ImInfo = IMG.IMDISP.ImInfo;
    [MCHRS,err] = DefaultMontageChars_v1a(INPUT);
    if err.flag
        return
    end
    MCHRS.MSTRCT.fhand = figure;
    INPUT = MCHRS;
    INPUT.Name = 'T2Map';
    T2mapOverlayWithHist_v1a(INPUT);
    truesize(MCHRS.MSTRCT.fhand,[500 600]);
end

%----------------------------------------------
% Naming
%----------------------------------------------
if isfield(IMG,'name')
    RLXIMG.name = IMG.name;
    if strfind(RLXIMG.name,'.mat')
        RLXIMG.name = RLXIMG.name(1:end-4);
    end
    if strfind(RLXIMG.name,'IMG_')
        RLXIMG.name = ['RLXMAP_',RLXIMG.name(5:end)];
    end
else
    RLXIMG.name = '';
end
RLXIMG.path = IMG.path;

%----------------------------------------------
% Panel Items
%----------------------------------------------
RLXIMG.PanelOutput = [PanelOutput;MAPFUNC.PanelOutput];
RLXIMG.ExpDisp = PanelStruct2Text(RLXIMG.PanelOutput);

%----------------------------------------------
% Set Up Compass Display
%----------------------------------------------
MSTRCT.type = 'map';
MSTRCT.colour = 'Yes';
MSTRCT.dispwid = [0 10];
MSTRCT.ImInfo.pixdim = [IMG.ReconPars.ImvoxTB,IMG.ReconPars.ImvoxLR,IMG.ReconPars.ImvoxIO];
MSTRCT.ImInfo.vox = IMG.ReconPars.ImvoxTB*IMG.ReconPars.ImvoxLR*IMG.ReconPars.ImvoxIO;
MSTRCT.ImInfo.info = RLXIMG.ExpDisp;
MSTRCT.ImInfo.baseorient = 'Axial';             % all images should be oriented axially
INPUT.Image = T2Map;
INPUT.MSTRCT = MSTRCT;
IMDISP = ImagingPlotSetup(INPUT);
RLXIMG.IMDISP = IMDISP;

%---------------------------------------------
% Return
%---------------------------------------------
MAPFUNC = rmfield(MAPFUNC,'T2Map');
RLXMAP.MAPFUNC = MAPFUNC;
RLXIMG.Im = cat(4,T2Map,BaseIm);
RLXIMG.ReconPars = ReconPars;
RLXMAP.IMG = RLXIMG;

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);
