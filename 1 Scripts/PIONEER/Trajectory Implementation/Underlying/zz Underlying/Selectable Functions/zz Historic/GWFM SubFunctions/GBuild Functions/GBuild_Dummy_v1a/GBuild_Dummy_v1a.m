%=====================================================
% (v1a)
%      
%=====================================================

function [SCRPTipt,GBLD,err] = GBuild_Dummy_v1a(SCRPTipt,GBLDipt)

Status2('busy','Build Gradients',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
GBLD.method = GBLDipt.Func;

Status2('done','',2);
Status2('done','',3);