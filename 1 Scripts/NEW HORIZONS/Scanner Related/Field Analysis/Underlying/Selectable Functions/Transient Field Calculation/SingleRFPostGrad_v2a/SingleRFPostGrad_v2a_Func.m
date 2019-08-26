%====================================================
% 
%====================================================

function [TF,err] = SingleRFPostGrad_v2a_Func(TF,INPUT)

Status2('busy','Calculate Transient Eddy Currents',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
POSBG = INPUT.POSBG;
FEVOL = INPUT.FEVOL;
clear INPUT

%---------------------------------------------
% Load Input
%---------------------------------------------
TF_Fid1 = FEVOL.TF_Fid1;
TF_Fid2 = FEVOL.TF_Fid2;
TF_Params = FEVOL.TF_Params;

%-------------------------------------
% Determine Transient Fields
%-------------------------------------
TF_expT = TF_Params.dwell*(0:1:TF_Params.np-1) + 0.5*TF_Params.dwell;           % puts difference value at centre of interval
[TF_PH1,TF_PH2] = PhaseEvolution_v2b(TF_Fid1,TF_Fid2);
[TF_Bloc1,TF_Bloc2] = FieldEvolution_v2a(TF_PH1,TF_PH2,TF_expT);
BG_smthBloc1 = interp1(POSBG.BG_expT,POSBG.BG_smthBloc1,TF_expT);
BG_smthBloc2 = interp1(POSBG.BG_expT,POSBG.BG_smthBloc2,TF_expT);

%-------------------------------------
% Subtract background
%-------------------------------------
corTF_Bloc1 = TF_Bloc1 - BG_smthBloc1;
corTF_Bloc2 = TF_Bloc2 - BG_smthBloc2;
TF_Grad = (corTF_Bloc2 - corTF_Bloc1)/POSBG.Sep;
TF_B01 = corTF_Bloc1 - TF_Grad*POSBG.Loc1;         % TF_B01 and TF_B02 should be identical
TF_B02 = corTF_Bloc2 - TF_Grad*POSBG.Loc2;

%-------------------------------------
% Define time associated with average field
%-------------------------------------
pgdel = TF_Params.pgdel + TF_Params.seqtime;
if strcmp(TF.timestart,'Middle of Fall');
    pgdel = pgdel + TF_Params.falltime/2;
end

%-------------------------------------
% Returned
%-------------------------------------
TF.gval = TF_Params.gval;
TF.Time = pgdel/1000+TF_expT;
TF.Geddy = TF_Grad;
TF.B0eddy = TF_B01;
TF.Params = TF_Params;
TF.Data.TF_expT = TF_expT;
TF.Data.TF_Fid1 = TF_Fid1;
TF.Data.TF_Fid2 = TF_Fid2;
TF.Data.TF_PH1 = TF_PH1;
TF.Data.TF_PH2 = TF_PH2;
TF.Data.TF_Bloc1 = TF_Bloc1;
TF.Data.TF_Bloc2 = TF_Bloc2;
TF.Data.corTF_Bloc1 = corTF_Bloc1;
TF.Data.corTF_Bloc2 = corTF_Bloc2;
TF.Data.TF_Grad = TF_Grad;
TF.Data.TF_B01 = TF_B01;
TF.Data.TF_B02 = TF_B02;

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
TF.ExpDisp = [];

Status2('done','',2);
Status2('done','',3);
