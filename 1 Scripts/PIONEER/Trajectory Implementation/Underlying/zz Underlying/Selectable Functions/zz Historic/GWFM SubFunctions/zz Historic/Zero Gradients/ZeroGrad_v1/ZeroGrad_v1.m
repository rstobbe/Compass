%=====================================================
% Zero Gradients
%=====================================================

function [G,GQNT] = ZeroGrad_v1(G0,GQNT,IMPipt)

slope = str2double(IMPipt(strcmp('Slope',{IMPipt.labelstr})).entrystr);
cartslope = sqrt(slope^2/3);
gstep = GQNT.gres * cartslope;

[I,J,K] = size(G0);
endmagG = sqrt(G0(:,J,1).^2 + G0(:,J,2).^2 + G0(:,J,3).^2);
max_endmagG = max(endmagG(:));
extraT = max_endmagG/cartslope;

N = ceil(extraT/GQNT.gres);

T = (GQNT.arr(length(GQNT.arr))+GQNT.gres:GQNT.gres:GQNT.arr(length(GQNT.arr))+N*GQNT.gres);
GQNT.arrfull = [GQNT.arr T]; 

G = zeros(I,J+N,K);
G(:,1:J,:) = G0;

for i = 1:I
    for k = 1:K
        endG = G(i,J,k);
        if endG > 0
            brngdwn = (endG-gstep:-gstep:0);
        else
            brngdwn = (endG+gstep:gstep:0);
        end
        G(i,J+1:J+length(brngdwn),k) = brngdwn;
    end
end

