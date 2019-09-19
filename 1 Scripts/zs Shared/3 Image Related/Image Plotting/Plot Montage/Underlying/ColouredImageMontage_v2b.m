%===================================================
% v2b
%   - match ImageMontage_v2b
%===================================================

function [handles,ImSz,Img] = ColouredImageMontage_v2b(IM,IMSTRCT)

%----------------------------------------
% Extract Slices
%----------------------------------------                                      
imarr = (IMSTRCT.start:IMSTRCT.step:IMSTRCT.stop);
IMSTRCT.stop = imarr(end);
IM = IM(:,:,imarr,:);           
IM = flip(IM,3);                    
[x,y,z,c] = size(IM);
 
%----------------------------------------
% Combine Images
%----------------------------------------
cols = ceil(z/IMSTRCT.rows);
Img = zeros(x*cols,y*IMSTRCT.rows,3,'single');
k = 0;
for j = 0:cols-1
    for i = 0:IMSTRCT.rows-1
        if i+1+(j*IMSTRCT.rows) > z
            break;
        end
        Img(x*j+1:x*(j+1),y*i+1:y*(i+1),:) = IM(:,:,i+1+(j*IMSTRCT.rows),:);
        k = k+1;
        if isempty(IMSTRCT.lblvals)
            slcelab(k) = {[(i+0.2)*y;(j+0.98)*x;IMSTRCT.stop-(k-1)*IMSTRCT.step]};
        else
            slcelab(k) = {[(i+0.2)*y;(j+0.98)*x;IMSTRCT.lblvals(k)]};
        end
    end
end
ImSz = size(Img);
ImSz = ImSz(1:2);

%----------------------------------------
% Display Images
%----------------------------------------
iptsetpref('ImshowBorder','tight');
ihand = imshow(Img,[IMSTRCT.lvl(1) IMSTRCT.lvl(2)],'Parent',IMSTRCT.ahand);
if IMSTRCT.docolor
    if not(isempty(IMSTRCT.ColorMap))
        load(IMSTRCT.ColorMap);
        if exist('mycolormap','var')
            colormap(IMSTRCT.ahand,mycolormap);
        elseif exist('mycmap','var')
            colormap(IMSTRCT.ahand,mycmap);
        end
        colorbar(IMSTRCT.ahand);
    else
        colormap(IMSTRCT.ahand,'jet');
        colorbar(IMSTRCT.ahand);
    end
else
    %cmap = linspace(0,1,256);
    %colormap([cmap.' cmap.' cmap.']);
    %colormap(IMSTRCT.ahand,'gray');                % not enough values
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

%----------------------------------------
% Handles
%----------------------------------------
handles.fhand = IMSTRCT.fhand;
handles.ahand = IMSTRCT.ahand;
handles.ihand = ihand;

