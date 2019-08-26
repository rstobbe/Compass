%=========================================================
% 
%=========================================================

function [BRK,err] = CGBreakManual_v1a_Func(BRK,INPUT)

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Test
%---------------------------------------------
button = questdlg('Continue?','CG Reconstruction','Yes');
if not(strcmp(button,'Yes'))
    BRK.end = 1;
else
    BRK.end = 0;
end






