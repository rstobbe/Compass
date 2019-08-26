%=====================================================
%
%=====================================================

function [DCCOR,err] = DCcor_MultiMed3D_v1a_Func(DCCOR,INPUT)

Status2('busy','DC correct FID',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
FIDmat = INPUT.FIDmat;
clear INPUT;

[~,~,~,nexp,nrcvrs] = size(FIDmat);

%---------------------------------------------
% DC correct from median value
%---------------------------------------------
for m = 1:nexp
    for n = 1:nrcvrs
        ksnglrcvr = squeeze(FIDmat(:,:,:,m,n));
        dcval(m,n) = complex(median(real(ksnglrcvr(:))),median(imag(ksnglrcvr(:))));         % dc correction from median val...
        FIDmat(:,:,:,n) = FIDmat(:,:,:,n) - dcval(m,n);  
    end
    Status2('busy',num2str(nexp-m),3);
end
%test = dcval 

%---------------------------------------------
% Return
%---------------------------------------------
DCCOR.FIDmat = FIDmat;

Status2('done','',2);
Status2('done','',3);



