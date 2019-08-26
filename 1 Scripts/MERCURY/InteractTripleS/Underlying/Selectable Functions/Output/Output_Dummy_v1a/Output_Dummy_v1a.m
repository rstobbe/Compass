%=====================================================
% (v1a)
%      
%=====================================================

function [SCRPTipt,OUT,err] = Output_Dummy_v1a(SCRPTipt,OUTipt)

Status2('busy','No Output',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
OUT.method = OUTipt.Func;

Status2('done','',2);
Status2('done','',3);