%==================================================
% Convolve Sampling Points Onto Themselves
%==================================================

function [CV,Ksz,Kx,Ky,Kz] = ConvSamp_v1(Ksz,Kx,Ky,Kz,DATR,W,beta,KrnRes,stat_tag)

if not(round(1000*W/KrnRes) == 1000*round(W/KrnRes))
    error
end
if not(round(1000/KrnRes) == 1000*round(1/KrnRes))
    error
end
iKrnRes = round(1/KrnRes);

KB = KaiBesImg_Half(W,beta,KrnRes,2*ceil(W/2)+2);
szKB = size(KB);

Kxr = round(Kx*iKrnRes);	
Kyr = round(Ky*iKrnRes);	
Kzr = round(Kz*iKrnRes);	

CV = zeros(1,length(Kxr));

for i = 1:length(Kxr)
	goodIndsX = uint32(find(abs(Kxr - Kxr(i)) <= 2*iKrnRes));
	if isempty(goodIndsX)
		continue;
    end
    Kyrgood = Kyr(goodIndsX);
    goodIndsY = goodIndsX(abs(Kyrgood - Kyr(i)) <= 2*iKrnRes);
    if isempty(goodIndsY)
        continue;
    end
    Kzrgood = Kzr(goodIndsY);   
    goodIndsZ = (goodIndsY(abs(Kzrgood - Kzr(i)) <= 2*iKrnRes));
    if isempty(goodIndsZ)
        continue;
    end  

    % Note that every sub index should be +1, but for the y and z index, this
    % +1 has been negated by the -1 from conversion to linear indexing
    KBgood = KB(abs(Kxr(goodIndsZ) - Kxr(i))+1 + ...
               (abs(Kyr(goodIndsZ) - Kyr(i))) * szKB(1) + ...
               (abs(Kzr(goodIndsZ) - Kzr(i))) * szKB(1)*szKB(2));

% 			KBgood = KB(sub2ind(szKB, abs(Kxr(goodIndsZ) - i*iKrnRes)+1, ...
% 			                          abs(Kyr(goodIndsZ) - j*iKrnRes) + 1, ...
% 																abs(Kzr(goodIndsZ) - k*iKrnRes) + 1));

    CV(i) = sum(KBgood .* DATR(goodIndsZ));

    if rem(i,1000) == 0
        set(stat_tag,'String',strcat('Data Points:_',num2str(i)));
        drawnow;
    end
end


