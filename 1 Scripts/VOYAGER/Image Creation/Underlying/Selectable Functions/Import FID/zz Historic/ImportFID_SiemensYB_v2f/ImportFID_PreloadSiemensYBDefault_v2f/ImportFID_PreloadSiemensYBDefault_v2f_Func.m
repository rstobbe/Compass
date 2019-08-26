%==================================================
% 
%==================================================

function [FID,err] = ImportFID_SiemensYBDefault_v2f_Func(FID,INPUT)

func = str2func('ImportFID_SiemensYB_v2f_Func');           
[FID,err] = func(FID,INPUT);

