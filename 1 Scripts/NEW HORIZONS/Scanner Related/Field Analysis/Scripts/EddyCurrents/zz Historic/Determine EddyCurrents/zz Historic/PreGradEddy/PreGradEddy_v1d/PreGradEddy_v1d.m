%====================================================
% (v1d)
%    - gcal / output update
%====================================================

function [SCRPTipt,SCRPTGBL,err] = PreGradEddy_v1d(SCRPTipt,SCRPTGBL)

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
[TF_Fid1,TF_Fid2,TF_expT,TF_Params,ExpDisp,errorflag,error] = Load_2LocExperiment_v3a(FileGrad1,FileGrad2,'During',Sys,'PreGradEddy_v1a',ExpDisp);
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
corTF_Bloc1 = TF_Bloc1 - BG_smthBloc1;
corTF_Bloc2 = TF_Bloc2 - BG_smthBloc2;
TF_Grad = (corTF_Bloc2 - corTF_Bloc1)/Sep;
TF_B01 = corTF_Bloc1 - TF_Grad*Loc1;         % TF_B01 and TF_B02 should be identical
TF_B02 = corTF_Bloc2 - TF_Grad*Loc2;

%-------------------------------------
% Return
%-------------------------------------
SCRPTGBL.B0cal = B0cal;
SCRPTGBL.gcal = gcal;
SCRPTGBL.gval = TF_Params.gval;
SCRPTGBL.Time = TF_expT;
SCRPTGBL.Geddy = TF_Grad;
SCRPTGBL.B0eddy = TF_B01;

SCRPTGBL.TF.Data.TF_expT = TF_expT;
SCRPTGBL.TF.Data.TF_Params = TF_Params;
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


