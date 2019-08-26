%=====================================================
%
%=====================================================

function [DCCOR,err] = DCcorCart_Med_v1b_Func(DCCOR,INPUT)

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
% Test Input
%---------------------------------------------
if length(size(FIDmat)) < 5
    error();            % should have a 5d input
end

%---------------------------------------------
% DC correct from median value
%---------------------------------------------
if strcmp(imtype,'2D')
    [x,y,nslices,nvols,nrcvrs] = size(FIDmat);
    for m = 1:nslices
        for p = 1:nvols
            for n = 1:nrcvrs
                ksnglrcvr = squeeze(FIDmat(:,:,m,p,n));
                dcval(m,p,n) = complex(median(real(ksnglrcvr(:))),median(imag(ksnglrcvr(:))));        
                FIDmat(:,:,m,p,n) = FIDmat(:,:,m,p,n) - dcval(m,p,n);  
            end
        end
    end
elseif strcmp(imtype,'3D')
    [x,y,z,nvols,nrcvrs0] = size(FIDmat);
    if nrcvrs ~= nrcvrs0
        error();
    end
    for n = 1:nrcvrs
        for m = 1:nvols
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
doplot = 0;
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
DCCOR.meandcvals = squeeze(mean(mean(dcval,1),2)).';
DCCOR.dcvals = dcval;

Status2('done','',2);
Status2('done','',3);



