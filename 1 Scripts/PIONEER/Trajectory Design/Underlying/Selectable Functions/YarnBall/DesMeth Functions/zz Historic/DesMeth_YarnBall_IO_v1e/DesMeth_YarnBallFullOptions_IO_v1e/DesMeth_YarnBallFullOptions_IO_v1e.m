%==================================================
% (v1e)
%       - First 'IO' version
%==================================================

function [SCRPTipt,DESMETH,err] = DesMeth_YarnBallFullOptions_IO_v1e(SCRPTipt,DESMETHipt)

Status('busy','Create YarnBall Design (IO capability)');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
DESMETH.method = DESMETHipt.Func;
DESMETH.genprojfunc = DESMETHipt.('GenProjfunc').Func;
DESMETH.elipfunc = DESMETHipt.('Elipfunc').Func;
DESMETH.spinfunc = DESMETHipt.('Spinfunc').Func;
DESMETH.desoltimfunc = DESMETHipt.('DeSolTimfunc').Func;
DESMETH.accconstfunc = DESMETHipt.('ConstEvolfunc').Func;
DESMETH.colourfunc = DESMETHipt.('Colourfunc').Func;
DESMETH.turnaroundfunc = DESMETHipt.('TurnAroundfunc').Func;
DESMETH.testfunc = DESMETHipt.('DesTestfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
GENPRJipt = DESMETHipt.('GenProjfunc');
if isfield(DESMETHipt,('GenProjfunc_Data'))
    GENPRJipt.GenProjfunc_Data = DESMETHipt.GenProjfunc_Data;
end
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
TURNipt = DESMETHipt.('TurnAroundfunc');
if isfield(DESMETHipt,('TurnAroundfunc_Data'))
    TURNipt.TurnAroundfunc_Data = DESMETHipt.TurnAroundfunc_Data;
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
% Get GenProj Info
%------------------------------------------
func = str2func(DESMETH.colourfunc);           
[SCRPTipt,GENPRJ,err] = func(SCRPTipt,GENPRJipt);
if err.flag
    return
end

%------------------------------------------
% Get TurnAround Info
%------------------------------------------
func = str2func(DESMETH.turnaroundfunc);           
[SCRPTipt,TURN,err] = func(SCRPTipt,TURNipt);
if err.flag
    return
end

%------------------------------------------
% Get Testing Info
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
DESMETH.GENPRJ = GENPRJ;
DESMETH.CLR = CLR;
DESMETH.TURN = TURN;
DESMETH.TST = TST;
DESMETH.IMPTYPE = IMPTYPE;

Status2('done','',2);
Status2('done','',3);

