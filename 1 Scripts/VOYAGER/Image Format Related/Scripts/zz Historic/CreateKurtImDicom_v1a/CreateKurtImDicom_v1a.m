%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = CreateKurtImDicom_v1a(SCRPTipt,SCRPTGBL)

global MOVEFUNCTION
global GETROIS

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
totb0ims = str2double(SCRPTipt(strcmp('b0 images',{SCRPTipt.labelstr})).entrystr);
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
ImInfo.pixdim = [pix' wid];
ImInfo.vox = ImInfo.pixdim(1)*ImInfo.pixdim(2)*ImInfo.pixdim(3);

%-------------------------------------
% Load
%-------------------------------------
b0im = zeros(dinfo.Rows,dinfo.Columns,totb0ims);
m = slice;
for a = 1:totb0ims
    if numres == 2
        b0im(:,:,a) = dicomread([file,'.',num2str(m,'%2.2i'),'.IMA']);
    elseif numres == 3
        b0im(:,:,a) = dicomread([file,'.',num2str(m,'%2.3i'),'.IMA']);
    elseif numres == 4
        b0im(:,:,a) = dicomread([file,'.',num2str(m,'%2.4i'),'.IMA']);
    end
    m = m + totslices;
end
aveb0im = mean(b0im,3);
figno = 1;
LoadImageGalileo(aveb0im,ImInfo,figno);

IM = zeros(dinfo.Rows,dinfo.Columns,numbvalues);
IM(:,:,1) = aveb0im;
m = (dir-1)*totslices + totb0ims*totslices + slice;
for a = 2:numbvalues
    m
    if numres == 2
        IM(:,:,a) = dicomread([file,'.',num2str(m,'%2.2i'),'.IMA']);
    elseif numres == 3
        IM(:,:,a) = dicomread([file,'.',num2str(m,'%2.3i'),'.IMA']);
    elseif numres == 4
        IM(:,:,a) = dicomread([file,'.',num2str(m,'%2.4i'),'.IMA']);
    end
    m = m + totslices*totdirs;
end
figno = 1;
LoadImageGalileo(IM,ImInfo,figno);

%-------------------------------------
% Fit Kurtosis
%-------------------------------------
Status('busy','Fit Kurtosis');
Est = [0.001 1];
options = statset('Robust','off','WgtFun','');
SCN.b = bvalues;

D = zeros(dinfo.Rows,dinfo.Columns);
K = zeros(dinfo.Rows,dinfo.Columns);
for m = 1:dinfo.Rows
    for n = 1:dinfo.Columns
        S = squeeze(IM(m,n,:))';
        SCN.Sb0 = S(1);
        if SCN.Sb0 < 70;
            continue
        end
        [beta,resid,jacob,sigma,mse] = nlinfit(SCN,S,@Kurtosis,Est,options);
        D(m,n) = beta(1);
        K(m,n) = beta(2);
        %if K(m,n) < 0
        %    figure(10); hold on;
        %    plot(SCN.b,log(S));
        %    plot(SCN.b,log(S-resid),'r');
        %end
        %beta
        %ci = nlparci(beta,resid,'covar',sigma)
    end
end
figno = 1;
LoadImageGalileo(K*100,ImInfo,figno);
figno = 2;
LoadImageGalileo(D*100000,ImInfo,figno);

Status('done','');
Status2('done','',2);
Status2('done','',3);


%=========================================================
% Kurtosis Function
%=========================================================
function S = Kurtosis(P,SCN) 

S = SCN.Sb0*exp(-SCN.b*P(1) + (1/6)*(SCN.b.^2)*(P(1)^2)*P(2));


%=========================================================
% LoadImageGalileo
%=========================================================
function LoadImageGalileo(IM,ImInfo,figno)

global IMT
global IMDIM
global SCALE
global IMLVL
global IMDIM0
global CURFIG
global IMINFO

if figno == 0
    figno = CURFIG;
end
IMINFO(figno) = ImInfo;

%-------------------------------------
% No Scaling...
%-------------------------------------
mx = max(double(IM(:)));                  
mn = min(double(IM(:)));
if (abs(mn) < 0.1) && (abs(mx)/abs(mn) > 1000)
    mn = 0;
end

set(findobj('tag',strcat('aMin',num2str(figno))),'string',num2str(mn,'%3.3g'));
set(findobj('tag',strcat('aMax',num2str(figno))),'string',num2str(mx,'%3.3g'));
set(findobj('tag',strcat('lvl_min',num2str(figno))),'string',num2str(mn,'%3.3g'));
set(findobj('tag',strcat('lvl_max',num2str(figno))),'string',num2str(mx,'%3.3g'));
IMLVL(figno).min = mn-1;
IMLVL(figno).max = mx;

%-------------------------------------
% Set Image Dimensions and Current Slice
%-------------------------------------
imdim0.x2 = IMDIM.x2;
imdim0.y2 = IMDIM.y2;
imdim0.z2 = IMDIM.z2;

[x,y,z] = size(IM);
if IMDIM.slice > z                  % if current slice out of range
    IMDIM.slice = 1;
end

if not(imdim0.x2 == y) || not(imdim0.y2 == x) || not(imdim0.z2 == z) 
    if figno == 1
        if isempty(IMT{2})
            SCALE.xmax = 10000000;
            IMDIM.slice = 1;
        else
            Status('error','Can not load second image with different dimensions than first');
            return
        end
    elseif figno == 2
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

IMT(figno) = {IM};
set(findobj('tag',strcat('fig',num2str(figno))),'visible','on');

Plot_XY_Slice;
Draw_All_ROIs;
drawnow;
Compute_Current_ROI;
Compute_Saved_ROIs;
drawnow;




