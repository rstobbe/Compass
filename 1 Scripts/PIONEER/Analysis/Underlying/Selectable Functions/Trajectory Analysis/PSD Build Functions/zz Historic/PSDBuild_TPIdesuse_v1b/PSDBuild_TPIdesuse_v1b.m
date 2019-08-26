%===========================================
% (v1b)
%       - capability to select tfdiam of design
%===========================================

function [SCRPTipt,PSD,err] = PSDBuild_TPIdesuse_v1b(SCRPTipt,PSDipt)

Status2('done','PSD Build Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
PSD.method = PSDipt.Func;

Status2('done','',2);
Status2('done','',3);
