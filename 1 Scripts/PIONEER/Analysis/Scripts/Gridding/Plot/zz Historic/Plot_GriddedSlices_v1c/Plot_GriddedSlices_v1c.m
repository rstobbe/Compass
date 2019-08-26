%=========================================================
% (v1c)
%       - update for RWSUI_B9
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = Plot_GriddedSlices_v1c(SCRPTipt,SCRPTGBL)

Status('busy','Plot Gridded Slices');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Image
%---------------------------------------------
global TOTALGBL
val = get(findobj('tag','totalgbl'),'value');
if isempty(val) || val == 0
    err.flag = 1;
    err.msg = 'No Image in Global Memory';
    return  
end
%if not(strcmp(TOTALGBL{1,val},'Grd'));
%    err.flag = 1;
%    err.msg = 'Global Selected Not From Gridding';
%    return  
%end
Grd = TOTALGBL{2,val};
GrdDat = Grd.GrdDat;
Ksz = Grd.Ksz;

%---------------------------------------------
% Get Input
%---------------------------------------------
slice_no = SCRPTGBL.CurrentTree.Slice;
orientation = SCRPTGBL.CurrentTree.Orientation;
minval = str2double(SCRPTGBL.CurrentTree.MinVal);
maxval = str2double(SCRPTGBL.CurrentTree.MaxVal);
colour = SCRPTGBL.CurrentTree.Colour;
figno = SCRPTGBL.CurrentTree.FigNo;

%---------------------------------------------
% Determine Figure
%---------------------------------------------
if strcmp(figno,'Continue')
    fighand = figure;
else
    fighand = str2double(figno);
end 

if strcmp(slice_no,'all')
    skip = 1;
    M = round(1.1*sqrt(Ksz));
    P = size(GrdDat);
    P = P(1);
    N = ceil(P/(M*skip));
    I = zeros(N*P,M*P);
    n = 1;
    for j = 1:N
        for k = 1:M
            if n <= (P-3)
                if strcmp(orientation,'z')
                    I((j-1)*P+1:j*P,(k-1)*P+1:k*P) = squeeze(double(GrdDat(:,:,n)));
                elseif strcmp(orientation,'y')
                    I((j-1)*P+1:j*P,(k-1)*P+1:k*P) = rot90(squeeze(double(GrdDat(:,n,:))));
                elseif strcmp(orientation,'x')
                    I((j-1)*P+1:j*P,(k-1)*P+1:k*P) = rot90(squeeze(double(GrdDat(n,:,:))));
                end
                n = n+skip;
            end
        end
    end
else
    slice_no = str2double(slice_no);   
    if strcmp(orientation,'z')
        I = squeeze(double(GrdDat(:,:,slice_no)));
    elseif strcmp(orientation,'y') 
        I = rot90(squeeze(double(GrdDat(:,slice_no,:))));
    elseif strcmp(orientation,'x')
        I = rot90(squeeze(double(GrdDat(slice_no,:,:))));
    end    
end    
    
figure(fighand);
imshow(abs(I),[minval maxval]);
truesize(gcf,[250 250]);
if strcmp(colour,'Colour')
    load('ColorMap4');
    colormap(mycolormap); 
end
caxis([minval maxval]);
colorbar;
axis off;
axis image;
set(gcf,'PaperPositionMode','auto');

