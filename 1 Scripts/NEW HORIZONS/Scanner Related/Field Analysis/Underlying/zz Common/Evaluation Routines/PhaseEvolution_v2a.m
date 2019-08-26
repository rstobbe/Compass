%====================================================
% (v2a) removed visualization stuff
%====================================================

function [PH1,PH2] = PhaseEvolution_v2a(Fid1,Fid2)

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

test = PH1 - circshift(PH1,[0 -1 0]);
maxPHstep1 = max(max(max(abs(test(:,1:np-1,:)))))
test2 = PH2 - circshift(PH2,[0 -1 0]);
maxPHstep2 = max(max(max(abs(test2(:,1:np-1,:)))))

if maxPHstep1 > pi
    error('phase step too big');
elseif maxPHstep2 > pi
    error('phase step too big');
end