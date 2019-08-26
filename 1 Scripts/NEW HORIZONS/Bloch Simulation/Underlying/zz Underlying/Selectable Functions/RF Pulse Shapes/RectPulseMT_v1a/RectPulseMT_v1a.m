%=========================================================
% (v1a) 
%       
%=========================================================

function [SCRPTipt,MTPLS,err] = RectPulseMT_v1a(SCRPTipt,MTPLSipt)

Status2('done','Rectangular MT pulse params',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
MTPLS.method = MTPLSipt.Func; 
MTPLS.w1 = str2double(MTPLSipt.('w1'));
MTPLS.deltaf = str2double(MTPLSipt.('deltaf'));

Status2('done','',2);
Status2('done','',3);
