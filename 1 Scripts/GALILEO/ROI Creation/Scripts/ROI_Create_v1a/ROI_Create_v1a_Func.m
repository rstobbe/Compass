%=========================================================
% 
%=========================================================

function [ROICREATE,err] = ROI_Create_v1a_Func(ROICREATE,INPUT)

Status('busy','ROI Creation');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
CREATE = INPUT.CREATE;
OUT = INPUT.OUT;
clear INPUT

%---------------------------------------------
% Edit ROI
%---------------------------------------------
func = str2func([ROICREATE.createfunc,'_Func']);
INPUT = struct();
[CREATE,err] = func(CREATE,INPUT);
if err.flag
    return
end

%---------------------------------------------
% Save ROI
%---------------------------------------------
func = str2func([ROICREATE.outfunc,'_Func']);
INPUT.ROI = CREATE.ROI;
INPUT.Suffix = CREATE.Suffix;
INPUT.Path = CREATE.Path;
[OUT,err] = func(OUT,INPUT);
if err.flag
    return
end

ROICREATE.SaveRois = OUT.SaveRois;
ROICREATE.LoadRois = OUT.LoadRois;
ROICREATE.ROIARR = OUT.ROIARR;

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
ROICREATE.PanelOutput = [OUT.PanelOutput;CREATE.PanelOutput];
ROICREATE.ExpDisp = PanelStruct2Text(ROICREATE.PanelOutput);

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);
