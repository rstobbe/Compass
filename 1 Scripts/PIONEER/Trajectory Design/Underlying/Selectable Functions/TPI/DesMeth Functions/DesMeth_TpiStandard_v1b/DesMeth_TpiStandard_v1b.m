%==================================================
% (v1b)
%     as DesMeth_TpiSmooth_v1b
%==================================================

function [SCRPTipt,DESMETH,err] = DesMeth_TpiStandard_v1b(SCRPTipt,DESMETHipt)

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
% Describe Radial Solution 
%---------------------------------------------
RADEV.method = 'RadSolEv_TpiDesignTest_v1c';

%---------------------------------------------
% Projection Sampling
%---------------------------------------------
PSMP.method = 'ProjSamp_Cones_v1f';
PSMP.PCDfunc = 'ProjConeDist_TPI1_v1j';
PSMP.PADfunc = 'ProjAngleDist_TPI1_v2e';
PSMP.ignoreusamp = 'Yes';
PSMP.PCD.eproj = '0';
PSMP.PCD.phithetafrac0 = 0.999;
PSMP.PAD.Rnd = 71;

%------------------------------------------
% Return
%------------------------------------------
DESMETH.ELIP = ELIP;
DESMETH.DESOL = DESOL;
DESMETH.TPIT = TPIT;
DESMETH.RADEV = RADEV;
DESMETH.TST = TST;
DESMETH.PSMP = PSMP;

Status2('done','',2);
Status2('done','',3);