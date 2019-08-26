%==================================================
% 
%==================================================

function [IMPMETH,err] = ImpMeth_TpiOptionFull_v1b_Func(IMPMETH,INPUT)

func = str2func('ImpMeth_Tpi_v1b_Func');           
[IMPMETH,err] = func(IMPMETH,INPUT);

