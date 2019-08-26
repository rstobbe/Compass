%===================================================
% Create Image Montage for Printing
%===================================================
function [handle,ImSz] = ImageMontageRGB_v1a(IM,IMSTRCT)

%----------------------------------------
% Extract Slices
%----------------------------------------
IM = IM(:,:,IMSTRCT.start:IMSTRCT.step:IMSTRCT.stop);
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
        slcelab(k) = {[(i+0.2)*y;(j+0.98)*x;IMSTRCT.start+(k-1)*IMSTRCT.step]};
    end
end
ImSz = size(Img);

%----------------------------------------
% Display Images
%----------------------------------------
figure(IMSTRCT.figno); 
iptsetpref('ImshowBorder', 'tight');
%iptsetpref('ImshowBorder', 'loose');

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
handle = imshow(CImg);
    
if not(isempty(IMSTRCT.figsize))
    truesize(IMSTRCT.figno,IMSTRCT.figsize);
end
drawnow;
hold on;

%----------------------------------------
% Label Slices
%----------------------------------------
if IMSTRCT.SLab == 1
    for i = 1:k
        g = cell2mat(slcelab(i));
        text(g(1),g(2),num2str(g(3)),'color',[1 0.6 0.6],'fontsize',8);
    end
end

