%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = PlotMontage_v1a(SCRPTipt,SCRPTGBL)

global IMT
global IMLVL
global CURFIG

SCRPTGBL.TextBox = '';
SCRPTGBL.Figs = [];
SCRPTGBL.Data = [];
err.flag = 0;
err.msg = '';

%-------------------------------------
% Load Script
%-------------------------------------
xboti = str2double(SCRPTipt(strcmp('leftinset',{SCRPTipt.labelstr})).entrystr); 
xtopi = str2double(SCRPTipt(strcmp('rightinset',{SCRPTipt.labelstr})).entrystr); 
yboti = str2double(SCRPTipt(strcmp('bottominset',{SCRPTipt.labelstr})).entrystr); 
ytopi = str2double(SCRPTipt(strcmp('topinset',{SCRPTipt.labelstr})).entrystr); 
zstart = str2double(SCRPTipt(strcmp('zstart',{SCRPTipt.labelstr})).entrystr); 
zstop = str2double(SCRPTipt(strcmp('zstop',{SCRPTipt.labelstr})).entrystr); 
zstep = str2double(SCRPTipt(strcmp('zstep',{SCRPTipt.labelstr})).entrystr); 
nrows = str2double(SCRPTipt(strcmp('nrows',{SCRPTipt.labelstr})).entrystr); 

%order = 'reverse';
order = 'forward';
SLab = 0;
%topadd = 5;
topadd = 0;
%figsize = [800 1100];
figsize = [300 300];

IM = cell2mat(IMT(CURFIG));
%----------------------------------------
% Select Images
%----------------------------------------
[y,x,z] = size(IM)
if zstop > z
    zstop = z;
end
if strcmp(order,'reverse');
    IM2 = IM(1+ytopi:y-yboti,1+xboti:x-xtopi,zstop:-zstep:zstart);
    slcno = (zstop:-zstep:zstart);
else
    IM2 = IM(1+ytopi:y-yboti,1+xboti:x-xtopi,zstart:zstep:zstop);
    slcno = (zstart:zstep:zstop);
end
[y,x,z] = size(IM2);

IMt = zeros(y+topadd,x,z);
IMt(topadd+1:y+topadd,:,:) = IM2;
IM2 = IMt;
[y,x,z] = size(IM2);

d_wid = x;
d_height = y;

%----------------------------------------
% Combine Images
%----------------------------------------
col_no = ceil(z/nrows);
IMmontage = zeros(y*col_no,x*nrows);
k = 0;
for j = 0:col_no-1
    for i = 0:nrows-1
        if i+1+(j*nrows) > z
            break;
        end
        IMmontage(y*j+1:y*(j+1),x*i+1:x*(i+1)) = IM2(:,:,i+1+(j*nrows));
        k = k+1;
        slcelab(k) = {[(i+0.1)*d_wid;(j+0.98)*d_height; slcno(k)]};
    end
end

figure(100+CURFIG);
iptsetpref('ImshowBorder','tight');

%IMmontage = 50*IMmontage/88;
%imshow(IMmontage,[IMLVL(CURFIG).min+1 IMLVL(CURFIG).max]);
%imshow(IMmontage,[10 100]);
imshow(IMmontage,[0 253]);

load('ColorMap3');
%colormap(mycolormap);  
%colormap(IMLVL(CURFIG).color);    
%colorbar

truesize(gcf,figsize);

%----------------------------------------
% Label Slices
%----------------------------------------
if SLab == 1
    for i = 1:k
        g = cell2mat(slcelab(i));
        text(g(1),g(2),num2str(g(3)),'color',[1 0.6 0.6],'fontsize',8);
    end
end

Status('done','');
Status2('done','',2);
Status2('done','',3);



