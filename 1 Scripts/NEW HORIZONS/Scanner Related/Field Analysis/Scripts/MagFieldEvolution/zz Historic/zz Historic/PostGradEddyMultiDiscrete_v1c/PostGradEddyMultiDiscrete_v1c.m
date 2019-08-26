%====================================================
% (v1c)
%   - update for RWS_BA
%====================================================

function [SCRPTipt,SCRPTGBL,err] = PostGradEddyMultiDiscrete_v1c(SCRPTipt,SCRPTGBL)

err.flag = 0;
err.msg = '';

if not(isfield(SCRPTGBL,'File_Grad1')) || not(isfield(SCRPTGBL,'File_Grad2'))
    err.flag = 1;
    err.msg = 'Select ''Grad'' files first';
    ErrDisp(err);
    return
end

Sys = SCRPTGBL.CurrentTree.System;
File_Grad1 = SCRPTGBL.File_Grad1;
File_Grad2 = SCRPTGBL.File_Grad2;
B0cal = str2double(SCRPTGBL.CurrentTree.B0);
Gcal = str2double(SCRPTGBL.CurrentTree.G);
Gstart = str2double(SCRPTGBL.CurrentTree.Gstart);
Gstop = str2double(SCRPTGBL.CurrentTree.Gstop);
psbgfunc = SCRPTGBL.CurrentTree.PosBgrndfunc.Func;

%-----------------------------------------------------
% Determine Probe Displacement and BackGround Fields
%-----------------------------------------------------
func = str2func(psbgfunc);
[SCRPTipt,SCRPTGBL,err] = func(SCRPTipt,SCRPTGBL);
if err.flag
    ErrDisp(err);
    return
end
ExpDisp = SCRPTGBL.PosBG.ExpDisp;
Loc1 = SCRPTGBL.PosBG.Loc1;
Loc2 = SCRPTGBL.PosBG.Loc2;
Sep = SCRPTGBL.PosBG.Sep;

%-------------------------------------
% Determine Transient Fields
%-------------------------------------
[TF_Fid1,TF_Fid2,TF_expT,TF_Params,ExpDisp,errorflag,error] = Load_2LocExperiment_v3a(FileGrad1,FileGrad2,'Transient',Sys,'PostGradEddyMulti_v1a',ExpDisp);
set(findobj('tag','TestBox'),'string',ExpDisp);
if errorflag == 1
    err.flag = 1;
    err.msg = error;
    return
end
[TF_PH1,TF_PH2] = PhaseEvolution_v2a(TF_Fid1,TF_Fid2);
[TF_Bloc1,TF_Bloc2] = FieldEvolution_v2a(TF_PH1,TF_PH2,TF_expT);
BG_smthBloc1 = interp1(SCRPTGBL.PosBG.BG_expT,SCRPTGBL.PosBG.BG_smthBloc1,TF_expT);
BG_smthBloc2 = interp1(SCRPTGBL.PosBG.BG_expT,SCRPTGBL.PosBG.BG_smthBloc2,TF_expT);
%BG_smthBloc1 = zeros(size(TF_expT));
%BG_smthBloc2 = zeros(size(TF_expT));

%-------------------------------------
% Subtract background and separate
%-------------------------------------
ind1 = find(TF_expT>gstart,1,'first');
ind2 = find(TF_expT>gstop,1,'first');
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
        TF_Grad(n,:,m) = (corTF_Bloc2(n,:,m) - corTF_Bloc1(n,:,m))/Sep;
        TF_B01(n,:,m) = corTF_Bloc1(n,:,m) - TF_Grad(n,:,m)*Loc1;         % TF_B01 and TF_B02 should be identical
        TF_B02(n,:,m) = corTF_Bloc2(n,:,m) - TF_Grad(n,:,m)*Loc2;
        mean_TF_Grad(n,m) = mean(TF_Grad(n,ind1:ind2,m));
        mean_TF_B01(n,m) = mean(TF_B01(n,ind1:ind2,m));
        mean_TF_B02(n,m) = mean(TF_B02(n,ind1:ind2,m));
    end
end

%-------------------------------------
% Define time associated with average field
%-------------------------------------
if isnan(TF_Params.falltime)
    TF_Params.falltime = TF_Params.gval/120;
end
TF_Params.gofftime2 = TF_Params.gofftime + TF_Params.falltime/2000000 + (gstop+gstart)/2000;

%-------------------------------------
% Join Experiments
%-------------------------------------
B0eddy = zeros(1,nacq*nexp);
Geddy = zeros(1,nacq*nexp);
gofftime = zeros(1,nacq*nexp);
for n = 1:nexp
    for m = 1:nacq
        gofftime((m-1)*nexp+n) = TF_Params.gofftime2(n,m);
        Geddy((m-1)*nexp+n) =  mean_TF_Grad(n,m);
        B0eddy((m-1)*nexp+n) = mean_TF_B01(n,m);
    end
end

%-------------------------------------
% Return
%-------------------------------------
SCRPTGBL.B0cal = B0cal;
SCRPTGBL.gcal = gcal;
SCRPTGBL.gval = TF_Params.gval;
SCRPTGBL.Time = gofftime*1000;
SCRPTGBL.Geddy = Geddy;
SCRPTGBL.B0eddy = B0eddy;

SCRPTGBL.TF.Data.TF_Params = TF_Params;
SCRPTGBL.TF.Data.TF_expT = TF_expT;
SCRPTGBL.TF.Data.TF_Fid1 = TF_Fid1;
SCRPTGBL.TF.Data.TF_Fid2 = TF_Fid2;
SCRPTGBL.TF.Data.TF_PH1 = TF_PH1;
SCRPTGBL.TF.Data.TF_PH2 = TF_PH2;
SCRPTGBL.TF.Data.TF_Bloc1 = TF_Bloc1;
SCRPTGBL.TF.Data.TF_Bloc2 = TF_Bloc2;
SCRPTGBL.TF.Data.corTF_Bloc1 = corTF_Bloc1;
SCRPTGBL.TF.Data.corTF_Bloc2 = corTF_Bloc2;
SCRPTGBL.TF.Data.TF_Grad = TF_Grad;
SCRPTGBL.TF.Data.TF_B01 = TF_B01;
SCRPTGBL.TF.Data.TF_B02 = TF_B02;

SCRPTGBL.TextBox = ExpDisp;
SCRPTGBL.Figs = '';
SCRPTGBL.Data = [];

%---------------------------------------------
% Display
%---------------------------------------------
SCRPTGBL.RWSUI.LocalOutput(1).label = 'Loc1 (cm)';
SCRPTGBL.RWSUI.LocalOutput(1).value = num2str(Loc1*100);
SCRPTGBL.RWSUI.LocalOutput(1).label = 'Loc2 (cm)';
SCRPTGBL.RWSUI.LocalOutput(1).value = num2str(Loc2*100);
SCRPTGBL.RWSUI.LocalOutput(1).label = 'Sep (cm)';
SCRPTGBL.RWSUI.LocalOutput(1).value = num2str(Sep*100);
SCRPTGBL.RWSUI.LocalOutput(1).label = 'BG_Grad (uT/m)';
SCRPTGBL.RWSUI.LocalOutput(1).value = num2str(meanBGGrad*1000);
SCRPTGBL.RWSUI.LocalOutput(1).label = 'BG_B0 (uT)';
SCRPTGBL.RWSUI.LocalOutput(1).value = num2str(meanBGB0*1000);

%--------------------------------------------
% Output
%--------------------------------------------
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = path;
SCRPTGBL.RWSUI.SaveVariables = {Image};
SCRPTGBL.RWSUI.SaveVariableNames = {'Image'};


