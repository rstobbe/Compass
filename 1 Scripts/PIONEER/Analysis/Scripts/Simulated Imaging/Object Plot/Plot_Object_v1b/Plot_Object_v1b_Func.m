%===========================================
%
%===========================================

function [OBPLT,err] = Plot_Object_v1b_Func(INPUT)

Status('busy','Plot Object');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
OB = INPUT.OB;
OBPLT = INPUT.OBPLT;
clear INPUT;

%----------------------------------------------------
% Build Object
%----------------------------------------------------
func = str2func([OBPLT.ObjectFunc,'_Func']);  
INPUT = struct();
[OB,err] = func(OB,INPUT);
if err.flag
    return
end
clear INPUT;
Ob = OB.Ob;
ObMatSz = OB.ObMatSz;

%---------------------------------------------
% Plot Object
%---------------------------------------------
rows = floor(sqrt(ObMatSz));
IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = ObMatSz; 
IMSTRCT.rows = rows; IMSTRCT.lvl = [0 2]; IMSTRCT.docolor = 0; IMSTRCT.SLab = 1; IMSTRCT.figsize = []; IMSTRCT.figno = 1; 
AxialMontage_v2a(Ob,IMSTRCT);

rows = 1;
IMSTRCT.type = 'abs'; IMSTRCT.start = 32; IMSTRCT.step = 1; IMSTRCT.stop = 32; 
IMSTRCT.rows = rows; IMSTRCT.lvl = [0 2]; IMSTRCT.docolor = 0; IMSTRCT.SLab = 1; IMSTRCT.figsize = []; IMSTRCT.figno = 2; 
AxialMontage_v2a(Ob,IMSTRCT);

%---------------------------------------------
% Return
%---------------------------------------------
OBPLT.PanelOutput = OB.PanelOutput;

