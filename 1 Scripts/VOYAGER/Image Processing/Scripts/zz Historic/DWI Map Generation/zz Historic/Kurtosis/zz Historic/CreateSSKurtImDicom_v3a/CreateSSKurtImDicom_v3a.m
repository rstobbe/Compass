%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = CreateSSKurtImDicom_v3a(SCRPTipt,SCRPTGBL)

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
options = statset('Robust','off','WgtFun','');

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
locm = SCRPTipt(strcmp('FirstDicomFile_Mag',{SCRPTipt.labelstr})).runfuncoutput{1};
locp = SCRPTipt(strcmp('FirstDicomFile_Phase',{SCRPTipt.labelstr})).runfuncoutput{1};
bvaluesstr = SCRPTipt(strcmp('b-values',{SCRPTipt.labelstr})).entrystr; 
totb0ims = str2double(SCRPTipt(strcmp('Tot_b0images',{SCRPTipt.labelstr})).entrystr);
totslices = str2double(SCRPTipt(strcmp('Tot_Slices',{SCRPTipt.labelstr})).entrystr); 
totdirs = str2double(SCRPTipt(strcmp('Tot_Directions',{SCRPTipt.labelstr})).entrystr); 
numaverages = str2double(SCRPTipt(strcmp('Averages',{SCRPTipt.labelstr})).entrystr); 
slice = str2double(SCRPTipt(strcmp('Slice',{SCRPTipt.labelstr})).entrystr); 

%--
offset = 31.1;
%offset = 0;
%--

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

filep = locp(1:strfind(locp,'.IMA')-1);
dots = strfind(filep,'.');
%filep = filep(1:dots(length(dots))-1);

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

D = zeros(dinfo.Rows,dinfo.Columns,totdirs);
K = zeros(dinfo.Rows,dinfo.Columns,totdirs);

IM_mag = zeros(dinfo.Rows,dinfo.Columns,numbvalues,totdirs,numaverages);
%IM_phase = zeros(dinfo.Rows,dinfo.Columns,numbvalues,totdirs,numaverages);

whos

%-------------------------------------
% Load b0 Images
%-------------------------------------
b0im_mag = zeros(dinfo.Rows,dinfo.Columns,totb0ims*numaverages);
%b0im_phase = zeros(dinfo.Rows,dinfo.Columns,totb0ims);
b0imnum = 0;
for nave = 1:numaverages
    m = slice + (nave-1)*((numbvalues-1)*totdirs*totslices + totb0ims*totslices);
    for a = 1:totb0ims
        b0imnum = b0imnum + 1;
        if numres == 2
            b0im_mag(:,:,b0imnum) = dicomread([filem,'.',num2str(m,'%2.2i'),'.IMA']);
            %b0im_phase(:,:,a) = dicomread([filep,'.',num2str(m,'%2.2i'),'.IMA']);
        elseif numres == 3
            b0im_mag(:,:,b0imnum) = dicomread([filem,'.',num2str(m,'%2.3i'),'.IMA']);
            %b0im_phase(:,:,a) = dicomread([filep,'.',num2str(m,'%2.3i'),'.IMA']);
        elseif numres == 4
            b0im_mag(:,:,b0imnum) = dicomread([filem,'.',num2str(m,'%2.4i'),'.IMA']);
            %b0im_phase(:,:,a) = dicomread([filep,'.',num2str(m,'%2.4i'),'.IMA']);
        end    
        m = m + totslices;
        %-------------------------------------
        % display each b0 image as loaded
        %-------------------------------------
        %figno = 1;
        %LoadImageGalileo(b0im_mag(:,:,b0imnum),ImInfo,figno);          
    end    
end

%-------------------------------------
% create complex images
%-------------------------------------
%b0im_phase = 2*pi*b0im_phase/4096 - pi;                    % weird phase accumulation between scan - complex averaging will not work.
%b0im = b0im_mag .* exp(1i*b0im_phase);
%b0im = b0im_mag(:,:,1) - offset;
b0im = b0im_mag;
min(b0im(:))

%-------------------------------------
% Average
%-------------------------------------
aveb0im = mean(b0im,3);

%-------------------------------------
% display each b0 image (as group)
%-------------------------------------
%figno = 1;
%LoadImageGalileo(b0im_mag,ImInfo,figno);              

%-------------------------------------
% display average b0 image
%-------------------------------------
%figno = 1;
%LoadImageGalileo(aveb0im,ImInfo,figno);

%-------------------------------------
% Load b0 > 0 Images
%-------------------------------------
for nave = 1:numaverages
    for d = 1:totdirs        
        m = totb0ims*totslices + (d-1)*totslices + slice + (nave-1)*((numbvalues-1)*totdirs*totslices + totb0ims*totslices);
        for a = 1:numbvalues
            %m
            if a == 1
                IM_mag(:,:,1,d,nave) = aveb0im;
                %IM_mag(:,:,1,d,nave) = b0im1;
            else
                if numres == 2
                    IM_mag(:,:,a,d,nave) = dicomread([filem,'.',num2str(m,'%2.2i'),'.IMA']);
                    %IM_phase(:,:,a,d,nave) = dicomread([filep,'.',num2str(m,'%2.2i'),'.IMA']);
                elseif numres == 3
                    IM_mag(:,:,a,d,nave) = dicomread([filem,'.',num2str(m,'%2.3i'),'.IMA']);
                    %IM_phase(:,:,a,d,nave) = dicomread([filep,'.',num2str(m,'%2.3i'),'.IMA']);
                elseif numres == 4
                    IM_mag(:,:,a,d,nave) = dicomread([filem,'.',num2str(m,'%2.4i'),'.IMA']);
                    %IM_phase(:,:,a,d,nave) = dicomread([filep,'.',num2str(m,'%2.4i'),'.IMA']);
                end
                m = m + totslices*totdirs;
            end
            %-------------------------------------
            % display each b0 > 0 image as loaded
            %-------------------------------------
            %figno = 1;
            %LoadImageGalileo(IM_mag(:,:,a,d,nave),ImInfo,figno);     
        end
    Status('busy',['Loading Direction ',num2str(d)]);    
    end
end

%-------------------------------------
% create complex images
%-------------------------------------
%IM_phase = 2*pi*IM_phase/4096 - pi; 
%IM = IM_mag .* exp(1i*IM_phase);
IM = IM_mag - offset;
%IM = IM_phase;
clear IM_mag;
%clear IM_phase;

%-------------------------------------
% Display Images
%-------------------------------------
%bvalue = 6;
dir = 13;

%figno = 1;
%LoadImageGalileo(abs(squeeze(IM(:,:,bvalue,dir,:))),ImInfo,figno);
%LoadImageGalileo(abs(squeeze(IM(:,:,:,dir,1))),ImInfo,figno);

IM = mean(IM,5);
figno = 1;
%LoadImageGalileo(squeeze(IM(:,:,bvalue,:)),ImInfo,figno);
LoadImageGalileo(squeeze(IM(:,:,:,dir)),ImInfo,figno);

options = statset('Robust','off','WgtFun','');
Est = [0.001 0.5];
SCN.b = bvalues;
for d = 1:totdirs    
    %-------------------------------------
    % Fit Kurtosis
    %-------------------------------------
    Status('busy','Fit Kurtosis');
    for m = 1:dinfo.Rows
        for n = 1:dinfo.Columns
            S = squeeze(IM(m,n,:,d))';
            SCN.Sb0 = S(1);
            if SCN.Sb0 < 70;
                continue
            end
            if S(2) < S(1)/5
                D(m,n,d) = 0;
                K(m,n,d) = 0;
                continue
            end
            %if S(2) > S(1)
            %    D(m,n,d) = 100;
            %    K(m,n,d) = 100;
            %    continue;
            %end
            [beta,resid,jacob,sigma,mse] = nlinfit(SCN,S,@Kurtosis,Est,options);
            D(m,n,d) = beta(1);
            K(m,n,d) = beta(2);
            %ci = nlparci(beta,resid,'covar',sigma);
            %if K(m,n,d) < -2
            %    K(m,n,d) = -2;                      % useing lower bound from Jensen 2010
            %end
            if K(m,n,d) < 0
                K(m,n,d) = 0;                      % useing lower bound from Jensen 2010
            end
            if K(m,n,d) > 10
                K(m,n,d) = 10;                      %
            end
            %if abs(ci(2,2) - beta(2)) > 1
            %    K(m,n,d) = NaN;
            %end
            %if K(m,n,d) < 0
            %    figure(10); 
            %    plot(SCN.b,log(S));
            %    hold on;
            %    plot(SCN.b,log(S-resid),'r');
            %    hold off;
            %end
        end
    end
    figno = 1;
    LoadImageGalileo(squeeze(K(:,:,d))*1000,ImInfo,figno);
    figno = 2;
    LoadImageGalileo(squeeze(D(:,:,d))*1000000,ImInfo,figno);
end

MK = mean(K,3);
MD = mean(D,3);
figno = 1;
LoadImageGalileo(MK*1000,ImInfo,figno);
figno = 2;
LoadImageGalileo(MD*1000000,ImInfo,figno);

Status('done','');
Status2('done','',2);
Status2('done','',3);

%=========================================================
% Kurtosis Function
%=========================================================
function S = Kurtosis(P,SCN) 

S = SCN.Sb0*exp(-SCN.b*P(1) + (1/6)*(SCN.b.^2)*(P(1)^2)*P(2));

%=========================================================
% Diffusion Function
%=========================================================
function S = Diffusion(P,SCN) 

S = SCN.Sb0*exp(-SCN.b*P(1));

%=========================================================
% ln-Diffusion Function
%=========================================================
function S = lnDiffusion(P,SCN) 

S = SCN.Sb0 -SCN.b*P(1);


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




