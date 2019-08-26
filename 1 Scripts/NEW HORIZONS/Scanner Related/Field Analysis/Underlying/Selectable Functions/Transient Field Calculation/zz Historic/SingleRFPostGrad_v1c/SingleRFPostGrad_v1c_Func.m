%====================================================
% 
%====================================================

function [TF,err] = SingleRFPostGrad_v1c_Func(TF,INPUT)

Status2('busy','Calculate Transient Eddy Currents',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
Sys = INPUT.Sys;
clear INPUT

%-------------------------------------
% Determine Transient Fields
%-------------------------------------
[TF_Fid1,TF_Fid2,TF_Params,TF_ExpDisp,err] = Load_2LocExperiment_v4b(TF.FileGrad1,TF.FileGrad2,'SingleRFPostGrad_v1a',Sys);
if err.flag
    return
end
TF_expT = TF_Params.dwell*(0:1:TF_Params.np-1) + 0.5*TF_Params.dwell;           % puts difference value at centre of interval
[TF_PH1,TF_PH2] = PhaseEvolution_v2a(TF_Fid1,TF_Fid2);
[TF_Bloc1,TF_Bloc2] = FieldEvolution_v2a(TF_PH1,TF_PH2,TF_expT);
BG_smthBloc1 = interp1(POSBG.BG_expT,POSBG.BG_smthBloc1,TF_expT);
BG_smthBloc2 = interp1(POSBG.BG_expT,POSBG.BG_smthBloc2,TF_expT);

%-------------------------------------
% Subtract background and separate
%-------------------------------------
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
    end
end

%-------------------------------------
% Join
%-------------------------------------
ind1 = find(TF_expT>=TF.gstart,1,'first');
ind2 = find(TF_expT>=TF.gstop,1,'first');
TF_B0_Joined = NaN*zeros(nexp,1000*TF_Params.initdels(nexp)/TF_Params.dwell+ind2);
TF_Grad_Joined = NaN*zeros(size(TF_B0_Joined));
for n = 1:nexp 
    start = 1000*TF_Params.initdels(n)/TF_Params.dwell + ind1;
    TF_B0_Joined(n,start:start+ind2-ind1) = TF_B01(n,ind1:ind2);
    TF_Grad_Joined(n,start:start+ind2-ind1) = TF_Grad(n,ind1:ind2);
end
for m = 1:length(TF_B0_Joined)
    totB = 0;
    totG = 0;
    vals = 0;
    for n = 1:nexp
        if not(isnan(TF_B0_Joined(n,m)))
            totB = totB + TF_B0_Joined(n,m);
            totG = totG + TF_Grad_Joined(n,m);
            vals = vals + 1;
        end
    end
    if vals == 0
        TF_B0_Ave(m) = NaN;
        TF_Grad_Ave(m) = NaN;
    else
        TF_B0_Ave(m) = totB/vals;
        TF_Grad_Ave(m) = totG/vals;
    end
end
TF_expT_Joined = (0:TF_Params.dwell:TF_Params.dwell*(length(TF_B0_Joined)-1));

%-------------------------------------
% Add Additional times
%-------------------------------------
TF_expT_Joined = TF_expT_Joined + TF_Params.seqtime/1000;
if strcmp(TF.timestart,'Middle of Fall');
    TF_expT_Joined = TF_expT_Joined + TF_Params.falltime/2000;
end

%-------------------------------------
% Returned
%-------------------------------------
ExpDisp.TF_ExpDisp = TF_ExpDisp;
TF.ExpDisp = ExpDisp;
TF.gval = TF_Params.gval;
TF.Time = TF_expT_Joined;
TF.Geddy = TF_Grad_Ave;
TF.B0eddy = TF_B0_Ave;
TF.Data.TF_Params = TF_Params;
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
Panel(1,:) = {'Loc1',Loc1,'Output'};
Panel(2,:) = {'Loc2',Loc2,'Output'};
Panel(3,:) = {'Sep',Sep,'Output'};
Panel(4,:) = {'meanBGGrad',meanBGGrad,'Output'};
Panel(5,:) = {'meanBGB0',meanBGB0,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
POSBG.PanelOutput = PanelOutput;

Status2('done','',2);
Status2('done','',3);