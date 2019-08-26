%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = Plot_GriddedSlices_v1b(SCRPTipt,SCRPTGBL)

SCRPTGBL.TextBox = '';
SCRPTGBL.Figs = [];
SCRPTGBL.Data = [];

err.flag = 0;
err.msg = '';

Ksz = str2double(SCRPTipt(strcmp('Ksz',{SCRPTipt.labelstr})).entrystr);
slice_no = str2double(SCRPTipt(strcmp('Slice',{SCRPTipt.labelstr})).entrystr);
orientation = SCRPTipt(strcmp('Orientation',{SCRPTipt.labelstr})).entrystr;
if iscell(orientation)
    orientation = SCRPTipt(strcmp('Orientation',{SCRPTipt.labelstr})).entrystr{SCRPTipt(strcmp('Orientation',{SCRPTipt.labelstr})).entryvalue};
end
minval = str2double(SCRPTipt(strcmp('MinVal',{SCRPTipt.labelstr})).entrystr);
maxval = str2double(SCRPTipt(strcmp('MaxVal',{SCRPTipt.labelstr})).entrystr);
colour = SCRPTipt(strcmp('Colour',{SCRPTipt.labelstr})).entrystr;
if iscell(colour)
    colour = SCRPTipt(strcmp('Colour',{SCRPTipt.labelstr})).entrystr{SCRPTipt(strcmp('Colour',{SCRPTipt.labelstr})).entryvalue};
end

figure;
[x,y] = meshgrid(1:Ksz);
load('ColorMap2');
colormap(mycolormap); 
if strcmp(orientation,'z')
    mesh(x,y,double(squeeze(abs(SCRPTGBL.Cdat(:,:,slice_no)))));
    I = squeeze(double(SCRPTGBL.Cdat(:,:,slice_no)));
elseif strcmp(orientation,'y') 
    mesh(x,y,double(squeeze(abs(SCRPTGBL.Cdat(:,slice_no,:)))));
    I = rot90(squeeze(double(SCRPTGBL.Cdat(:,slice_no,:))));
elseif strcmp(orientation,'x')
    mesh(x,y,double(squeeze(abs(SCRPTGBL.Cdat(slice_no,:,:)))));
    I = rot90(squeeze(double(SCRPTGBL.Cdat(slice_no,:,:))));
end
axis([0 Ksz 0 Ksz minval maxval]);
caxis([minval maxval]);

figure;
imshow(abs(I),[minval maxval]);
truesize(gcf,[250 250]);
if strcmp(colour,'Colour')
    colormap(mycolormap); 
end
caxis([minval maxval]);
colorbar;
axis off;
axis image;
set(gcf,'PaperPositionMode','auto');

figure;
all = 1;
if all == 1
    M = round(1.1*sqrt(Ksz));
    skip = 1;
    KRG = SCRPTGBL.Cdat;
    P = size(KRG);
    P = P(1);
    N = ceil(P/(M*skip));
    I = zeros(N*P,M*P);
    n = 1;
    for j = 1:N
        for k = 1:M
            if n <= (P-3)
                if strcmp(orientation,'z')
                    I((j-1)*P+1:j*P,(k-1)*P+1:k*P) = squeeze(double(KRG(:,:,n)));
                elseif strcmp(orientation,'y')
                    I((j-1)*P+1:j*P,(k-1)*P+1:k*P) = rot90(squeeze(double(KRG(:,n,:))));
                elseif strcmp(orientation,'x')
                    I((j-1)*P+1:j*P,(k-1)*P+1:k*P) = rot90(squeeze(double(KRG(n,:,:))));
                end
                %n = n+1;
                n = n+skip;
            end
        end
    end
    imshow(abs(I),[minval maxval]);
    truesize(gcf,[500 500]);
    if strcmp(colour,'Colour')
        colormap(mycolormap); 
    end
    caxis([minval maxval]);
    colorbar;
    axis off;
    axis image;
    set(gcf,'PaperPositionMode','auto');
end
