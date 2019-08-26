%====================================================
%           
%====================================================

function [FEVOL,err] = FieldEvoLoadBasicVarian_v1a_Func(FEVOL,INPUT)

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
Sys = 'Varian';
[PL_Fid1,PL_Fid2,PL_Params,PL_ExpDisp,err] = Load_2LocExperiment_v4b(FEVOL.File_PosLoc1,FEVOL.File_PosLoc2,'PosLoc_v1a',Sys);
if err.flag
    return
end
[BG_Fid1,BG_Fid2,BG_Params,BG_ExpDisp,err] = Load_2LocExperiment_v4b(FEVOL.File_NoGrad1,FEVOL.File_NoGrad2,'NoGrad_v1a',Sys);
if err.flag
    return
end

%---------------------------------------------
% Return
%---------------------------------------------
FEVOL.BG_Fid1 = BG_Fid1;
FEVOL.BG_Fid2 = BG_Fid2;
FEVOL.BG_Params = BG_Params;
FEVOL.PL_Fid1 = PL_Fid1;
FEVOL.PL_Fid2 = PL_Fid2;
FEVOL.PL_Params = PL_Params;

Status2('done','',2);
Status2('done','',3);
