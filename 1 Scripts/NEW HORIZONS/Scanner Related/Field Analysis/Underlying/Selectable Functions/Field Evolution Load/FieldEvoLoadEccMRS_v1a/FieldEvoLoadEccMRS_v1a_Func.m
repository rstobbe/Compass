%====================================================
%           
%====================================================

function [FEVOL,err] = FieldEvoLoadEccMRS_v1a_Func(FEVOL,INPUT)

Status2('busy','Load MRS Data',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
clear INPUT

%---------------------------------------------
% Load
%---------------------------------------------
Sys = 'SMIS';
[PL_Fid1,PL_Fid2,PL_Params,PL_ExpDisp,err] = Load_2LocExperiment_v4b(FEVOL.File_PosLoc1,FEVOL.File_PosLoc2,'PosLoc_v1a',Sys);
if err.flag
    return
end
[BG_Fid1,BG_Fid2,BG_Params,BG_ExpDisp,err] = Load_2LocExperiment_v4b(FEVOL.File_NoGrad1,FEVOL.File_NoGrad2,'NoGrad_v1a',Sys);
if err.flag
    return
end
[TF_Fid1,TF_Fid2,TF_Params,TF_ExpDisp,err] = Load_2LocExperiment_v4b(FEVOL.File_Grad1,FEVOL.File_Grad2,'MultiRFPostGrad_v1a',Sys);
if err.flag
    return
end

%---------------------------------------------
% Return
%---------------------------------------------
ExpDisp.PL_ExpDisp = PL_ExpDisp;
ExpDisp.BG_ExpDisp = BG_ExpDisp;
ExpDisp.TF_ExpDisp = TF_ExpDisp;
FEVOL.ExpDisp = ExpDisp;
FEVOL.BG_Fid1 = BG_Fid1;
FEVOL.BG_Fid2 = BG_Fid2;
FEVOL.BG_Params = BG_Params;
FEVOL.PL_Fid1 = PL_Fid1;
FEVOL.PL_Fid2 = PL_Fid2;
FEVOL.PL_Params = PL_Params;
FEVOL.TF_Fid1 = TF_Fid1;
FEVOL.TF_Fid2 = TF_Fid2;
FEVOL.TF_Params = TF_Params;

Status2('done','',2);
Status2('done','',3);
Status2('done','',2);
Status2('done','',3);
