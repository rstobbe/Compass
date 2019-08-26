%=====================================================
% (v1b)
%  
%=====================================================

function [SCRPTipt,IMSCL,err] = ImScale_RelFullValue_v1b(SCRPTipt,IMSCLipt)

Status2('busy','Image Scale',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
IMSCL.method = IMSCLipt.Func;
IMSCL.contrast = str2double(IMSCLipt.('Contrast'));

Status2('done','',2);
Status2('done','',3);







