%===================================================
% v1a
%   - returns Montage Matrix
%===================================================
function [Img] = MontageMatrix_v1a(IM,IMSTRCT)

%----------------------------------------
% Extract Slices
%----------------------------------------
IM = IM(:,:,IMSTRCT.start:IMSTRCT.step:IMSTRCT.stop);
[x,y,z] = size(IM);

%----------------------------------------
% Combine Images
%----------------------------------------
cols = ceil(z/IMSTRCT.rows);
Img = zeros(x*cols,y*IMSTRCT.rows,'single');
for j = 0:cols-1
    for i = 0:IMSTRCT.rows-1
        if i+1+(j*IMSTRCT.rows) > z
            break;
        end
        Img(x*j+1:x*(j+1),y*i+1:y*(i+1)) = IM(:,:,i+1+(j*IMSTRCT.rows));
    end
end


