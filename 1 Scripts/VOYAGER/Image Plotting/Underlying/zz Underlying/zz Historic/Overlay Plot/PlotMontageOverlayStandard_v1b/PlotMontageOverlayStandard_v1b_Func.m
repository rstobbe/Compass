%=========================================================
% 
%=========================================================

function [PLOT,err] = PlotMontageOverlayStandard_v1b_Func(PLOT,INPUT)

Status2('busy','Montage Overlay',3);

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
if isfield(INPUT,'intensity')
    MSTRCT.intensity = INPUT.intensity;
else  
    MSTRCT.intensity = 'Flat50';         
end
clear INPUT

%----------------------------------------------
% Plot
%----------------------------------------------
INPUT.MSTRCT = MSTRCT;
INPUT.Image = Image;
[Img,err] = PlotMontageOverlay_v1d(INPUT);
if strcmp(DPROPS.returnmont,'Yes')
    PLOT.Img = Img;
end

%---------------------------------------------
% Return
%---------------------------------------------
Status2('done','',3);
