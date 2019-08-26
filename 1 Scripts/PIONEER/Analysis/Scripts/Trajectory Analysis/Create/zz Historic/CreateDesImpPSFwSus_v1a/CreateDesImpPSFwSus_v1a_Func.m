%======================================================
% 
%======================================================

function [ANLZ,err] = CalcTrajPSF_v1a_Func(ANLZ,INPUT)

Status('busy','PSF Calculation');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMP = INPUT.IMP;
TFS = INPUT.TFS;
SUS = INPUT.SUS;
clear INPUT

%---------------------------------------------
% Build Transfer Function
%---------------------------------------------
func = str2func([ANLZ.tfbuildfunc,'_Func']);  
INPUT.IMP = IMP;
INPUT.tfdiam = 50;
INPUT.tforient = '';
INPUT.vis = 'On';
[TFS,err] = func(TFS,INPUT);
if err.flag
    return
end
clear INPUT;

%---------------------------------------------
% Build Susceptibility Transform
%---------------------------------------------
func = str2func([ANLZ.susbuildfunc,'_Func']);  
INPUT.IMP = IMP;
INPUT.tfdiam = 50;
INPUT.tforient = '';
INPUT.vis = 'On';
[SUS,err] = func(SUS,INPUT);
if err.flag
    return
end

%---------------------------------------------
% Return 
%---------------------------------------------
if isempty(SUS.tf)
    ANLZ.tf = TFS.tf;
else
    ANLZ.tf = TFS.tf*SUS.tf;
end
ANLZ.PROJimp = IMP.PROJimp;
ANLZ.PROJdgn = IMP.impPROJdgn;


Status2('done','',1);
Status2('done','',2);
Status2('done','',3);
