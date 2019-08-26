%===========================================
% 
%===========================================

function [BASE,err] = MultiSuperAddCombine_v1a_Func(BASE,INPUT)

Status2('busy','Get Base Image for Mapping',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
Im = INPUT.Im;
ExpPars = INPUT.ExpPars;
clear INPUT;

%-------------------------------------------------
% Tests
%-------------------------------------------------
sz = size(Im);
nrcvrs = ExpPars.nrcvrs;
if length(sz) < 5 || nrcvrs == 1
        err.flag = 1;
        err.msg = '''MultiSuperAddCombine'' not compatible with input image';
        return
end    
if sz(5) < nrcvrs+1
    err.flag = 1;
    err.msg = '''MultiSuperAddCombine'' not compatible with RcvCombfunc';
    return
end
Im = Im(:,:,:,:,nrcvrs+1);    
Im = abs(sum(Im,4));
BASE.Im = Im;

Status2('done','',2);
Status2('done','',3);


