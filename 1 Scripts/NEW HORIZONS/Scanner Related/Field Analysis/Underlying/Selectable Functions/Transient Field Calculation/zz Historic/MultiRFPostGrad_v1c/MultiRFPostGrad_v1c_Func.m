%====================================================
% 
%====================================================

function [TF,err] = MultiRFPostGrad_v1c_Func(TF,INPUT)

Status2('busy','Calculate Transient Eddy Currents',2);
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
[TF_Fid1,TF_Fid2,TF_Params,TF_ExpDisp,err] = Load_2LocExperiment_v4b(TF.FileGrad1,TF.FileGrad2,'MultiRFPostGrad_v1a',Sys);
if err.flag
    return
end
TF_expT = TF_Params.dwell*(0:1:TF_Params.np-1) + 0.5*TF_Params.dwell;           % puts difference value at centre of interval
[TF_PH1,TF_PH2] = PhaseEvolution_v2b(TF_Fid1,TF_Fid2);
[TF_Bloc1,TF_Bloc2] = FieldEvolution_v2a(TF_PH1,TF_PH2,TF_expT);
BG_smthBloc1 = interp1(POSBG.BG_expT,POSBG.BG_smthBloc1,TF_expT);
BG_smthBloc2 = interp1(POSBG.BG_expT,POSBG.BG_smthBloc2,TF_expT);

%-------------------------------------
% Subtract background and separate
%-------------------------------------
ind1 = find(TF_expT>TF.gstart,1,'first');
ind2 = find(TF_expT>TF.gstop,1,'first');
if isempty(ind2)
    err.flag = 1;
    err.msg = 'gstop beyond sampling duration';
    return
end
[nexp,~,nacq] = size(TF_Fid1);
corTF_Bloc1 = zeros(size(TF_Fid1));
corTF_Bloc2 = zeros(size(TF_Fid1));
TF_Grad = zeros(size(TF_Fid1));
TF_B01 = zeros(size(TF_Fid1));
TF_B02 = zeros(size(TF_Fid1));
for n = 1:nexp
    for m = 1:nacq
        corTF_Bloc1(n,:,m) = TF_Bloc1(n,:,m) - BG_smthBloc1;
        corTF_Bloc2(n,:,m) = TF_Bloc2(n,:,m) - BG_smthBloc2;
        TF_Grad(n,:,m) = (corTF_Bloc2(n,:,m) - corTF_Bloc1(n,:,m))/POSBG.Sep;
        TF_B01(n,:,m) = corTF_Bloc1(n,:,m) - TF_Grad(n,:,m)*POSBG.Loc1;         % TF_B01 and TF_B02 should be identical
        TF_B02(n,:,m) = corTF_Bloc2(n,:,m) - TF_Grad(n,:,m)*POSBG.Loc2;
        mean_TF_Grad(n,m) = mean(TF_Grad(n,ind1:ind2,m));
        mean_TF_B01(n,m) = mean(TF_B01(n,ind1:ind2,m));
        mean_TF_B02(n,m) = mean(TF_B02(n,ind1:ind2,m));
    end
end

%-------------------------------------
% Define time associated with average field
%-------------------------------------
gofftime0 = TF_Params.gofftime + (TF.gstop+TF.gstart)/2000 + TF_Params.seqtime/1e6;
if strcmp(TF.timestart,'Middle of Fall');
    gofftime0 = gofftime0 + TF_Params.falltime/2e6;
end

%-------------------------------------
% Join Experiments
%-------------------------------------
B0eddy = zeros(1,nacq*nexp);
Geddy = zeros(1,nacq*nexp);
gofftime = zeros(1,nacq*nexp);
for n = 1:nexp
    for m = 1:nacq
        gofftime((m-1)*nexp+n) = gofftime0(n,m);
        Geddy((m-1)*nexp+n) =  mean_TF_Grad(n,m);
        B0eddy((m-1)*nexp+n) = mean_TF_B01(n,m);
    end
end

%-------------------------------------
% Returned
%-------------------------------------
ExpDisp.TF_ExpDisp = TF_ExpDisp;
TF.ExpDisp = ExpDisp;
TF.gval = TF_Params.gval;
TF.Time = gofftime*1000;
TF.Geddy = Geddy;
TF.B0eddy = B0eddy;
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

Status2('done','',2);
Status2('done','',3);
