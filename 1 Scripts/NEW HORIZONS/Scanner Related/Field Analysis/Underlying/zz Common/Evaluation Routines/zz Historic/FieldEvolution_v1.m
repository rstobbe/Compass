%====================================================
%
%====================================================

function [Bloc1,Bloc2] = FieldEvolution_v1(PH1,PH2,expT,visuals)

dwell = expT(2) - expT(1);
[numexps,np,len] = size(PH1);
Bloc1 = zeros(numexps,np,len);
Bloc2 = zeros(numexps,np,len);
for n = 1:numexps
    for p = 1:len
        for m = 2:np
            Bloc1(n,m-1,p) = (PH1(n,m,p) - PH1(n,m-1,p))/(2*pi*dwell*42.577); % should be in mT
            Bloc2(n,m-1,p) = (PH2(n,m,p) - PH2(n,m-1,p))/(2*pi*dwell*42.577);
        end
        if visuals ~= 0
            figure(visuals+10); hold on; plot([0 max(expT)],[0 0],'k:'); plot(expT,Bloc1(n,:,p),'k'); plot(expT,Bloc2(n,:,p),'k:');
            xlabel('ms'); ylabel('mT'); xlim([0 max(expT)]); title('Field Evolution (Total)');
        end
    end
end