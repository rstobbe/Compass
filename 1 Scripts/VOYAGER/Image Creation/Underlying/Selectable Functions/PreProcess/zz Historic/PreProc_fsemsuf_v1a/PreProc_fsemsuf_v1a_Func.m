%=====================================================
%
%=====================================================

function [PREP,err] = PreProc_fsemsuf_v1a_Func(PREP,INPUT)

Status2('busy','Pre Processing',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% No Processing - do nothing
%---------------------------------------------
PREP.FIDmat = INPUT.FIDmat;

Status2('done','',2);
Status2('done','',3);






