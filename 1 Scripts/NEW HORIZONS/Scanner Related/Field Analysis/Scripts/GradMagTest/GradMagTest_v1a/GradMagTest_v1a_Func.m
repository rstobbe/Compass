%====================================================
%
%====================================================

function [EDDY,err] = GradMagTest_v1a_Func(EDDY,INPUT)

Status('busy','Determine Gradient Magnitude');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
FEVOL = INPUT.FEVOL;
GMAG = INPUT.GMAG;
clear INPUT

%-----------------------------------------------------
% Load Test Files
%-----------------------------------------------------
func = str2func([EDDY.fevolfunc,'_Func']);
INPUT = struct();
[FEVOL,err] = func(FEVOL,INPUT);
if err.flag
    return
end
clear INPUT

%-----------------------------------------------------
% Determine Gradient Magnitude
%-----------------------------------------------------
func = str2func([EDDY.gmagfunc,'_Func']);
INPUT.FEVOL = FEVOL;
[GMAG,err] = func(GMAG,INPUT);
if err.flag
    return
end
clear INPUT

%-----------------------------------------------------
% Display Experiment Parameters
%-----------------------------------------------------
PLoutput = PanelStruct2Text(GMAG.PanelOutput);
EDDY.ExpDisp = [char(10) PLoutput];

%--------------------------------------------
% Output Structure
%--------------------------------------------
EDDY.FEVOL = FEVOL;
EDDY.GMAG = GMAG;

Status('done','');
Status2('done','',2);
Status2('done','',3);
