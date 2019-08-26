%=====================================================
% (v1a)
%  
%=====================================================

function [SCRPTipt,IMSCL,err] = ImageContrastNaConcMap_v1a(SCRPTipt,IMSCLipt)

Status2('busy','Image Scale',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
IMSCL.method = IMSCLipt.Func;
IMSCL.scale = IMSCLipt.('Scale');

Status2('done','',3);







