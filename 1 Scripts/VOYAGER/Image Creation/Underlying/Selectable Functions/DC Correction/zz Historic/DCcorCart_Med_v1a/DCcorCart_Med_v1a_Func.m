%=====================================================
%
%=====================================================

function [DCCOR,err] = DCcorCart_Med_v1a_Func(DCCOR,INPUT)

Status2('busy','DC correct FID',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
FIDmat = INPUT.FIDmat;
nrcvrs = INPUT.nrcvrs;
imtype = INPUT.imtype;
clear INPUT;

%---------------------------------------------
% DC correct from median value
%---------------------------------------------
if strcmp(imtype,'2D')
    [x,y,nslices,nrcvrs] = size(FIDmat);
    for m = 1:nslices
        for n = 1:nrcvrs
            ksnglrcvr = squeeze(FIDmat(:,:,m,n));
            dcval(m,n) = complex(median(real(ksnglrcvr(:))),median(imag(ksnglrcvr(:))));        
            FIDmat(:,:,m,n) = FIDmat(:,:,m,n) - dcval(m,n);  
        end
    end
elseif strcmp(imtype,'3D')
    for n = 1:nrcvrs
        ksnglrcvr = squeeze(FIDmat(:,:,:,n));
        dcval(n) = complex(median(real(ksnglrcvr(:))),median(imag(ksnglrcvr(:))));         
        FIDmat(:,:,:,n) = FIDmat(:,:,:,n) - dcval(n);  
    end
elseif strcmp(imtype,'3Dmulti')
    [x,y,z,mult,nrcvrs0] = size(FIDmat);
    if nrcvrs ~= nrcvrs0
        error();
    end
    for n = 1:nrcvrs
        for m = 1:mult
            ksnglrcvr = squeeze(FIDmat(:,:,:,m,n));
            dcval(m,n) = complex(median(real(ksnglrcvr(:))),median(imag(ksnglrcvr(:))));         
            FIDmat(:,:,:,m,n) = FIDmat(:,:,:,m,n) - dcval(m,n); 
        end
    end    
else
    error();
end

%---------------------------------------------
% Plot
%---------------------------------------------
doplot = 1;
if doplot == 1
    if strcmp(imtype,'2D')
        clrs = ['r','g','b','c'];
        for n = 1:nrcvrs
            figure(50); hold on
            plot(real(dcval(:,n)),clrs(n));
            xlabel('slices'); ylabel('dacval');
            title('Real DC Values');
            figure(51); hold on
            plot(imag(dcval(:,n)),clrs(n)); 
            xlabel('slices'); ylabel('dacval');
            title('Imaginary DC Values');
        end
    end
end
    
%---------------------------------------------
% Return
%---------------------------------------------
DCCOR.FIDmat = FIDmat;
DCCOR.meandcvals = mean(dcval,1);
DCCOR.dcvals = dcval;

Status2('done','',2);
Status2('done','',3);



