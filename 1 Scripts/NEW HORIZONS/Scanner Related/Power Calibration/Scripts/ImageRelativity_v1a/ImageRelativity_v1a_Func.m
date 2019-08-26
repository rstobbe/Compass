%====================================================
%  
%====================================================

function [PWRCAL,err] = ImageRelativity_v1a_Func(PWRCAL,INPUT)

Status('busy','Calibrate Power');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMG = INPUT.IMG;
clear INPUT;

Im1 = IMG{1}.Im;
Im1(Im1 < 0.1) = 1000;
Image = IMG{2}.Im ./ Im1;

%---------------------------------------------
% Return
%---------------------------------------------
PWRCAL.Im = Image;
PWRCAL.ImSz = IMG{1}.ImSz;


Status('done','');
Status2('done','',2);
Status2('done','',3);

