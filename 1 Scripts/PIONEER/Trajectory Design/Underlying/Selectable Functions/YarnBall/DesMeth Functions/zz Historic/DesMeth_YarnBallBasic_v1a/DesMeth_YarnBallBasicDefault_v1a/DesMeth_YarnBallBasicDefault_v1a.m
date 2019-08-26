%==================================================
% (v1a)
%       - 
%==================================================

function [SCRPTipt,DESMETH,err] = DesMeth_YarnBallBasicDefault_v1a(SCRPTipt,DESMETHipt)

Status('busy','Create YarnBall Design');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
DESMETH.method = DESMETHipt.Func;
DESMETH.spinfunc = DESMETHipt.('Spinfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
SPINipt = DESMETHipt.('Spinfunc');
if isfield(DESMETHipt,('Spinfunc_Data'))
    SPINipt.Spinfunc_Data = DESMETHipt.Spinfunc_Data;
end

%------------------------------------------
% Get Spinning Function Info
%------------------------------------------
func = str2func(DESMETH.spinfunc);           
[SCRPTipt,SPIN,err] = func(SCRPTipt,SPINipt);
if err.flag
    return
end

%---------------------------------------------
% Describe Elip
%---------------------------------------------
ELIP.method = 'ElipSelection_v1a';
ELIP.voxelstretch = 1;

%---------------------------------------------
% Describe Radial Evolution 
%---------------------------------------------
RADEV.method = 'RadSolEv_Design_v1b';

%---------------------------------------------
% Describe DE Solution Timing
%---------------------------------------------
DESOL.method = 'DeSolTim_YarnBallLookup_v1a';

%---------------------------------------------
% Describe Acceleration Constraint
%---------------------------------------------
CACC.method = 'ConstEvol_Simple_v1a';

%------------------------------------------
% Return
%------------------------------------------
DESMETH.ELIP = ELIP;
DESMETH.SPIN = SPIN;
DESMETH.DESOL = DESOL;
DESMETH.CACC = CACC;
DESMETH.RADEV = RADEV;

Status2('done','',2);
Status2('done','',3);

