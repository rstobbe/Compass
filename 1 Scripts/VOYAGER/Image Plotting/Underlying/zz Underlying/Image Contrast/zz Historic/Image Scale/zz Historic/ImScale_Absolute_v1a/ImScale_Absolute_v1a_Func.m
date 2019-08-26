%=====================================================
%
%=====================================================

function [IMSCL,err] = ImScale_Absolute_v1a_Func(IMSCL,INPUT)

Status2('busy','Image Scale',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
Image = INPUT.Image;
clear INPUT;

%---------------------------------------------
% Scale Full Value
%---------------------------------------------
maxval = IMSCL.absolutemax;
Image = IMSCL.fullintenseval*Image/maxval;

%---------------------------------------------
% Return
%---------------------------------------------
IMSCL.Image = Image;
IMSCL.minval = IMSCL.fullintenseval*IMSCL.absolutemin/IMSCL.absolutemax;
IMSCL.maxval = IMSCL.fullintenseval;

Status2('done','',2);
Status2('done','',3);



