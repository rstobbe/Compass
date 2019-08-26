%=====================================================
% 
%=====================================================

function [GF,err] = GFix_None_v1a_Func(GF,INPUT)

Status2('busy','Gradient Fix',3);

err.flag = 0;
err.msg = '';

GF.G0fix = INPUT.G0;

Status2('done','',3);
