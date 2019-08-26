%=====================================================
%
%=====================================================

function [PSTP,err] = PostProc_VarianPA_v1a_Func(PSTP,INPUT)

Status2('busy','Post Processing',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Orient...
%---------------------------------------------
Im = permute(INPUT.Im,[2,1,3]);
Im = flipdim(Im,1);
PSTP.Im = Im;

Status2('done','',2);
Status2('done','',3);



