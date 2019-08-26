%==================================================
% (v1a)
%       
%==================================================

function [SCRPTipt,DESMETH,err] = DesMeth_TpiBasicOptions_v1a(SCRPTipt,DESMETHipt)

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
DESMETH.tpitypefunc = DESMETHipt.('TpiTypefunc').Func;
DESMETH.desoltimfunc = DESMETHipt.('DeSolTimfunc').Func;
DESMETH.testfunc = DESMETHipt.('DesTestfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
ELIPipt = DESMETHipt.('Elipfunc');
if isfield(DESMETHipt,('Elipfunc_Data'))
    ELIPipt.Elipfunc_Data = DESMETHipt.Elipfunc_Data;
end
TPITipt = DESMETHipt.('TpiTypefunc');
if isfield(DESMETHipt,('TpiTypefunc_Data'))
    TPITipt.TpiTypefunc_Data = DESMETHipt.TpiTypefunc_Data;
end
DESOLipt = DESMETHipt.('DeSolTimfunc');
if isfield(DESMETHipt,('DeSolTimfunc_Data'))
    DESOLipt.DeSolTimfunc_Data = DESMETHipt.DeSolTimfunc_Data;
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
% Get DE Solution Timing Function Info
%------------------------------------------
func = str2func(DESMETH.desoltimfunc);           
[SCRPTipt,DESOL,err] = func(SCRPTipt,DESOLipt);
if err.flag
    return
end

%------------------------------------------
% Get TpiTypefunc Info
%------------------------------------------
func = str2func(DESMETH.tpitypefunc);           
[SCRPTipt,TPIT,err] = func(SCRPTipt,TPITipt);
if err.flag
    return
end

%------------------------------------------
% Get Test Info
%------------------------------------------
func = str2func(DESMETH.testfunc);           
[SCRPTipt,TST,err] = func(SCRPTipt,TSTipt);
if err.flag
    return
end

%---------------------------------------------
% Describe Radial Evolution 
%---------------------------------------------
RADEV.method = 'RadSolEv_TpiDesignTest_v1c';

%------------------------------------------
% Return
%------------------------------------------
DESMETH.ELIP = ELIP;
DESMETH.DESOL = DESOL;
DESMETH.TPIT = TPIT;
DESMETH.RADEV = RADEV;
DESMETH.TST = TST;

Status2('done','',2);
Status2('done','',3);