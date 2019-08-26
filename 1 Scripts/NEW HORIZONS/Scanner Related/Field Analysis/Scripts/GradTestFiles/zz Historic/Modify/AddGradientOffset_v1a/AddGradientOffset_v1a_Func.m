%=====================================================
% 
%=====================================================

function [GRD,err] = AddGradientOffset_v1a_Func(GRD,INPUT)

Status('busy','AddGradientOffset');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
WRTP = INPUT.WRTP;
WRTG = INPUT.WRTG;
GRD0 = INPUT.GRD0;
clear INPUT

%---------------------------------------------
% Add Offset
%---------------------------------------------
goffset = GRD.goffset;
GRD = GRD0;
G = GRD.G + goffset;
GRD.goffset = goffset;

%---------------------------------------------
% Write Gradients
%---------------------------------------------
func = str2func([GRD.wrtgradfunc,'_Func']);
INPUT.G = G;
INPUT.rdur = 1;
[WRTG,err] = func(WRTG,INPUT);
if err.flag
    return
end
clear INPUT

%---------------------------------------------
% Write Parameter File
%--------------------------------------------- 
func = str2func([GRD.wrtparamfunc,'_Func']);
INPUT.gontime = GRD.tgwfm;
INPUT.gval = 0;
INPUT.gvalinparam = 0;
INPUT.slewrate = 0;
INPUT.falltime = 0;
INPUT.pnum = 1;
INPUT.GradLoc = [WRTG.GradLoc];
[WRTP,err] = func(WRTP,INPUT);
if err.flag 
    return
end
clear INPUT

%---------------------------------------------
% Return
%--------------------------------------------- 
GRD.WRTP = WRTP;


