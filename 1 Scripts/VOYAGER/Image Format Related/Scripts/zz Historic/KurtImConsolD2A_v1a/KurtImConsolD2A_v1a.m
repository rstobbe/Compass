%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = KurtImConsolD2A_v1a(SCRPTipt,SCRPTGBL)

global IMT
global IMDIM
global SCALE
global IMLVL
global IMDIM0
global IMINFO
global MOVEFUNCTION
global GETROIS
global CURFIG

SCRPTGBL.TextBox = '';
SCRPTGBL.Figs = [];
SCRPTGBL.Data = [];
err.flag = 0;
err.msg = '';

%-------------------------------------
% Test
%-------------------------------------
if strcmp(MOVEFUNCTION,'buildroi')
    Status('error','Right-click before loading a new image');
    return
end
if GETROIS == 1
    Status('error','Exit current ROI ("v" or "c") before loading images');
    return
end
Status('error','');

Output_Setup;

%-------------------------------------
% Load Script
%-------------------------------------
loc1 = SCRPTipt(strcmp('FirstDicomFile',{SCRPTipt.labelstr})).runfuncoutput{1};
bvaluesstr = SCRPTipt(strcmp('b-values',{SCRPTipt.labelstr})).entrystr; 
b0ims = str2double(SCRPTipt(strcmp('b0 images',{SCRPTipt.labelstr})).entrystr);
totslices = str2double(SCRPTipt(strcmp('Tot_Slices',{SCRPTipt.labelstr})).entrystr); 
totdirs = str2double(SCRPTipt(strcmp('Tot_Directions',{SCRPTipt.labelstr})).entrystr); 
slice = str2double(SCRPTipt(strcmp('Slice',{SCRPTipt.labelstr})).entrystr); 
dir = str2double(SCRPTipt(strcmp('Direction',{SCRPTipt.labelstr})).entrystr); 

inds = strfind(bvaluesstr,' ');
if isempty(inds)
    bvalues = str2double(bvaluesstr);
else
    bvalues(1) = str2double(bvaluesstr(1:inds(1)));
    for n = 2:length(inds)
        bvalues(n) = str2double(bvaluesstr(inds(n-1)+1:inds(n)));
    end
    if isempty(n)
        bvalues(2) = str2double(bvaluesstr(inds(1)+1:length(bvaluesstr)));
    else
        bvalues(n+1) = str2double(bvaluesstr(inds(n)+1:length(bvaluesstr)));
    end    
end
numbvalues = length(bvalues);

%-------------------------------------
% Get Dicom Info
%-------------------------------------
file = loc1(1:strfind(loc1,'.IMA')-1);
dots = strfind(file,'.');
file = file(1:dots(length(dots))-1);

test = exist([file,'.',num2str(1,'%2.2i'),'.IMA'],'file');
if test == 2
    dinfo = dicominfo([file,'.',num2str(1,'%2.2i'),'.IMA']);
    numres = 2;
else
    test = exist([file,'.',num2str(1,'%2.3i'),'.IMA'],'file');
    if test == 2
        dinfo = dicominfo([file,'.',num2str(1,'%2.3i'),'.IMA']);
        numres = 3;
    else
        test = exist([file,'.',num2str(1,'%2.4i'),'.IMA'],'file');
        if test == 2
            dinfo = dicominfo([file,'.',num2str(1,'%2.4i'),'.IMA']);
            numres = 4;
        end
    end
end    
pix = dinfo.PixelSpacing;
wid = dinfo.SpacingBetweenSlices;
IMINFO(CURFIG).pixdim = [pix' wid];
IMINFO(CURFIG).vox = IMINFO(CURFIG).pixdim(1)*IMINFO(CURFIG).pixdim(2)*IMINFO(CURFIG).pixdim(3);

%-------------------------------------
% Load
%-------------------------------------
IM = zeros(dinfo.Rows,dinfo.Columns,numbvalues);
m = slice;
for a = 1:numbvalues
    m
    if numres == 2
        IM(:,:,a) = dicomread([file,'.',num2str(m,'%2.2i'),'.IMA']);
    elseif numres == 3
        IM(:,:,a) = dicomread([file,'.',num2str(m,'%2.3i'),'.IMA']);
    elseif numres == 4
        IM(:,:,a) = dicomread([file,'.',num2str(m,'%2.4i'),'.IMA']);
    end
    if m == slice
        m = (dir-1)*totslices + b0ims*totslices + slice;
    else
        m = m + totslices*totdirs;
    end
end
%IM = flipdim(IM,1);                             
%IM = flipdim(IM,1);                             % (will depend on how images construced).
%IM(logical(isnan(IM))) = 0;

%---------------------------------------------------------
% No Scaling...
%---------------------------------------------------------
mx = max(double(IM(:)));                  
mn = min(double(IM(:)));
if (abs(mn) < 0.1) && (abs(mx)/abs(mn) > 1000)
    mn = 0;
end

set(findobj('tag',strcat('aMin',num2str(CURFIG))),'string',num2str(mn,'%3.3g'));
set(findobj('tag',strcat('aMax',num2str(CURFIG))),'string',num2str(mx,'%3.3g'));
set(findobj('tag',strcat('lvl_min',num2str(CURFIG))),'string',num2str(mn,'%3.3g'));
set(findobj('tag',strcat('lvl_max',num2str(CURFIG))),'string',num2str(mx,'%3.3g'));
IMLVL(CURFIG).min = mn-1;
IMLVL(CURFIG).max = mx;

%---------------------------------------------------------
% Set Image Dimensions and Current Slice
%---------------------------------------------------------
imdim0.x2 = IMDIM.x2;
imdim0.y2 = IMDIM.y2;
imdim0.z2 = IMDIM.z2;

[x,y,z] = size(IM);
if IMDIM.slice > z                  % if current slice out of range
    IMDIM.slice = 1;
end

if not(imdim0.x2 == y) || not(imdim0.y2 == x) || not(imdim0.z2 == z) 
    if CURFIG == 1
        if isempty(IMT{2})
            SCALE.xmax = 10000000;
            IMDIM.slice = 1;
        else
            Status('error','Can not load second image with different dimensions than first');
            return
        end
    elseif CURFIG == 2
        if isempty(IMT{1})
            SCALE.xmax = 10000000;
            IMDIM.slice = 1;
        else
            Status('error','Can not load second image with different dimensions than first');
            return
        end
    end
end
IMDIM0 = imdim0;
IMDIM.x2 = y;
IMDIM.y2 = x;
IMDIM.z2 = z;

if SCALE.xmax == 10000000;
    SCALE.xmin = 1;
    SCALE.xmax = IMDIM.x2;
    SCALE.ymin = 1;
    SCALE.ymax = IMDIM.y2;
end

IMT(CURFIG) = {IM};
set(findobj('tag',strcat('fig',num2str(CURFIG))),'visible','on');

Plot_XY_Slice;
Draw_All_ROIs;
drawnow;
Compute_Current_ROI;
Compute_Saved_ROIs;
drawnow;

Status('done','');
Status2('done','',2);
Status2('done','',3);



