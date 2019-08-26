%=====================================================
% (v1a)
%  
%=====================================================

function [SCRPTipt,IMSCL,err] = ImageContrastGeneral_v1a(SCRPTipt,IMSCLipt)

Status2('busy','Image Scale',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
IMSCL.method = IMSCLipt.Func;
IMSCL.scale = IMSCLipt.('Scale');
IMSCL.type = IMSCLipt.('Type');

Status2('done','',2);
Status2('done','',3);







