%====================================================
% (v1a)
%  
%====================================================

function [SCRPTipt,SCRPTGBL,err] = MultiRFPostGrad_v1a(SCRPTipt,SCRPTGBL)

CallingLabel = 'TransGradfunc';
err.flag = 0;
err.msg = '';

if not(isfield(SCRPTGBL.CurrentTree,CallingLabel))
    err.flag = 1;
    err.msg = ['Calling label must be: ''',CallingLabel,''''];
    ErrDisp(err);
    return
end
if not(isfield(SCRPTGBL,[CallingLabel,'_Data']))
    err.flag = 1;
    err.msg = '(Re) Select TransGrad files';
    ErrDisp(err);
    return
end
if not(isfield(SCRPTGBL.([CallingLabel,'_Data']),'File_Grad1_Data')) || not(isfield(SCRPTGBL.([CallingLabel,'_Data']),'File_Grad2_Data'))
    err.flag = 1;
    err.msg = '(Re) Select ''Grad'' files';
    ErrDisp(err);
    return
end
if not(isfield(SCRPTGBL.CurrentTree,'System'))
    err.flag = 1;
    err.msg = 'Calling script must facilitate ''System'' selection';
    ErrDisp(err);
    return
end
if not(isfield(SCRPTGBL.CurrentTree,'System'))
    err.flag = 1;
    err.msg = 'Calling script must facilitate ''System'' selection';
    ErrDisp(err);
    return
end
if not(isfield(SCRPTGBL,'PosBG'))
    err.flag = 1;
    err.msg = 'Structure ''PosBG'' was not created';
    ErrDisp(err);
    return
end 

Sys = SCRPTGBL.CurrentTree.System;
FileGrad1 = SCRPTGBL.([CallingLabel,'_Data']).File_Grad1_Data.path;
FileGrad2 = SCRPTGBL.([CallingLabel,'_Data']).File_Grad2_Data.path;
Gstart = str2double(SCRPTGBL.CurrentTree.(CallingLabel).Gstart);
Gstop = str2double(SCRPTGBL.CurrentTree.(CallingLabel).Gstop);

%-------------------------------------
% Determine Transient Fields
%-------------------------------------
ExpDisp = [];
[TF_Fid1,TF_Fid2,TF_expT,TF_Params,ExpDisp,errorflag,error] = Load_2LocExperiment_v3a(FileGrad1,FileGrad2,'Transient',Sys,'PostGradEddyMulti_v1a',ExpDisp);
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
ind1 = find(TF_expT>Gstart,1,'first');
ind2 = find(TF_expT>Gstop,1,'first');
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
        TF_Grad(n,:,m) = (corTF_Bloc2(n,:,m) - corTF_Bloc1(n,:,m))/SCRPTGBL.PosBG.Sep;
        TF_B01(n,:,m) = corTF_Bloc1(n,:,m) - TF_Grad(n,:,m)*SCRPTGBL.PosBG.Loc1;         % TF_B01 and TF_B02 should be identical
        TF_B02(n,:,m) = corTF_Bloc2(n,:,m) - TF_Grad(n,:,m)*SCRPTGBL.PosBG.Loc2;
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
TF_Params.gofftime2 = TF_Params.gofftime + TF_Params.falltime/2000000 + (Gstop+Gstart)/2000;

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
% Returned
%-------------------------------------
TF.ExpDisp = ExpDisp;
TF.gval = TF_Params.gval;
TF.Time = gofftime*1000;
TF.Geddy = Geddy;
TF.B0eddy = B0eddy;
TF.Path = FileGrad1;
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

SCRPTGBL.TF = TF;


