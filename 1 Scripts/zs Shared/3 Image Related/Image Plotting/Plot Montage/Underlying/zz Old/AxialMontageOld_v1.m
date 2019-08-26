%===================================================
% Create Axial Image Montage for Printing
%===================================================
function AxialMontage_v1(IM,type,start,step,stop,rows,lvl,docolor,SLab,figno)

%----------------------------------------
% Extract Slices
%----------------------------------------
IM = IM(:,:,start:step:stop);

[x,y,z] = size(IM);
d_wid = x;
d_height = y;
d_depth = z;

%----------------------------------------
% Image Type
%----------------------------------------
if strcmp(type,'abs')
    IM = abs(IM);
elseif strcmp(type,'real')
    IM = real(IM);
elseif strcmp(type,'imag')
    IM = imag(IM);
elseif strcmp(type,'phase')
    IM = angle(IM);
end

%----------------------------------------
% Orient Images (forbrain = up)
%----------------------------------------
%[x,y,z] = size(IM);
%IM = zeros(x,y,z);
%IM = zeros(y,x,z);
%for i = 1:z
%    IM(:,:,i) = rot90(squeeze(IM(:,:,i)));
%end
%clear IM;
%[x,y,z] = size(IM);
    
%----------------------------------------
% Combine Images
%----------------------------------------
cols = ceil(d_depth/rows);
Img = zeros(x*cols,y*rows,'single');
k = 0;
for j = 0:cols-1
    for i = 0:rows-1
        if i+1+(j*rows) > z
            break;
        end
        Img(x*j+1:x*(j+1),y*i+1:y*(i+1)) = IM(:,:,i+1+(j*rows));
        k = k+1;
        slcelab(k) = {[(i+0.2)*d_wid;(j+0.98)*d_height;start+(k-1)*step]};
    end
end

%----------------------------------------
% Display Images
%----------------------------------------
figure(figno);
iptsetpref('ImshowBorder', 'tight');
imshow(Img,[lvl(1) lvl(2)]);
if docolor
    load('mycolormap');
    colormap(mycolormap);
    %colormap('jet');
end
figsize = [800 1000];
truesize(figno,figsize);

%----------------------------------------
% Label Slices
%----------------------------------------
if SLab == 1
    for i = 1:k
        g = cell2mat(slcelab(i));
        text(g(1),g(2),num2str(g(3)),'color',[1 0.6 0.6],'fontsize',8);
    end
end

