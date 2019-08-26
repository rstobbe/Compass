%=====================================================
%
%=====================================================

function [RCOMB,err] = RcvComb_SoSAdd_v1c_Func(RCOMB,INPUT)

Status2('busy','Combine Receivers',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
holdIms = INPUT.Im;
clear INPUT;

%---------------------------------------------
% Test
%---------------------------------------------
if length(size(holdIms)) ~= 5
    error();        % fix image recon
end
[x,y,z,nexp,rcvrs] = size(holdIms);           

%---------------------------------------------
% SoS
%---------------------------------------------
ImsSoS = zeros(x,y,z,nexp);
for m = 1:nexp
    tIms = zeros(x,y,z,rcvrs);
    for n = 1:rcvrs
        tIms(:,:,:,n) = (abs(holdIms(:,:,:,m,n))).^2;
    end
    ImsSoS(:,:,:,m) = sum(tIms,4);
end

%-------------------------------------------
% Add
%-------------------------------------------
holdIms(:,:,:,:,rcvrs+1) = ImsSoS;

%---------------------------------------------
% Return
%---------------------------------------------
RCOMB.Im = holdIms;

Status2('done','',2);
Status2('done','',3);



