%===================================================
% v1b
%   - axes/fig handles - now inputs
%   - input image matrix should have the big slice number at top 
%   - change slice numbers to match COMPASS display (i.e. scroll up to top)
%===================================================

function [ihand,ImSz] = ImageMontageRGB_v1b(IM,IMSTRCT)

%----------------------------------------
% Extract Slices
%----------------------------------------
imarr = (IMSTRCT.start:IMSTRCT.step:IMSTRCT.stop);
IMSTRCT.stop = imarr(end);
IM = IM(:,:,imarr);           
IM = flip(IM,3);                    
[x,y,z] = size(IM);

%----------------------------------------
% Image Type
%----------------------------------------
if strcmp(IMSTRCT.type,'abs')
    IM = abs(IM);
elseif strcmp(IMSTRCT.type,'real')
    IM = real(IM);
elseif strcmp(IMSTRCT.type,'imag')
    IM = imag(IM);
elseif strcmp(IMSTRCT.type,'phase')
    IM = angle(IM);
elseif strcmp(IMSTRCT.type,'phase90')
    IM = angle(IM);
    IM = IM-pi;
    IM(IM < -pi) = IM(IM < -pi) + 2*pi;
end
  
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
        slcelab(k) = {[(i+0.2)*y;(j+0.98)*x;IMSTRCT.stop-(k-1)*IMSTRCT.step]};
    end
end
ImSz = size(Img);

%----------------------------------------
% Display Images
%----------------------------------------
if IMSTRCT.docolor
    load(IMSTRCT.ColorMap);
    cmap = mycolormap;
else
    load('GrayColorMap');
    cmap = graycolormap;
end
L = length(cmap);
tImg = L*(Img-IMSTRCT.lvl(1))/(IMSTRCT.lvl(2)-IMSTRCT.lvl(1));
%min(tImg(:))
%max(tImg(:))
tImg(tImg<1) = 1;
tImg(tImg>L) = L;
CImg = zeros([ImSz 3]);
CImg(:,:,1) = interp1((1:L),cmap(:,1),tImg);
CImg(:,:,2) = interp1((1:L),cmap(:,2),tImg);
CImg(:,:,3) = interp1((1:L),cmap(:,3),tImg); 

iptsetpref('ImshowBorder','tight');
ihand = imshow(CImg,'Parent',IMSTRCT.ahand);
if not(isempty(IMSTRCT.figsize))
    truesize(IMSTRCT.fhand,IMSTRCT.figsize);
end
drawnow;
hold on;

%----------------------------------------
% Label Slices
%----------------------------------------
if IMSTRCT.SLab == 1
    for i = 1:k
        g = cell2mat(slcelab(i));
        text(g(1),g(2),num2str(g(3)),'color',[1 0.6 0.6],'fontsize',8,'Parent',IMSTRCT.ahand);
    end
end

