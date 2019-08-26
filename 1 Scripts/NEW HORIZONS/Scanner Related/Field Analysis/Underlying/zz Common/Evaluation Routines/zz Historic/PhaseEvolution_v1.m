%====================================================
%
%====================================================

function [PH1,PH2] = PhaseEvolution_v1(Fid1,Fid2,expT,visuals)

[numexps,np,len] = size(Fid1);
PH1 = zeros(numexps,np,len);
PH2 = zeros(numexps,np,len);

%-------------------------------------
% Plot FID Magnitude and Phase
%-------------------------------------
for n = 1:numexps
    for m = 1:len
        test = Fid1(n,:,m);
        PH1(n,:,m) = unwrap(angle(Fid1(n,:,m)));
        PH2(n,:,m) = unwrap(angle(Fid2(n,:,m)));    
        if visuals ~= 0    
            figure(visuals); hold on; plot(expT,PH1(n,:,m),'k'); plot(expT,PH2(n,:,m),'k:'); title('Phase Evolution')
            figure(visuals+1); hold on; plot(expT,abs(Fid1(n,:,m))/10000,'k'); plot(expT,abs(Fid2(n,:,m))/10000,'k:'); 
            ylim([0 1.1*max(abs(Fid2(n,:,m)))/10000]); title('Magnitude Evolution');
        end
    end
end
