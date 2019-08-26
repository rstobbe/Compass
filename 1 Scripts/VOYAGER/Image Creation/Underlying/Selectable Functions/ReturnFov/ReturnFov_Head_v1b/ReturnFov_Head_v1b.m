%=====================================================
% (v1b)
%   - go bit bigger on IO
%=====================================================

function [SCRPTipt,RFOV,err] = ReturnFov_Head_v1b(SCRPTipt,RFOVipt)

Status2('busy','Return FoV',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
RFOV.method = RFOVipt.Func;

Status2('done','',2);
Status2('done','',3);









