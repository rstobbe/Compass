%=========================================================
% 
%=========================================================

function [ROIEDIT,err] = ROI_Edit_v1b_Func(ROIEDIT,INPUT)

Status('busy','ROI Analysis');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
EDIT = INPUT.EDIT;
LOAD = INPUT.LOAD;
OUT = INPUT.OUT;
clear INPUT

%---------------------------------------------
% Load ROI
%---------------------------------------------
func = str2func([ROIEDIT.loadfunc,'_Func']);
INPUT = struct();
[LOAD,err] = func(LOAD,INPUT);
if err.flag
    return
end

%---------------------------------------------
% Edit ROI
%---------------------------------------------
func = str2func([ROIEDIT.editfunc,'_Func']);
INPUT.ROI = LOAD.ROI;
[EDIT,err] = func(EDIT,INPUT);
if err.flag
    return
end

%---------------------------------------------
% Save ROI
%---------------------------------------------
func = str2func([ROIEDIT.outfunc,'_Func']);
INPUT.ROI = EDIT.ROI;
INPUT.Suffix = EDIT.Suffix;
INPUT.Path = LOAD.Path;
[OUT,err] = func(OUT,INPUT);
if err.flag
    return
end

ROIEDIT.SaveRois = OUT.SaveRois;
ROIEDIT.LoadRois = OUT.LoadRois;
ROIEDIT.ROIARR = OUT.ROIARR;

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);
