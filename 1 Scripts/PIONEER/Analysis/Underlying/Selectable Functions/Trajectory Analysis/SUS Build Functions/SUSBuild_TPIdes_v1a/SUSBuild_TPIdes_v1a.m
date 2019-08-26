%===========================================
% (v1a)
%    
%===========================================

function [SCRPTipt,SUS,err] = SUSBuild_TPIdes_v1a(SCRPTipt,SUSipt)

Status2('done','SUS Build Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
SUS.method = SUSipt.Func;
SUS.offres = str2double(SUSipt.('OffRes')); 

Status2('done','',2);
Status2('done','',3);
