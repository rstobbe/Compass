%==================================================
%  (v1f)
%       - First Step Acc option
%==================================================

function [SCRPTipt,CACCM,err] = ConstEvol_TpiCentreAccelerate_v1f(SCRPTipt,CACCMipt)

Status2('done','Get Evolution Constraint info',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
CACCM.method = CACCMipt.Func;   
CACCM.gvelstart = str2double(CACCMipt.('GvelStart'));
CACCM.gaccstart = str2double(CACCMipt.('GaccStart'));
CACCM.gvelreturn = str2double(CACCMipt.('GvelReturn'));
CACCM.gaccreturn = str2double(CACCMipt.('GaccReturn'));
CACCM.gacctransition = str2double(CACCMipt.('GaccTransition'));
CACCM.fracdecel = str2double(CACCMipt.('FracDecel'));

Status2('done','',3);