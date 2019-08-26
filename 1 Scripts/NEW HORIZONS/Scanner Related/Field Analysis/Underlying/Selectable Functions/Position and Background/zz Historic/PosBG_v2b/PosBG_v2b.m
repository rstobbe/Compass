%====================================================
% (v2b) 
%   - update for RWS_BA
%====================================================

function [SCRPTipt,SCRPTGBL,err] = PosBG_v2b(SCRPTipt,SCRPTGBL)

CallingLabel = 'PosBgrndfunc';
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
    err.msg = '(Re) Select PosBgrnd files';
    ErrDisp(err);
    return
end
if not(isfield(SCRPTGBL.([CallingLabel,'_Data']),'File_NoGrad1_Data')) || not(isfield(SCRPTGBL.([CallingLabel,'_Data']),'File_NoGrad2_Data'))
    err.flag = 1;
    err.msg = '(Re) Select ''NoGrad'' files';
    ErrDisp(err);
    return
end
if not(isfield(SCRPTGBL.([CallingLabel,'_Data']),'File_PosLoc1_Data')) || not(isfield(SCRPTGBL.([CallingLabel,'_Data']),'File_PosLoc2_Data'))
    err.flag = 1;
    err.msg = '(Re) Select ''PosLoc'' files';
    ErrDisp(err);
    return
end
if not(isfield(SCRPTGBL.CurrentTree,'System'))
    err.flag = 1;
    err.msg = 'Calling script must facilitate ''System'' selection';
    ErrDisp(err);
    return
end

Sys = SCRPTGBL.CurrentTree.System;
FilePosLoc1 = SCRPTGBL.([CallingLabel,'_Data']).File_PosLoc1_Data.path;
FilePosLoc2 = SCRPTGBL.([CallingLabel,'_Data']).File_PosLoc2_Data.path;
FileNoGrad1 = SCRPTGBL.([CallingLabel,'_Data']).File_NoGrad1_Data.path;
FileNoGrad2 = SCRPTGBL.([CallingLabel,'_Data']).File_NoGrad2_Data.path;
plstart = str2double(SCRPTGBL.CurrentTree.(CallingLabel).PLstart);
plstop = str2double(SCRPTGBL.CurrentTree.(CallingLabel).PLstop);
bgstart = str2double(SCRPTGBL.CurrentTree.(CallingLabel).BGstart);
bgstop = str2double(SCRPTGBL.CurrentTree.(CallingLabel).BGstop);
smthwin = str2double(SCRPTGBL.CurrentTree.(CallingLabel).SmoothWinBG);

%-------------------------------------
% Load PosLoc Data
%-------------------------------------
ExpDisp = [];
[PL_Fid1,PL_Fid2,PL_expT,PL_Params,ExpDisp,errorflag,error] = Load_2LocExperiment_v3a(FilePosLoc1,FilePosLoc2,'PosLoc',Sys,'',ExpDisp);
if errorflag == 1
    err.flag = 1;
    err.msg = error;
    return
end
[PL_PH1,PL_PH2] = PhaseEvolution_v2a(PL_Fid1,PL_Fid2);
[PL_Bloc1,PL_Bloc2] = FieldEvolution_v2a(PL_PH1,PL_PH2,PL_expT);
PL_ind1 = find(PL_expT>plstart,1,'first');
PL_ind2 = find(PL_expT>plstop,1,'first'); 

%-------------------------------------
% Load NoGradient Data
%-------------------------------------
[BG_Fid1,BG_Fid2,BG_expT,BG_Params,ExpDisp,errorflag,error] = Load_2LocExperiment_v3a(FileNoGrad1,FileNoGrad2,'BackGrad',Sys,'',ExpDisp);
if errorflag == 1
    err.flag = 1;
    err.msg = error;
    return
end
[BG_PH1,BG_PH2] = PhaseEvolution_v2a(BG_Fid1,BG_Fid2);
[BG_Bloc1,BG_Bloc2] = FieldEvolution_v2a(BG_PH1,BG_PH2,BG_expT);  
BG_ind1 = find(BG_expT>bgstart,1,'first');
BG_ind2 = find(BG_expT>bgstop,1,'first');

meanBGGrad = 0;
for w = 1:2
    %-------------------------------------
    % Deternime Position
    %-------------------------------------
    glocval = PL_Params.gval + meanBGGrad;
    Loc1 = mean(PL_Bloc1(PL_ind1:PL_ind2))/glocval;
    Loc2 = mean(PL_Bloc2(PL_ind1:PL_ind2))/glocval;
    Sep = Loc2 - Loc1;

    %-------------------------------------
    % Determine Background Fields
    %-------------------------------------    
    BG_Grad = (BG_Bloc2 - BG_Bloc1)/Sep;
    BG_B01 = BG_Bloc1 - BG_Grad*Loc1;
    BG_B02 = BG_Bloc2 - BG_Grad*Loc2;        
    meanBGGrad = mean(BG_Grad(BG_ind1:BG_ind2));
    meanBGB0 = mean([BG_B01(BG_ind1:BG_ind2) BG_B02(BG_ind1:BG_ind2)]);    
end

PL_Grad = (PL_Bloc2 - PL_Bloc1)/Sep;
PL_B01 = PL_Bloc1 - PL_Grad*Loc1;         
PL_B02 = PL_Bloc2 - PL_Grad*Loc2;

%-------------------------------------
% Smooth BG fields
%-------------------------------------
BG_smthBloc1 = smooth(BG_Bloc1,smthwin,'moving');
BG_smthBloc2 = smooth(BG_Bloc2,smthwin,'moving'); 

%---------------------------------------------
% Returned
%---------------------------------------------
PosBG.ExpDisp = ExpDisp;
PosBG.Loc1 = Loc1;
PosBG.Loc2 = Loc2;
PosBG.Sep = Sep;
PosBG.meanBGGrad = meanBGGrad;
PosBG.meanBGB0 = meanBGB0;
PosBG.BG_expT = BG_expT;
PosBG.BG_smthBloc1 = BG_smthBloc1;
PosBG.BG_smthBloc2 = BG_smthBloc2; 
PosBG.Data.PL_Params = PL_Params;
PosBG.Data.BG_Params = BG_Params;
PosBG.Data.PL_expT = PL_expT;
PosBG.Data.BG_expT = BG_expT;
PosBG.Data.PL_Fid1 = PL_Fid1;
PosBG.Data.PL_Fid2 = PL_Fid2;
PosBG.Data.BG_Fid1 = BG_Fid1;
PosBG.Data.BG_Fid2 = BG_Fid2;
PosBG.Data.PL_PH1 = PL_PH1;
PosBG.Data.PL_PH2 = PL_PH2;
PosBG.Data.BG_PH1 = BG_PH1;
PosBG.Data.BG_PH2 = BG_PH2;
PosBG.Data.PL_Bloc1 = PL_Bloc1;
PosBG.Data.PL_Bloc2 = PL_Bloc2;
PosBG.Data.BG_Bloc1 = BG_Bloc1;
PosBG.Data.BG_Bloc2 = BG_Bloc2;
PosBG.Data.PL_Grad = PL_Grad;
PosBG.Data.PL_B01 = PL_B01;
PosBG.Data.PL_B02 = PL_B02;
PosBG.Data.BG_Grad = BG_Grad;
PosBG.Data.BG_B01 = BG_B01;
PosBG.Data.BG_B02 = BG_B02;

SCRPTGBL.PosBG = PosBG;






