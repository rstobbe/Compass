%=====================================================
% (v1c)
%       
%=====================================================

function [SCRPTipt,IMSCL,err] = ImageContrastValMag_v1c(SCRPTipt,IMSCLipt)

Status2('busy','Image Scale',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
IMSCL.method = IMSCLipt.Func;
IMSCL.maxval = str2double(IMSCLipt.('MaxValue'));
IMSCL.minval = str2double(IMSCLipt.('MinValue'));









