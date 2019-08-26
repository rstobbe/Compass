%=========================================================
%
%=========================================================

function [DOV,SDCS,err] = DOVG_v3a(Kmat,PROJdgn,PROJimp,CTF,SDCS,SCRPTipt,err)


Status2('busy','Find Convolved TF Values at Sampling Point Locations',2);
rKmag = ((Kmat(:,:,1).^2 + Kmat(:,:,2).^2 + Kmat(:,:,3).^2).^(1/2))/CTF.kmax;
SDCS.akmax = max(rKmag(:))*CTF.kmax;

DOV = zeros(size(rKmag),'single');
for n = 1:PROJdgn.nproj
    DOV(n,:) = interp1(CTF.rconv,CTF.SDconv,rKmag(n,:));
    if not(rem(n,100));
        Status2('busy',['Projection Number: ',num2str(n)],3);
    end
end

if visuals == 1
    figure(200); hold on;
    plot(rKmag(:),DOV(:),'r*');
    plot(CTF.rconv,CTF.SDconv,'b-');
    title('Required Values at Sampling Point Locations');
end