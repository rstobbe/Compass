%=========================================================
% 
%=========================================================

function PlotMontage(tab,axnum)

global IMAGEANLZ
global FIGOBJS

%----------------------------------------
% Get Info
%----------------------------------------
Image = IMAGEANLZ.(tab)(axnum).GetCurrent3DImage;

%----------------------------------------
% Plot
%----------------------------------------
Image = flip(Image,3);
Image = permute(Image,[2 1 3]);
sz = size(Image);

%xscale = round(IMAGEANLZ.(tab)(axnum).GetXAxisLimits);   
%yscale = round(IMAGEANLZ.(tab)(axnum).GetYAxisLimits);   
%Image = Image(yscale(1):yscale(2),xscale(1):xscale(2),:);

Image = Image(:,:,50:5:240);

[x,y,z] = size(Image);
rows = round(sqrt(z/1.3));
columns = ceil(z/rows);

Img = zeros(x*rows,y*columns);
for j = 0:rows-1
    for i = 0:columns-1
        if i+1+(j*columns) > z
            break;
        end
        Img(x*j+1:x*(j+1),y*i+1:y*(i+1)) = Image(:,:,i+1+(j*columns));
    end
end
[ydim,xdim] = size(Img);
Image = Img;

%----------------------------------------
% Plot
%----------------------------------------
fighand = figure;
axhand = axes('parent',fighand);
h = imshow(Image);
h.CDataMapping = 'scaled';
axhand.DataAspectRatio = IMAGEANLZ.(tab)(axnum).GetPixelDimensions;
%axhand.CLim = IMAGEANLZ.(tab)(axnum).GetContrastLimit;
axhand.CLim = [0 2e-8];
axhand.XTick = [];
axhand.YTick = [];
colormap(axhand,FIGOBJS.Options.GrayMap);

%----------------------------------------
% Fix Border
%----------------------------------------
%factor = 1;
%pos = [400 200 xdim*factor ydim*factor];
%fighand.Position = pos;

%----------------------------------------
% Draw ROIs
%----------------------------------------
% for j = 0:rows-1
%     for i = 0:columns-1
%         if i+1+(j*columns) > z
%             break;
%         end
%         slice = sz(3)-(i+(j*columns)+start)+1;
%         xoff = x*j;
%         yoff = y*i;
%         IMAGEANLZ.(tab)(axnum).DrawSavedROIsOffset(axhand,slice,yoff,xoff);
%     end
% end


