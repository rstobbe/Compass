%=====================================================
%
%=====================================================

function [DCCOR,err] = DCcor_None_v1a_Func(DCCOR,INPUT)

Status2('busy','DC correct FID',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return
%---------------------------------------------
DCCOR.FIDmat = INPUT.FIDmat;

Status2('done','',2);
Status2('done','',3);



