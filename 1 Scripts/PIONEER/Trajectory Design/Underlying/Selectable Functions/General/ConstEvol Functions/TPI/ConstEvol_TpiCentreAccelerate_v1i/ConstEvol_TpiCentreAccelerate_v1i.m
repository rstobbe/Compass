%==================================================
%  (v1i)
%       - Add 'TwkLoc2'
%==================================================

function [SCRPTipt,CACC,err] = ConstEvol_TpiCentreAccelerate_v1i(SCRPTipt,CACCMipt)

Status2('done','Get Evolution Constraint info',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
CACC.method = CACCMipt.Func;   
CACC.gvelstart = str2double(CACCMipt.('GvelStart'));
CACC.gaccstart = str2double(CACCMipt.('GaccStart'));
CACC.gvelreturn = str2double(CACCMipt.('GvelReturn'));
CACC.returntwk = str2double(CACCMipt.('ReturnTwk1'));
CACC.returntwk2 = str2double(CACCMipt.('ReturnTwk2'));
CACC.twkloc2 = str2double(CACCMipt.('TwkLoc2'));
CACC.gacctransition = str2double(CACCMipt.('GaccTransition'));
CACC.fracdecel = str2double(CACCMipt.('FracDecel'));

Status2('done','',3);