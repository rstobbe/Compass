%=====================================================
%
%=====================================================

function [DCCOR,err] = DCcorSpiral_Med_v1a_Func(DCCOR,INPUT)

Status2('busy','DC correct FID',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
FIDmat = INPUT.FIDmat;
visuals = INPUT.visuals;
clear INPUT;

%---------------------------------------------
% Size
%---------------------------------------------
sz = size(FIDmat);
if length(sz) == 3
    nrcvrs = 1;
    narray = 1;
elseif length(sz) == 4
    nrcvrs = 1;
    narray = sz(4);
elseif length(sz) == 5
    nrcvrs = sz(5);
    narray = sz(4);
end
nproj = sz(1);
slices = sz(3);

%---------------------------------------------
% DC correct from median value
%---------------------------------------------
for n = 1:nrcvrs
    for p = 1:narray
        for s = 1:slices
            for m = 1:nproj            
                dcval(m,s,p,n) = median(FIDmat(m,:,s,p,n));
                FIDmat(m,:,s,p,n) = FIDmat(m,:,s,p,n) - dcval(m,s,p,n);
            end
        end
    end
end

if strcmp(visuals,'Yes')
    for n = 1:nrcvrs
        figure(1100+n); hold on
        for p = 1:narray
            plot(real(dcval(1,:,p,n)),'r');
            plot(imag(dcval(1,:,p,n)),'b');
            xlabel('slice number'); ylabel('DC offset'); title(['DC offset variation (red=real blue=imag) Rcvr',num2str(n)]);
        end
    end
end

%---------------------------------------------
% Return
%---------------------------------------------
DCCOR.FIDmat = FIDmat;
DCCOR.meandcvals = squeeze(mean(mean(mean(dcval,1),2),3)).';
DCCOR.dcvals = dcval;

Status2('done','',2);
Status2('done','',3);



