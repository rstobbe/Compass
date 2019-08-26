%=====================================================
%
%=====================================================

function [IMSCL,err] = ImScale_Absolute_v1b_Func(IMSCL,INPUT)

Status2('busy','Image Scale',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return
%---------------------------------------------
IMSCL.Image = INPUT.Image;

Status2('done','',2);
Status2('done','',3);



