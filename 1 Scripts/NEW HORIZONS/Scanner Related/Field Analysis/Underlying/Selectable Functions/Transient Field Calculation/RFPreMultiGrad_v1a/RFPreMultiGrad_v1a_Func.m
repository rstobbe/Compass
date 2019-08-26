%====================================================
%        
%====================================================

function [TF,err] = RFPreMultiGrad_v1a_Func(TF,INPUT)

Status2('busy','Calculate Transient Fields',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
Sys = INPUT.Sys;
POSBG = INPUT.POSBG;
clear INPUT

%-------------------------------------
% Determine Transient Fields
%-------------------------------------
[TF_Fid1,TF_Fid2,TF_Params,TF_ExpDisp,err] = Load_2LocExperiment_v4a(TF.FileGrad1,TF.FileGrad2,'RFPreMultiGrad_v1a',Sys);
if err.flag
    return
end
TF_expT = TF_Params.dwell*(0:1:TF_Params.np-1) + 0.5*TF_Params.dwell;           % puts difference value at centre of interval
[TF_PH1,TF_PH2,TF_PH1steps,TF_PH2steps] = PhaseEvolution_v2b(TF_Fid1,TF_Fid2);
[TF_Bloc1,TF_Bloc2] = FieldEvolution_v2a(TF_PH1,TF_PH2,TF_expT);
BG_smthBloc1 = interp1(POSBG.BG_expT,POSBG.BG_smthBloc1,TF_expT);
BG_smthBloc2 = interp1(POSBG.BG_expT,POSBG.BG_smthBloc2,TF_expT);
BGmesh1 = meshgrid(BG_smthBloc1,(1:TF_Params.pnum));
BGmesh2 = meshgrid(BG_smthBloc2,(1:TF_Params.pnum));
corTF_Bloc1 = TF_Bloc1 - BGmesh1;
corTF_Bloc2 = TF_Bloc2 - BGmesh2;
TF_Grad = (corTF_Bloc2 - corTF_Bloc1)/POSBG.Sep;
TF_B01 = corTF_Bloc1 - TF_Grad*POSBG.Loc1;         % TF_B01 and TF_B02 should be identical
TF_B02 = corTF_Bloc2 - TF_Grad*POSBG.Loc2;

%-------------------------------------
% Determine Phase Steps
%-------------------------------------
TF_PH1steps = TF_PH1steps(1:length(TF_PH1steps)-1);
TF_PH2steps = TF_PH2steps(1:length(TF_PH2steps)-1);
%maxTF_PH1step = max(abs(TF_PH1steps));
%maxTF_PH2step = max(abs(TF_PH2steps));
%if maxTF_PH1step > 2.75 || maxTF_PH2step > 2.75
%    figure(100); hold on;
%    plot(TF_expT(1:length(TF_expT)-1),TF_PH1steps,'r'); 
%    plot(TF_expT(1:length(TF_expT)-1),TF_PH2steps,'b');
%    title('Phase Steps During Gradient');
%    err.flag = 1;
%    err.msg = 'Probable error with probe displacement - increase sampling rate';
%    return
%end

%-------------------------------------
% Return
%-------------------------------------
ExpDisp.TF_ExpDisp = TF_ExpDisp;
TF.ExpDisp = ExpDisp;
TF.gval = TF_Params.gval;
TF.Time = TF_expT;
TF.Geddy = TF_Grad;
TF.B0eddy = TF_B01;
TF.Params = TF_Params;
TF.Data.TF_expT = TF_expT;
TF.Data.TF_Fid1 = TF_Fid1;
TF.Data.TF_Fid2 = TF_Fid2;
TF.Data.TF_PH1 = TF_PH1;
TF.Data.TF_PH2 = TF_PH2;
TF.Data.TF_PH1steps = TF_PH1steps;
TF.Data.TF_PH2steps = TF_PH2steps;
TF.Data.TF_Bloc1 = TF_Bloc1;
TF.Data.TF_Bloc2 = TF_Bloc2;
TF.Data.corTF_Bloc1 = corTF_Bloc1;
TF.Data.corTF_Bloc2 = corTF_Bloc2;
TF.Data.TF_Grad = TF_Grad;
TF.Data.TF_B01 = TF_B01;
TF.Data.TF_B02 = TF_B02;

Status2('done','',2);
Status2('done','',3);

