%=====================================================
% 
%=====================================================

function [SCALE,err] = ImScaleVarian_v1a_Func(SCALE,INPUT)

Status2('busy','Scale',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
%--
subsamp = 1.25;                     % to match old;
scale = (subsamp^3)/10000; 
%--

SCALE.Im = scale*INPUT.Im;


Status2('done','',2);
Status2('done','',3);






