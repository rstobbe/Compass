%==================================================
%  (v1a)
%       - 
%==================================================

function [SCRPTipt,CACCM,err] = ConstEvol_TpiGradMagConstrain_v1a(SCRPTipt,CACCMipt)

Status2('done','Get Evolution Constraint info',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
CACCM.method = CACCMipt.Func;   
CACCM.gvelstart = str2double(CACCMipt.('GvelStart'));
CACCM.gaccstart = str2double(CACCMipt.('GaccStart'));
CACCM.gmaginit = str2double(CACCMipt.('GmagInit'));

CACCM.gvelreturn = str2double(CACCMipt.('GvelReturn'));
CACCM.gaccreturn = str2double(CACCMipt.('GaccReturn'));
CACCM.gacctransition = str2double(CACCMipt.('GaccTransition'));
CACCM.fracdecel = str2double(CACCMipt.('FracDecel'));

Status2('done','',3);