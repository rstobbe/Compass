%====================================================
%
%====================================================

function [PH1,PH2,Figs] = PhaseEvolution_v2(Fid1,Fid2,expT,visuals,Figs)

[numexps,np,len] = size(Fid1);
PH1 = zeros(numexps,np,len);
PH2 = zeros(numexps,np,len);

%-------------------------------------
% Plot FID Magnitude and Phase
%-------------------------------------
for n = 1:numexps
    for m = 1:len
        %test = Fid1(n,:,m);
        PH1(n,:,m) = unwrap(angle(Fid1(n,:,m)));
        PH2(n,:,m) = unwrap(angle(Fid2(n,:,m)));    
        if visuals.figno ~= 0 && (m == 1 || not(visuals.first == 1))   
            hphase = figure(visuals.figno); hold on; plot(expT,PH1(n,:,m),visuals.colour); plot(expT,PH2(n,:,m),[visuals.colour '*-']); 
            xlabel('(ms)'),ylabel('Signal Phase'); title([visuals.title,' (Phase)']);
            hmag = figure(visuals.figno+1); hold on; plot(expT,abs(Fid1(n,:,m))/10000,visuals.colour); plot(expT,abs(Fid2(n,:,m))/10000,[visuals.colour ':']); 
            ylim([0 1.1*max(abs(Fid2(n,:,m)))/10000]);
            xlabel('(ms)'),ylabel('Signal Magnitude'); title([visuals.title,' (Magnitude)']);
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
    Figs(n).handle = hphase;
    Figs(n).name = [visuals.title,' (Phase)'];
    n = n+1;
    Figs(n).handle = hmag;
    Figs(n).name = [visuals.title,' (Magnitude)'];
end