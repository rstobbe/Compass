%=====================================================
% (v1a)
%      
%=====================================================

function [SCRPTipt,GBLD,err] = GBuild_TempRotate_v1a(SCRPTipt,GBLDipt)

Status2('busy','Build Gradients from Templates Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
GBLD.method = GBLDipt.Func;

Status2('done','',2);
Status2('done','',3);