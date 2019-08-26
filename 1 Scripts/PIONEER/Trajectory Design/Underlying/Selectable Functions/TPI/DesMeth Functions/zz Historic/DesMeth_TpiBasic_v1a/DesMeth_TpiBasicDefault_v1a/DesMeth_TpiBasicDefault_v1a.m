%==================================================
% (v1b)
%       - Include Colour
%==================================================

function [SCRPTipt,DESMETH,err] = DesMeth_YarnBallBasicDefault_v1b(SCRPTipt,DESMETHipt)

Status('busy','Create YarnBall Design');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
DESMETH.method = DESMETHipt.Func;

%---------------------------------------------
% Describe Colour
%---------------------------------------------
CLR.method = 'Colour_Green_v1a';

%---------------------------------------------
% Describe Elip
%---------------------------------------------
ELIP.method = 'Elip_Selection_v1a';
ELIP.voxelstretch = 1;

%---------------------------------------------
% Describe Radial Evolution 
%---------------------------------------------
RADEV.method = 'RadSolEv_DesignTest_v1b';

%---------------------------------------------
% Describe DE Solution Timing
%---------------------------------------------
DESOL.method = 'DeSolTim_YarnBallLookup_v1b';

%---------------------------------------------
% Describe Acceleration Constraint
%---------------------------------------------
CACC.method = 'ConstEvol_Simple_v1a';

%---------------------------------------------
% Describe Test
%---------------------------------------------
TST.method = 'DesTest_Basic_v1a';

%---------------------------------------------
% Describe Spin
%---------------------------------------------
SPIN.method = 'Spin_SportWeight_v1a';

%------------------------------------------
% Return
%------------------------------------------
DESMETH.CLR = CLR;
DESMETH.ELIP = ELIP;
DESMETH.SPIN = SPIN;
DESMETH.DESOL = DESOL;
DESMETH.CACC = CACC;
DESMETH.RADEV = RADEV;
DESMETH.TST = TST;

Status2('done','',2);
Status2('done','',3);

