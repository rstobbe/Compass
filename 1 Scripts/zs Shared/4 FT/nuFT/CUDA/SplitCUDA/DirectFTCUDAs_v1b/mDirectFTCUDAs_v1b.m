%==========================================================
% (v1b)
%		- update for Titan Black
%==========================================================

function [kVal,err] = mDirectFTCUDAs_v1b(Im,kLoc)

err.flag = 0;
err.msg = '';

if length(kLoc(:,1))~=3
    kLoc = kLoc.';
end

% - test max displacement not greater than IMdim/2 -

% - make sure multiple of 8 -

tic
[kVal,Tst,err0] = DirectFTCUDA_v1b(single(Im),single(kLoc));
toc
if not(isempty(err0))
    error(err0);
elseif Tst(3) == 0
    error('GPU issue');
end
