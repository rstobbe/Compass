%=====================================================
% (v1a)
%  
%=====================================================

function [SCRPTipt,IMSCL,err] = ImScale_Absolute_v1b(SCRPTipt,IMSCLipt)

Status2('busy','Image Scale',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
IMSCL.method = IMSCLipt.Func;
IMSCL.minval = str2double(IMSCLipt.('Min'));
IMSCL.maxval = str2double(IMSCLipt.('Max'));

Status2('done','',2);
Status2('done','',3);







