%===================================================
% Setup Image Montage
%===================================================
function [Img,slcelab] = ImageMontageSetup_v1b(IM,IMSTRCT)

%----------------------------------------
% Extract Slices
%----------------------------------------
imarr = (IMSTRCT.start:IMSTRCT.step:IMSTRCT.stop);
IMSTRCT.stop = imarr(end);
IM = IM(:,:,imarr);           
IM = flip(IM,3);                    
[x,y,z] = size(IM);

%----------------------------------------
% Combine Images
%----------------------------------------
cols = ceil(z/IMSTRCT.rows);
Img = zeros(x*cols,y*IMSTRCT.rows,'single');
k = 0;
for j = 0:cols-1
    for i = 0:IMSTRCT.rows-1
        if i+1+(j*IMSTRCT.rows) > z
            break;
        end
        Img(x*j+1:x*(j+1),y*i+1:y*(i+1)) = IM(:,:,i+1+(j*IMSTRCT.rows));
        k = k+1;
        slcelab(k) = {[(i+0.2)*y;(j+0.98)*x;IMSTRCT.start+(k-1)*IMSTRCT.step]};
    end
end

