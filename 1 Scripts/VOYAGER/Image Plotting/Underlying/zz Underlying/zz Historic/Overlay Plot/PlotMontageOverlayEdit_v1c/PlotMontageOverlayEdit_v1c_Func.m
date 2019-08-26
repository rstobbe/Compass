%=========================================================
% 
%=========================================================

function [PLOT,err] = PlotMontageOverlayEdit_v1c_Func(PLOT,INPUT)

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
MSTRCT.intensity = PLOT.intensity;

clear INPUT

%----------------------------------------------
% Plot
%----------------------------------------------
INPUT.MSTRCT = MSTRCT;
INPUT.Image = Image;
[Img,err] = PlotMontageOverlay_v1c(INPUT);
if strcmp(DPROPS.returnmont,'Yes')
    PLOT.Img = Img;
end

%---------------------------------------------
% Return
%---------------------------------------------
Status2('done','',3);



