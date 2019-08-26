%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = KurtROIDicom_v4a(SCRPTipt,SCRPTGBL)

global MOVEFUNCTION
global GETROIS

%-----
% - put in startup
global IMINFO
IMINFO(1).pixdim = 0;
IMINFO(1).vox = 0;
IMINFO(1).dicominfo = '';
IMINFO(2).pixdim = 0;
IMINFO(2).vox = 0;
IMINFO(2).dicominfo = '';
%-----

SCRPTGBL.TextBox = '';
SCRPTGBL.Figs = [];
SCRPTGBL.Data = [];
err.flag = 0;
err.msg = '';
options = statset('Robust','off');
%options = statset('Robust','on','WgtFun','bisquare');

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
locm = SCRPTipt(strcmp('FirstDicomFile',{SCRPTipt.labelstr})).runfuncoutput{1};
bvaluesstr = SCRPTipt(strcmp('b-values',{SCRPTipt.labelstr})).entrystr; 
totb0ims = str2double(SCRPTipt(strcmp('Tot_b0images',{SCRPTipt.labelstr})).entrystr);
totslices = str2double(SCRPTipt(strcmp('Tot_Slices',{SCRPTipt.labelstr})).entrystr); 
totdirs = str2double(SCRPTipt(strcmp('Tot_Directions',{SCRPTipt.labelstr})).entrystr); 
numaverages = str2double(SCRPTipt(strcmp('Averages',{SCRPTipt.labelstr})).entrystr); 
slice = str2double(SCRPTipt(strcmp('Slice',{SCRPTipt.labelstr})).entrystr); 
offset = str2double(SCRPTipt(strcmp('BGoffset',{SCRPTipt.labelstr})).entrystr);
std = str2double(SCRPTipt(strcmp('StdNoise',{SCRPTipt.labelstr})).entrystr);
minbkurt = str2double(SCRPTipt(strcmp('MinbKurt',{SCRPTipt.labelstr})).entrystr);

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
filem = locm(1:strfind(locm,'.IMA')-1);
dots = strfind(filem,'.');
filem = filem(1:dots(length(dots))-1);

test = exist([filem,'.',num2str(1,'%2.2i'),'.IMA'],'file');
if test == 2
    dinfo = dicominfo([filem,'.',num2str(1,'%2.2i'),'.IMA']);
    numres = 2;
else
    test = exist([filem,'.',num2str(1,'%2.3i'),'.IMA'],'file');
    if test == 2
        dinfo = dicominfo([filem,'.',num2str(1,'%2.3i'),'.IMA']);
        numres = 3;
    else
        test = exist([filem,'.',num2str(1,'%2.4i'),'.IMA'],'file');
        if test == 2
            dinfo = dicominfo([filem,'.',num2str(1,'%2.4i'),'.IMA']);
            numres = 4;
        end
    end
end    
pix = dinfo.PixelSpacing;
wid = dinfo.SpacingBetweenSlices;
ImInfo.pixdim = [pix' wid];
ImInfo.vox = ImInfo.pixdim(1)*ImInfo.pixdim(2)*ImInfo.pixdim(3);
ImInfo.dicominfo = dinfo;

%-------------------------------------
% Load b0 Images
%-------------------------------------
b0im = zeros(dinfo.Rows,dinfo.Columns,totb0ims*numaverages);
b0imnum = 0;
for nave = 1:numaverages
    m = slice + (nave-1)*((numbvalues-1)*totdirs*totslices + totb0ims*totslices);
    for a = 1:totb0ims
        b0imnum = b0imnum + 1;
        if numres == 2
            b0im(:,:,b0imnum) = dicomread([filem,'.',num2str(m,'%2.2i'),'.IMA']);
        elseif numres == 3
            b0im(:,:,b0imnum) = dicomread([filem,'.',num2str(m,'%2.3i'),'.IMA']);
        elseif numres == 4
            b0im(:,:,b0imnum) = dicomread([filem,'.',num2str(m,'%2.4i'),'.IMA']);
        end    
        m = m + totslices;
        %-------------------------------------
        % display each b0 image as loaded
        %-------------------------------------
        %figno = 1;
        %LoadImageGalileo(b0im(:,:,b0imnum),ImInfo,figno);          
    end    
end
%min(b0im(:))

%-------------------------------------
% Average
%-------------------------------------
aveb0im = mean(b0im,3);

%-------------------------------------
% display each b0 image (as group)
%-------------------------------------
%figno = 1;
%LoadImageGalileo(b0im,ImInfo,figno);              

%-------------------------------------
% display average b0 image
%-------------------------------------
%figno = 1;
%LoadImageGalileo(aveb0im,ImInfo,figno);

IM = zeros(dinfo.Rows,dinfo.Columns,numbvalues,totdirs,numaverages);
%-------------------------------------
% Load b0 > 0 Images
%-------------------------------------
for nave = 1:numaverages
    for d = 1:totdirs        
        m = totb0ims*totslices + (d-1)*totslices + slice + (nave-1)*((numbvalues-1)*totdirs*totslices + totb0ims*totslices);
        for a = 1:numbvalues
            %m
            if a == 1
                IM(:,:,1,d,nave) = aveb0im;
            else
                if numres == 2
                    IM(:,:,a,d,nave) = dicomread([filem,'.',num2str(m,'%2.2i'),'.IMA']);
                elseif numres == 3
                    IM(:,:,a,d,nave) = dicomread([filem,'.',num2str(m,'%2.3i'),'.IMA']);
                elseif numres == 4
                    IM(:,:,a,d,nave) = dicomread([filem,'.',num2str(m,'%2.4i'),'.IMA']);
                end
                m = m + totslices*totdirs;
            end
            %-------------------------------------
            % display each b0 > 0 image as loaded
            %-------------------------------------
            %figno = 1;
            %LoadImageGalileo(IM(:,:,a,d,nave),ImInfo,figno);     
        end
    Status('busy',['Loading Direction ',num2str(d)]);    
    end
end
IM = IM - offset;
IMave = mean(IM,5);

%-------------------------------------
% Display All Image Averages
%-------------------------------------
%bvalue = 6;
%dir = 13;
%figno = 1;
%LoadImageGalileo(abs(squeeze(IM(:,:,bvalue,dir,:))),ImInfo,figno);
%LoadImageGalileo(abs(squeeze(IM(:,:,:,dir,1))),ImInfo,figno);

%-------------------------------------
% Display Images for ROI drawing
%-------------------------------------
dir = 13;
figno = 1;
LoadImageGalileo(squeeze(IMave(:,:,:,dir)),ImInfo,figno);

minK = -2;
anferr = 'no';
maxconst = 'yes';
fittype = 'exp';
minkurtlen = find(bvalues == minbkurt,1);
D = zeros(totdirs,1);
K = zeros(totdirs,1);
for dir = 1:totdirs
    %-------------------------------------
    % Display Images
    %-------------------------------------
    figno = 1;
    LoadImageGalileo(squeeze(IMave(:,:,:,dir)),ImInfo,figno);
    %-------------------------------------
    % Extract Signal
    %-------------------------------------
    [SROI] = Extract_ROI_Array_Each_Slice_v1a(1,1);
    S0 = mean(SROI,2);
    %-------------------------------------
    % Avoid noise-floor error
    %-------------------------------------
    if strcmp(anferr,'yes')
        %ind = find(S0 < 2*std,1,'first');
        %ind = find(S0 < 1*std,1,'first');
        ind = find(S0 < 0,1,'first');
        if not(isempty(ind))
            S = S0(1:ind-1);
            SCN.b = bvalues(1:ind-1);
        else
            S = S0;
            SCN.b = bvalues;
        end
    else
        S = S0;
        SCN.b = bvalues;
    end
    %-------------------------------------
    % Fit Kurtosis
    %-------------------------------------
    SCN.Sb0 = S(1);
    if length(S) < minkurtlen
        Est = 0.003;
        if strcmp(fittype,'exp');
            [beta,resid,jacob,sigma,mse] = nlinfit(SCN,S',@Diffusion,Est,options);    
        elseif strcmp(fittype,'ln')
            SCN.Sb0 = log(SCN.Sb0);
            lnS = log(S);
            [beta,resid,jacob,sigma,mse] = nlinfit(SCN,lnS',@lnDiffusion,Est,options);  
        end
        ci = nlparci(beta,resid,'covar',sigma);
        Dci(dir,:) = ci(1,:);
        D(dir) = beta(1); 
        testb = (0:2500);
        Fit = S(1)*exp(-testb*beta(1));        
    else
        Est = [0.0005 1];
        if strcmp(fittype,'exp')
            [beta,resid,jacob,sigma,mse] = nlinfit(SCN,S',@Kurtosis,Est,options);
        elseif strcmp(fittype,'ln')
            SCN.Sb0 = log(SCN.Sb0);
            lnS = log(S);
            [beta,resid,jacob,sigma,mse] = nlinfit(SCN,lnS',@lnKurtosis,Est,options);  
        end
        ci = nlparci(beta,resid,'covar',sigma);
        Dci(dir,:) = ci(1,:);
        Kci(dir,:) = ci(2,:);
        D(dir) = beta(1);
        K(dir) = beta(2);
        if K(dir) < minK
            K(dir) = minK;
        end
        if strcmp(maxconst,'yes') 
            C = 3;
            maxkval = C/(SCN.b(length(SCN.b))*D(dir));
            if K(dir) > maxkval
                fitK = K(dir)
                constK = maxkval
                K(dir) = maxkval;
                constdir = dir
            end
        end
        testb = (0:2500);
        Fit = S(1)*exp(-testb*D(dir) + (1/6)*(testb.^2)*(D(dir)^2)*K(dir));
        if Fit(2500) > Fit(2000);
            errordir = dir
        end
    end
    figure(100); 
    plot(SCN.b,log(S),'k*');
    hold on;
    plot(testb,log(Fit),'b');
    hold off;
    axis([0 2500 -1 5.5]);
    figure(101);
    plot(SCN.b,resid,'*r');
end

MK = mean(K)
MD = mean(D)

figure(100);
testb = (0:2500);
Fit = S(1)*exp(-testb*MD + (1/6)*(testb.^2)*(MD^2)*MK);
plot(testb,log(Fit),'r');


Status('done','');
Status2('done','',2);
Status2('done','',3);

%=========================================================
% Kurtosis Function
%=========================================================
function S = Kurtosis(P,SCN) 

S = SCN.Sb0*exp(-SCN.b*P(1) + (1/6)*(SCN.b.^2)*(P(1)^2)*P(2));

%=========================================================
% ln-Kurtosis Function
%=========================================================
function S = lnKurtosis(P,SCN) 

S = SCN.Sb0 - SCN.b*P(1) + (1/6)*(SCN.b.^2)*(P(1)^2)*P(2);

%=========================================================
% Diffusion Function
%=========================================================
function S = Diffusion(P,SCN) 

S = SCN.Sb0*exp(-SCN.b*P(1));

%=========================================================
% ln-Diffusion Function
%=========================================================
function S = lnDiffusion(P,SCN) 

S = SCN.Sb0 - SCN.b*P(1);

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
amx = max(double(IM(:)));                  
amn = min(double(IM(:)));
%if (abs(mn) < 0.1) && (abs(mx)/abs(mn) > 1000)
%    mn = 0;
%end
mx = amx;
mn = 0;

set(findobj('tag',strcat('aMin',num2str(figno))),'string',num2str(amn,'%3.3g'));
set(findobj('tag',strcat('aMax',num2str(figno))),'string',num2str(amx,'%3.3g'));
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




