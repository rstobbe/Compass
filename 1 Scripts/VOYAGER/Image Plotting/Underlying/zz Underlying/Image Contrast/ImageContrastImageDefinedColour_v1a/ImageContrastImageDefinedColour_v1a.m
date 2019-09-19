%=====================================================
% (v1a)
%       
%=====================================================

function [SCRPTipt,IMSCL,err] = ImageContrastImageDefinedColour_v1a(SCRPTipt,IMSCLipt)

Status2('busy','Image Contrast',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
IMSCL.method = IMSCLipt.Func;









