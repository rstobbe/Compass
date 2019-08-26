%======================================================
% 
%======================================================

function [ANLZ,err] = CreateDesImpTF_v1a_Func(ANLZ,INPUT)

Status('busy','TF Calculation');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMP = INPUT.IMP;
TFS = INPUT.TFS;
clear INPUT

%---------------------------------------------
% Build Transfer Function
%---------------------------------------------
func = str2func([ANLZ.tfbuildfunc,'_Func']);  
INPUT.IMP = IMP;
INPUT.tfdiam = [];
INPUT.tforient = '';
INPUT.vis = 'On';
[TFS,err] = func(TFS,INPUT);
if err.flag
    return
end
clear INPUT;

%---------------------------------------------
% Return 
%---------------------------------------------
ANLZ.tf = TFS.tf;
TFS = rmfield(TFS,'tf');
ANLZ.TFS = TFS;
ANLZ.PROJimp = IMP.PROJimp;
ANLZ.PROJdgn = IMP.impPROJdgn;
ANLZ.Panel = TFS.Panel;
ANLZ.PanelOutput = TFS.PanelOutput;

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);
