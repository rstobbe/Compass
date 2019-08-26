%=====================================================
%
%=====================================================

function [DCCOR,err] = DCcor_median3D_v1a_Func(DCCOR,INPUT)

Status2('busy','DC correct FID',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
FIDmat = INPUT.FIDmat;
nrcvrs = INPUT.nrcvrs;
clear INPUT;

%---------------------------------------------
% DC correct from median value
%---------------------------------------------
for n = 1:nrcvrs
    ksnglrcvr = squeeze(FIDmat(:,:,:,n));
    dcval = complex(median(real(ksnglrcvr(:))),median(imag(ksnglrcvr(:))));         % dc correction from median val...
    FIDmat(:,:,:,n) = FIDmat(:,:,:,n) - dcval;  
end

%---------------------------------------------
% Return
%---------------------------------------------
DCCOR.FIDmat = FIDmat;
DCCOR.dcval = dcval;

Status2('done','',2);
Status2('done','',3);



