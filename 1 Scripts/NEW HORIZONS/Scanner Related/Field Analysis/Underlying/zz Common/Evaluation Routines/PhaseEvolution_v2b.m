%====================================================
% (v2b) 
%       - remove 'pi' comparison (will never be greater than)
%       - return array of phase steps
%====================================================

function [PH1,PH2,PH1_steps,PH2_steps] = PhaseEvolution_v2b(Fid1,Fid2)

[numexps,np,len] = size(Fid1);
PH1 = zeros(numexps,np,len);
PH2 = zeros(numexps,np,len);

%-------------------------------------
% Get Phase
%-------------------------------------
for n = 1:numexps
    for m = 1:len
        PH1(n,:,m) = unwrap(angle(Fid1(n,:,m)));
        PH2(n,:,m) = unwrap(angle(Fid2(n,:,m)));    
    end
end

PH1_steps = PH1 - circshift(PH1,[0 -1 0]);
PH2_steps = PH2 - circshift(PH2,[0 -1 0]);


