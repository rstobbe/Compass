%=====================================================
% (v1c)
%       - add min value
%=====================================================

function [SCRPTipt,IMSCL,err] = ImageContrastRelMag_v1c(SCRPTipt,IMSCLipt)

Status2('busy','Image Scale',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
IMSCL.method = IMSCLipt.Func;
IMSCL.maxrelval = str2double(IMSCLipt.('MaxRelVal'));
IMSCL.minrelval = str2double(IMSCLipt.('MinRelVal'));
IMSCL.colour = IMSCLipt.('Colour');








