%=========================================================
% (v1a) 
%       
%=========================================================

function [SCRPTipt,BLOCH,err] = ModifiedCoupledBloch_v1a(SCRPTipt,BLOCHipt)

Status2('done','Get Modified Coupled Bloch Equation DE Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
BLOCH.method = BLOCHipt.Func; 

Status2('done','',2);
Status2('done','',3);
