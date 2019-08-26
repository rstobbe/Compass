%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = CreateSSKurtImDicom_v4a(SCRPTipt,SCRPTGBL)

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
dir = 5;
figno = 1;
LoadImageGalileo(squeeze(IMave(:,:,:,dir)),ImInfo,figno);

%minK = -2;
minK = 0;
anferr = 'no';
maxconst = 'yes';
fittype = 'exp';
%minkurtlen = find(bvalues == minbkurt,1);
D = zeros(dinfo.Rows,dinfo.Columns,totdirs);
K = zeros(dinfo.Rows,dinfo.Columns,totdirs);

%for d = 5
for d = 1:totdirs
    for m = 1:dinfo.Rows
        for n = 1:dinfo.Columns
            S0 = squeeze(IMave(m,n,:,d))';
            if S0(1) < 60;
                continue
            end
            %-------------------------------------
            % Avoid noise-floor error
            %-------------------------------------
            if strcmp(anferr,'yes')
                ind = find(S0 < 2*std,1,'first');
                %ind = find(S0 < 0,1,'first');
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
            %if length(S) < minkurtlen
            %if abs(S(1)/S(2)) > 15                   % for b500 and D = 3 would be ~4.5 
                %ind = find(S < 0,1,'first');
                %if not(isempty(ind))
                %    S = S(1:ind-1);
                %    SCN.b = bvalues(1:ind-1);
                %end
                %Est = 0.003;
                %if strcmp(fittype,'exp');
                %    [beta,resid,jacob,sigma,mse] = nlinfit(SCN,S,@Diffusion,Est,options);    
                %elseif strcmp(fittype,'ln')
                %    SCN.Sb0 = log(SCN.Sb0);
                %    lnS = log(S);
                %    [beta,resid,jacob,sigma,mse] = nlinfit(SCN,lnS,@lnDiffusion,Est,options);  
                %end
                %D(m,n,d) = beta(1);
                %if D(m,n,d) > 0.010
                %    D(m,n,d) = 0.010;
                %    S
                %    error();
                %end
                %D(m,n,d) = 1;
            %else  
                if S(2) < 0
                    D(m,n,d) = 1;
                    continue
                elseif (S(1)/S(2)) > 20
                    D(m,n,d) = 1;
                    continue
                elseif (S(1)/S(2)) > 10
                    Est = [0.004 0.5];
                elseif S(1)/S(2) > 5
                    Est = [0.003 0.5];
                elseif S(1)/S(2) > 2.5
                    Est = [0.002 0.5];
                elseif S(1)/S(2) > 1.5
                    Est = [0.0015 0.5];
                else
                    Est = [0.0005 0.5];
                end
                %S
                if strcmp(fittype,'exp')
                    [beta,resid,jacob,sigma,mse] = nlinfit(SCN,S,@Kurtosis,Est,options);
                elseif strcmp(fittype,'ln')
                    SCN.Sb0 = log(SCN.Sb0);
                    lnS = log(S);
                    [beta,resid,jacob,sigma,mse] = nlinfit(SCN,lnS,@lnKurtosis,Est,options);  
                end
                D(m,n,d) = beta(1);
                K(m,n,d) = beta(2);
                if K(m,n,d) < minK
                    K(m,n,d) = minK;
                end
                if strcmp(maxconst,'yes') 
                    %C = 3.33333;
                    %maxkval0 = C/(bvalues(length(bvalues))*D(m,n,d));
                    maxkval = 1/(750*D(m,n,d));                                 % calc from b2000 & b2500  (equivalent to C = 3.3333)
                    if K(m,n,d) > maxkval
                        fitK = K(m,n,d)
                        constK = maxkval
                        K(m,n,d) = maxkval;
                    end
                end
            %end
        end
        Status('busy',['Dir: ',num2str(d),'  Row: ',num2str(m)]);
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




