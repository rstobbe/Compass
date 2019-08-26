%=====================================================
%
%=====================================================

function [RCOMB,err] = RcvComb_SoS_v1c_Func(RCOMB,INPUT)

Status2('busy','Combine Receivers',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
Ims = INPUT.Im;
clear INPUT;

%---------------------------------------------
% Test
%---------------------------------------------
if length(size(highresIms))~=5
    err.flag = 1;
    err.msg = 'Do not have 5D data';
    return
end
[x,y,z,nexp,rcvrs] = size(Ims);           

%---------------------------------------------
% SoS
%---------------------------------------------
for m = 1:nexp
    for n = 1:rcvrs
        Ims(:,:,:,m,n) = (abs(Ims(:,:,:,m,n))).^2;
    end
end
RCOMB.Im = sum(Ims,5);

Status2('done','',2);
Status2('done','',3);



