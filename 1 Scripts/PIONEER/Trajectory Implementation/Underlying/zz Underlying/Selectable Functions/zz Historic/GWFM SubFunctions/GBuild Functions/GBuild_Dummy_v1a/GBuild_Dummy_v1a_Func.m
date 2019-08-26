%=====================================================
% (v1a)
%      
%=====================================================

function [GBLD,err] = GBuild_Dummy_v1a_Func(GBLD,INPUT)

Status2('busy','Dummy Function',3);

err.flag = 0;
err.msg = '';

GBLD.Gout = INPUT.G0;

Status2('done','',3);