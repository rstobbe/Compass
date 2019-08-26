%====================================================
% (v2a) 
%   - Removed 'visualization' stuff
%   - retain info for later plotting...
%   - ditch 'Input'
%====================================================

function [SCRPTipt,SCRPTGBL,err] = PosBG_v2a(SCRPTipt,SCRPTGBL)

err.flag = 0;

Sys = SCRPTipt(strcmp('System',{SCRPTipt.labelstr})).entrystr;
if iscell(Sys)
    Sys = SCRPTipt(strcmp('System',{SCRPTipt.labelstr})).entrystr{SCRPTipt(strcmp('System',{SCRPTipt.labelstr})).entryvalue};
end
FilePosLoc1 = SCRPTipt(strcmp('File_PosLoc1',{SCRPTipt.labelstr})).runfuncoutput{1};
FilePosLoc2 = SCRPTipt(strcmp('File_PosLoc2',{SCRPTipt.labelstr})).runfuncoutput{1};
FileNoGrad1 = SCRPTipt(strcmp('File_NoGrad1',{SCRPTipt.labelstr})).runfuncoutput{1};
FileNoGrad2 = SCRPTipt(strcmp('File_NoGrad2',{SCRPTipt.labelstr})).runfuncoutput{1};
plstart = str2double(SCRPTipt(strcmp('PLstart (ms)',{SCRPTipt.labelstr})).entrystr);
plstop = str2double(SCRPTipt(strcmp('PLstop (ms)',{SCRPTipt.labelstr})).entrystr);
bgstart = str2double(SCRPTipt(strcmp('BGstart (ms)',{SCRPTipt.labelstr})).entrystr);
bgstop = str2double(SCRPTipt(strcmp('BGstop (ms)',{SCRPTipt.labelstr})).entrystr);
smthwin = str2double(SCRPTipt(strcmp('SmoothWinBG',{SCRPTipt.labelstr})).entrystr);

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
SCRPTGBL.PosBG.BG_expT = BG_expT;
SCRPTGBL.PosBG.BG_smthBloc1 = smooth(BG_Bloc1,smthwin,'moving');
SCRPTGBL.PosBG.BG_smthBloc2 = smooth(BG_Bloc2,smthwin,'moving'); 

SCRPTGBL.PosBG.ExpDisp = ExpDisp;
SCRPTGBL.PosBG.Loc1 = Loc1;
SCRPTGBL.PosBG.Loc2 = Loc2;
SCRPTGBL.PosBG.Sep = Sep;
SCRPTGBL.PosBG.meanBGGrad = meanBGGrad;
SCRPTGBL.PosBG.meanBGB0 = meanBGB0;

SCRPTGBL.PosBG.Data.PL_expT = PL_expT;
SCRPTGBL.PosBG.Data.BG_expT = BG_expT;
SCRPTGBL.PosBG.Data.PL_Params = PL_Params;
SCRPTGBL.PosBG.Data.BG_Params = BG_Params;
SCRPTGBL.PosBG.Data.PL_Fid1 = PL_Fid1;
SCRPTGBL.PosBG.Data.PL_Fid2 = PL_Fid2;
SCRPTGBL.PosBG.Data.BG_Fid1 = BG_Fid1;
SCRPTGBL.PosBG.Data.BG_Fid2 = BG_Fid2;
SCRPTGBL.PosBG.Data.PL_PH1 = PL_PH1;
SCRPTGBL.PosBG.Data.PL_PH2 = PL_PH2;
SCRPTGBL.PosBG.Data.BG_PH1 = BG_PH1;
SCRPTGBL.PosBG.Data.BG_PH2 = BG_PH2;
SCRPTGBL.PosBG.Data.PL_Bloc1 = PL_Bloc1;
SCRPTGBL.PosBG.Data.PL_Bloc2 = PL_Bloc2;
SCRPTGBL.PosBG.Data.BG_Bloc1 = BG_Bloc1;
SCRPTGBL.PosBG.Data.BG_Bloc2 = BG_Bloc2;
SCRPTGBL.PosBG.Data.PL_Grad = PL_Grad;
SCRPTGBL.PosBG.Data.PL_B01 = PL_B01;
SCRPTGBL.PosBG.Data.PL_B02 = PL_B02;
SCRPTGBL.PosBG.Data.BG_Grad = BG_Grad;
SCRPTGBL.PosBG.Data.BG_B01 = BG_B01;
SCRPTGBL.PosBG.Data.BG_B02 = BG_B02;

[SCRPTipt] = AddToPanelOutput(SCRPTipt,'Loc1 (cm)','0output',Loc1*100,'0text');
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'Loc2 (cm)','0output',Loc2*100,'0text');
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'Sep (cm)','0output',Sep*100,'0text');
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'BG_Grad (uT/m)','0output',meanBGGrad*1000,'0text');
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'BG_B0 (uT)','0output',meanBGB0*1000,'0text');

