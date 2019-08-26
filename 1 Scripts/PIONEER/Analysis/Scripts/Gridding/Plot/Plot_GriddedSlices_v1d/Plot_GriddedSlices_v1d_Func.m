%=========================================================
% 
%=========================================================

function [OUTPUT,err] = Plot_GriddedSlices_v1d_Func(INPUT)

Status('busy','Plot Gridded Slices');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';
OUTPUT = struct();

%---------------------------------------------
% Get Input
%---------------------------------------------
GRD = INPUT.GRD;
GrdDat = GRD.GrdDat;
Ksz = GRD.Ksz;
PLOT = INPUT.PLOT;
clear INPUT;

%---------------------------------------------
% Common Variables
%---------------------------------------------
slice_no = PLOT.slice_no;
type = PLOT.type;
orientation = PLOT.orientation;
minval = PLOT.minval;
maxval = PLOT.maxval;
colour = PLOT.colour;
figno = PLOT.figno;

%---------------------------------------------
% Type
%---------------------------------------------
if strcmp(type,'abs')
    GrdDat = abs(GrdDat);
elseif strcmp(type,'phase')
    GrdDat = angle(GrdDat);
end


%---------------------------------------------
% Array
%---------------------------------------------
ArrayNum = 1;
GrdDat = GrdDat(:,:,:,ArrayNum);
%GrdDat = squeeze(GrdDat(:,:,:,1) - GrdDat(:,:,:,2));
%test = sum(abs(GrdDat(:)))

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
elseif strcmp(slice_no,'middle')
    slice_no = round((Ksz+1)/2);
    if strcmp(orientation,'z')
        I = squeeze(double(GrdDat(:,:,slice_no)));
    elseif strcmp(orientation,'y') 
        I = rot90(squeeze(double(GrdDat(:,slice_no,:))));
    elseif strcmp(orientation,'x')
        I = rot90(squeeze(double(GrdDat(slice_no,:,:))));
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
    axhand = gca;
    colormap(axhand,mycolormap); 
end
caxis([minval maxval]);
colorbar;
axis off;
axis image;
set(gcf,'PaperPositionMode','auto');

