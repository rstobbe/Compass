%====================================================
% (v1b)filtering back in
%====================================================

function [SCRPTipt,SCRPTGBL,err] = PostGradEddySingleJoined_v1b(SCRPTipt,SCRPTGBL)

SCRPTGBL.TextBox = '';
SCRPTGBL.Figs = [];
SCRPTGBL.Data = [];

Sys = SCRPTipt(strcmp('System',{SCRPTipt.labelstr})).entrystr;
if iscell(Sys)
    Sys = SCRPTipt(strcmp('System',{SCRPTipt.labelstr})).entrystr{SCRPTipt(strcmp('System',{SCRPTipt.labelstr})).entryvalue};
end
FileGrad1 = SCRPTipt(strcmp('File_Grad1',{SCRPTipt.labelstr})).runfuncoutput{1};
FileGrad2 = SCRPTipt(strcmp('File_Grad2',{SCRPTipt.labelstr})).runfuncoutput{1};
B0cal = str2double(SCRPTipt(strcmp('B0 (1% -> uTpG)',{SCRPTipt.labelstr})).entrystr);
gcal = str2double(SCRPTipt(strcmp('G (act% -> V%)',{SCRPTipt.labelstr})).entrystr);
psbgfunc = SCRPTipt(strcmp('Pos / Bgrnd',{SCRPTipt.labelstr})).entrystr;
filtGfunc = SCRPTipt(strcmp('Filt_Grad',{SCRPTipt.labelstr})).entrystr;
filtB0func = SCRPTipt(strcmp('Filt_B0',{SCRPTipt.labelstr})).entrystr;
gstart = str2double(SCRPTipt(strcmp('Gstart (ms)',{SCRPTipt.labelstr})).entrystr);
gstop = str2double(SCRPTipt(strcmp('Gstop (ms)',{SCRPTipt.labelstr})).entrystr);

%-----------------------------------------------------
% Determine Probe Displacement and BackGround Fields
%-----------------------------------------------------
func = str2func(psbgfunc);
[SCRPTipt,SCRPTGBL,err] = func(SCRPTipt,SCRPTGBL);
ExpDisp = SCRPTGBL.PosBG.ExpDisp;
Loc1 = SCRPTGBL.PosBG.Loc1;
Loc2 = SCRPTGBL.PosBG.Loc2;
Sep = SCRPTGBL.PosBG.Sep;

%-------------------------------------
% Determine Transient Fields
%-------------------------------------
[TF_Fid1,TF_Fid2,TF_expT,TF_Params,ExpDisp,errorflag,error] = Load_2LocExperiment_v3a(FileGrad1,FileGrad2,'Transient',Sys,'PostGradEddySingle_v1a',ExpDisp);
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

%-------------------------------------
% Subtract background and separate
%-------------------------------------
[nexp,~] = size(TF_Fid1);
corTF_Bloc1 = zeros(size(TF_Fid1));
corTF_Bloc2 = zeros(size(TF_Fid1));
TF_Grad = zeros(size(TF_Fid1));
TF_B01 = zeros(size(TF_Fid1));
TF_B02 = zeros(size(TF_Fid1));
for n = 1:nexp
    corTF_Bloc1(n,:) = TF_Bloc1(n,:) - BG_smthBloc1;
    corTF_Bloc2(n,:) = TF_Bloc2(n,:) - BG_smthBloc2;
    TF_Grad(n,:) = (corTF_Bloc2(n,:) - corTF_Bloc1(n,:))/Sep;
    TF_B01(n,:) = corTF_Bloc1(n,:) - TF_Grad(n,:)*Loc1;         % TF_B01 and TF_B02 should be identical
    TF_B02(n,:) = corTF_Bloc2(n,:) - TF_Grad(n,:)*Loc2;
end

%-------------------------------------
% Join
%-------------------------------------
ind1 = find(TF_expT>gstart,1,'first');
ind2 = find(TF_expT>gstop,1,'first');
TF_B0_Joined = NaN*zeros(nexp,1000*TF_Params.gofftime(nexp)/TF_Params.dwell+ind2);
TF_Grad_Joined = NaN*zeros(size(TF_B0_Joined));
for n = 1:nexp 
    start = 1000*TF_Params.gofftime(n)/TF_Params.dwell + ind1;
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
% Filter
%-------------------------------------
ind = find(isnan(TF_Grad_Ave),1,'last');
TF_Grad_Ave2 = TF_Grad_Ave(ind+1:length(TF_Grad_Ave));
func = str2func(filtGfunc);
[Gfilt,SCRPTipt] = func(TF_Grad_Ave2,TF_Params,SCRPTipt);
TF_Grad_Ave_Filt = [zeros(1,ind) Gfilt];
figure(1); hold on;
plot(TF_expT_Joined,TF_Grad_Ave*1000,'b','linewidth',2)
plot(TF_expT_Joined,TF_Grad_Ave_Filt*1000,'r','linewidth',2)
xlabel('(ms)'); ylabel('Gradient Evolution (uT/m)'); xlim([0 max(TF_expT_Joined)]); title('Transient Field (Gradient)');

TF_B0_Ave2 = TF_B0_Ave(ind+1:length(TF_B0_Ave));
func = str2func(filtB0func);
[Gfilt,SCRPTipt] = func(TF_B0_Ave2,TF_Params,SCRPTipt);
TF_B0_Ave_Filt = [zeros(1,ind) Gfilt];
figure(2); hold on;
plot(TF_expT_Joined,TF_B0_Ave*1000,'b','linewidth',2)
plot(TF_expT_Joined,TF_B0_Ave_Filt*1000,'r','linewidth',2)
xlabel('(ms)'); ylabel('B0 Evolution (uT)'); xlim([0 max(TF_expT_Joined)]); title('Transient Field (B0)');

%-------------------------------------
% Return
%-------------------------------------
SCRPTGBL.B0cal = B0cal;
SCRPTGBL.gcal = gcal;
SCRPTGBL.gval = TF_Params.gval;
SCRPTGBL.Time = TF_expT_Joined;
SCRPTGBL.Geddy = TF_Grad_Ave_Filt;
SCRPTGBL.B0eddy = TF_B0_Ave_Filt;

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
SCRPTGBL.TF.Data.TF_expT_Joined = TF_expT_Joined;
SCRPTGBL.TF.Data.TF_Grad_Joined = TF_Grad_Joined;
SCRPTGBL.TF.Data.TF_B0_Joined = TF_B0_Joined;

SCRPTGBL.TextBox = ExpDisp;
SCRPTGBL.Figs = '';
SCRPTGBL.Data = [];
