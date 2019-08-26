%=========================================================
% (v1a) 
%       
%=========================================================

function [SCRPTipt,BLOCHEX,err] = Excite_MonoExp_v1a(SCRPTipt,BLOCHEXipt)

Status2('done','Bloch Excitation Function',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
BLOCHEX.method = BLOCHEXipt.Func; 
BLOCHEX.segdur = str2double(BLOCHEXipt.('SegDur'));

Status2('done','',2);
Status2('done','',3);
