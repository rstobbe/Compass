%=====================================================
% (v1a)
%  
%=====================================================

function [SCRPTipt,IMSCL,err] = ImScale_Absolute_v1a(SCRPTipt,IMSCLipt)

Status2('busy','Image Scale',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
IMSCL.method = IMSCLipt.Func;
IMSCL.absolutemin = str2double(IMSCLipt.('AbsoluteMin'));
IMSCL.absolutemax = str2double(IMSCLipt.('AbsoluteMax'));
IMSCL.fullintenseval = str2double(IMSCLipt.('FullIntenseVal'));

Status2('done','',2);
Status2('done','',3);







