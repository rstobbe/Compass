%=====================================================
%
%=====================================================

function [DCCOR,err] = DCcor3DCart_MedPerline_v1c_Func(DCCOR,INPUT)

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
% Test Input
%---------------------------------------------
if length(size(FIDmat)) < 5
    error();            % should have a 5d input
end

%---------------------------------------------
% DC correct from median value
%---------------------------------------------
[x,y,z,nvols,nrcvrs0] = size(FIDmat);
if nrcvrs ~= nrcvrs0
    error();
end
for i = 1:y
    for j = 1:z
        for n = 1:nrcvrs
            for m = 1:nvols
                ksnglrcvr = squeeze(FIDmat(:,i,j,m,n));
                dcval(i,j,m,n) = complex(median(real(ksnglrcvr(:))),median(imag(ksnglrcvr(:))));         
                FIDmat(:,i,j,m,n) = FIDmat(:,i,j,m,n) - dcval(i,j,m,n); 
            end
        end
    end
end
figure(100);
plot(real(dcval(:)));
    
%---------------------------------------------
% Return
%---------------------------------------------
DCCOR.FIDmat = FIDmat;
DCCOR.meandcvals = squeeze(mean(mean(mean(dcval,1),2),3)).';
DCCOR.dcvals = dcval;

Status2('done','',2);
Status2('done','',3);



