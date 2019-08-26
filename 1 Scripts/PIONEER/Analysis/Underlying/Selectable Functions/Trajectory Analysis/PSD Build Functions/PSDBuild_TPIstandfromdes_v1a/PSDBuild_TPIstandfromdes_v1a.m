%===========================================
% (v1a)
%    
%===========================================

function [SCRPTipt,PSD,err] = PSDBuild_TPIdesrebuild_v1a(SCRPTipt,PSDipt)

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
