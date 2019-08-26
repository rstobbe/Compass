%====================================================
%
%====================================================

function [Bloc1,Bloc2,Figs] = FieldEvolution_v2(PH1,PH2,expT,visuals,Figs,ind1,ind2)

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
        if visuals.figno ~= 0 && (p == 1 || not(visuals.first == 1))  
            hfe = figure(visuals.figno+10); hold on; plot([0 max(expT)],[0 0],'k:'); plot(expT,Bloc1(n,:,p)*1000,visuals.colour); plot(expT,Bloc2(n,:,p)*1000,[visuals.colour ':']);
            xlabel('(ms)'); ylabel('Field Evolution (uT)'); xlim([0 max(expT)]); ylim([-max(abs([Bloc1(n,:,p) Bloc2(n,:,p)]))*1.1*1000 max(abs([Bloc1(n,:,p) Bloc2(n,:,p)]))*1.1*1000]); title([visuals.title,' (Field Evolution)']);
            plot([expT(ind1),expT(ind1)],[-max(abs([Bloc1(n,:,p) Bloc2(n,:,p)]))*1.1*1000 max(abs([Bloc1(n,:,p) Bloc2(n,:,p)]))*1.1*1000],'k:');
            plot([expT(ind2),expT(ind2)],[-max(abs([Bloc1(n,:,p) Bloc2(n,:,p)]))*1.1*1000 max(abs([Bloc1(n,:,p) Bloc2(n,:,p)]))*1.1*1000],'k:');
        end
    end
end

if visuals.figno ~= 0 
    n = length(Figs);
    if n == 1 && isempty(Figs(n).handle)
        n = 1;
    else       
        n = n+1;
    end
    Figs(n).handle = hfe;
    Figs(n).name = [visuals.title,' (Field Evolution)'];
end