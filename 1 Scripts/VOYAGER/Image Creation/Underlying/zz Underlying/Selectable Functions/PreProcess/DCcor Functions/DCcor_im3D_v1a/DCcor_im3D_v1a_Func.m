%=====================================================
%
%=====================================================

function [DCCOR,err] = DCcor_im3D_v1a_Func(DCCOR,INPUT)

Status2('busy','DC correct Image',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
FIDmat = INPUT.FIDmat;
clear INPUT;

%---------------------------------------------
% DC correct from image
%---------------------------------------------
[~,~,~,nrcvrs] = size(FIDmat); 
for n = 1:nrcvrs
    imtemp = fftshift(ifftn(ifftshift(FIDmat(:,:,:,n))));
    imtemp = dcrmv(squeeze(imtemp));                            % Marc...
    FIDmat(:,:,:,n) = fftshift(fftn(ifftshift(squeeze(imtemp))));   
end

%---------------------------------------------
% Return
%---------------------------------------------
DCCOR.FIDmat = FIDmat;

Status2('done','',2);
Status2('done','',3);



