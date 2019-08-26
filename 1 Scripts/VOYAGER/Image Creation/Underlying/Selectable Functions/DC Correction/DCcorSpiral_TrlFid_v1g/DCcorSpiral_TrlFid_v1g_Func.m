%=====================================================
%
%=====================================================

function [DCCOR,err] = DCcorSpiral_TrlFid_v1g_Func(DCCOR,INPUT)

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
np = sz(2);
slices = sz(3);

%---------------------------------------------
% DC correct from trailing FID values
%---------------------------------------------
trfidpts = round(DCCOR.trfidper*np*0.01);
for n = 1:nrcvrs
    for p = 1:narray
        for s = 1:slices
            for m = 1:nproj            
                trlpts = FIDmat(m,np-trfidpts+1:np,s,p,n);
                stesearch = abs(trlpts)/median(abs(trlpts));
                stetest(m,s,p,n) = max(stesearch);
                if stetest(m,s,p,n) > 1.5
                    %error();       % do a test again.
                    %clf(figure(1101)); hold on;
                    %plot(real(FIDmat(m,:,n)),'r');
                    %plot(imag(FIDmat(m,:,n)),'b');
                    %plot(abs(FIDmat(m,:,n)),'c');
                    %plot([np-trfidpts np-trfidpts],[min([real(FIDmat(m,:,n)) imag(FIDmat(m,:,n))]) max([real(FIDmat(m,:,n)) imag(FIDmat(m,:,n))])],'k:');
                    %xlabel('Readout Points'); title('DC Offset (One Trajectory)');
                    goodinds = ones(1,length(trlpts));
                    inds = find(stesearch > 1.5);
                    for w = 1:length(inds)
                        if inds(w)-8 < 1
                            inds(w) = 9;
                        end
                        goodinds(inds(w)-8:inds(w)+8) = 0;
                    end   
                    %clf(figure(1102)); hold on;
                    %plot(abs(trlpts),'c');
                    %plot(real(trlpts),'r');
                    %plot(imag(trlpts),'b');
                    %plot(goodinds*mean(abs(trlpts)),'k');
                    %xlabel('Trailing Points Used'); title('DC Offset (One Trajectory)'); 
                    trlpts = trlpts(logical(goodinds));   
                end
                %medR = median(real(trlpts))
                %medI = median(imag(trlpts))
                %dcval(m,n) = medR + 1i*medI;
                dcval(m,s,p,n) = mean(trlpts);
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




