%==================================================
% (v1e)
%       - Update to Accomodate 'OutIn'
%==================================================

function [SCRPTipt,DESMETH,err] = DesMeth_YarnBallFullOptions_v1e(SCRPTipt,DESMETHipt)

Status('busy','Create YarnBall Design');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
DESMETH.method = DESMETHipt.Func;
DESMETH.elipfunc = DESMETHipt.('Elipfunc').Func;
DESMETH.spinfunc = DESMETHipt.('Spinfunc').Func;
DESMETH.desoltimfunc = DESMETHipt.('DeSolTimfunc').Func;
DESMETH.accconstfunc = DESMETHipt.('ConstEvolfunc').Func;
DESMETH.colourfunc = DESMETHipt.('Colourfunc').Func;
DESMETH.testfunc = DESMETHipt.('DesTestfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
ELIPipt = DESMETHipt.('Elipfunc');
if isfield(DESMETHipt,('Elipfunc_Data'))
    ELIPipt.Elipfunc_Data = DESMETHipt.Elipfunc_Data;
end
SPINipt = DESMETHipt.('Spinfunc');
if isfield(DESMETHipt,('Spinfunc_Data'))
    SPINipt.Spinfunc_Data = DESMETHipt.Spinfunc_Data;
end
DESOLipt = DESMETHipt.('DeSolTimfunc');
if isfield(DESMETHipt,('DeSolTimfunc_Data'))
    DESOLipt.DeSolTimfunc_Data = DESMETHipt.DeSolTimfunc_Data;
end
CACCipt = DESMETHipt.('ConstEvolfunc');
if isfield(DESMETHipt,('ConstEvolfunc_Data'))
    CACCipt.ConstEvolfunc_Data = DESMETHipt.ConstEvolfunc_Data;
end
CLRipt = DESMETHipt.('Colourfunc');
if isfield(DESMETHipt,('Colourfunc_Data'))
    CLRipt.Colourfunc_Data = DESMETHipt.Colourfunc_Data;
end
TSTipt = DESMETHipt.('DesTestfunc');
if isfield(DESMETHipt,('DesTestfunc_Data'))
    TSTipt.DesTestfunc_Data = DESMETHipt.DesTestfunc_Data;
end

%------------------------------------------
% Get Elip Function Info
%------------------------------------------
func = str2func(DESMETH.elipfunc);           
[SCRPTipt,ELIP,err] = func(SCRPTipt,ELIPipt);
if err.flag
    return
end

%------------------------------------------
% Get Spinning Function Info
%------------------------------------------
func = str2func(DESMETH.spinfunc);           
[SCRPTipt,SPIN,err] = func(SCRPTipt,SPINipt);
if err.flag
    return
end

%------------------------------------------
% Get DE Solution Timing Function Info
%------------------------------------------
func = str2func(DESMETH.desoltimfunc);           
[SCRPTipt,DESOL,err] = func(SCRPTipt,DESOLipt);
if err.flag
    return
end

%------------------------------------------
% Get Acceleration Constraint Info
%------------------------------------------
func = str2func(DESMETH.accconstfunc);           
[SCRPTipt,CACC,err] = func(SCRPTipt,CACCipt);
if err.flag
    return
end

%------------------------------------------
% Get Colour Info
%------------------------------------------
func = str2func(DESMETH.colourfunc);           
[SCRPTipt,CLR,err] = func(SCRPTipt,CLRipt);
if err.flag
    return
end

%------------------------------------------
% Get Colour Info
%------------------------------------------
func = str2func(DESMETH.testfunc);           
[SCRPTipt,TST,err] = func(SCRPTipt,TSTipt);
if err.flag
    return
end

%------------------------------------------
% Basic Implementation for Design
%------------------------------------------
IMPTYPE.method = 'ImpType_Basic_v1a';

%------------------------------------------
% Return
%------------------------------------------
DESMETH.ELIP = ELIP;
DESMETH.SPIN = SPIN;
DESMETH.DESOL = DESOL;
DESMETH.CACC = CACC;
DESMETH.CLR = CLR;
DESMETH.TST = TST;
DESMETH.IMPTYPE = IMPTYPE;

Status2('done','',2);
Status2('done','',3);

