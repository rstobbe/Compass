%=========================================================
% 
%=========================================================

function [MOF,err] = MontageOverlayFigure_v1a_Func(MOF,INPUT)

Status2('busy','Motage Overlay Figure',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%----------------------------------------------
% Get input
%----------------------------------------------
Image = INPUT.Image;
MSTRCT = INPUT.MSTRCT;
if isfield(INPUT,'DPROPS')
    DPROPS = INPUT.DPROPS;    
    if isempty(DPROPS)
        DPROPS.returnmont = 'No';
    else
        if isfield(DPROPS,'figno')
            MSTRCT.figno = DPROPS.figno;
        end
    end
else
    DPROPS.returnmont = 'No';
end
IMSCL = MOF.IMSCL;
MSCL = MOF.MSCL;
PLOT = MOF.PLOT;
clear INPUT

%----------------------------------------------
% Test
%----------------------------------------------
sz = size(Image);
if length(sz) == 3
    err.flag = 1;
    err.msg = 'Two images are necessary for an overlay';
    return
end
Im1 = squeeze(Image(:,:,:,1));
Im2 = squeeze(Image(:,:,:,2));

%----------------------------------------------
% Scale1
%----------------------------------------------
func = str2func([MOF.imscalefunc,'_Func']);  
INPUT.Image = Im1;
INPUT.MSTRCT = struct();
[IMSCL,err] = func(IMSCL,INPUT);
if err.flag
    return
end
clear INPUT;
Im1 = IMSCL.Image;
MSTRCT0 = IMSCL.MSTRCT;
MSTRCT.dispwid1 = MSTRCT0.dispwid;
MSTRCT.type1 = MSTRCT0.type;

%----------------------------------------------
% Scale2
%----------------------------------------------
func = str2func([MOF.mapscalefunc,'_Func']);  
INPUT.Image = Im2;
INPUT.MSTRCT = struct();
[MSCL,err] = func(MSCL,INPUT);
if err.flag
    return
end
clear INPUT;
Im2 = MSCL.Image;
MSTRCT0 = MSCL.MSTRCT;
MSTRCT.dispwid2 = MSTRCT0.dispwid;
MSTRCT.type2 = MSTRCT0.type;

%----------------------------------------------
% Plot
%----------------------------------------------
func = str2func([MOF.plotfunc,'_Func']);  
Image(:,:,:,1) = Im1;
Image(:,:,:,2) = Im2;
INPUT.Image = Image;
INPUT.MSTRCT = MSTRCT;
[PLOT,err] = func(PLOT,INPUT);
if err.flag
    return
end
clear INPUT;


Status2('done','',2);
Status2('done','',3);
