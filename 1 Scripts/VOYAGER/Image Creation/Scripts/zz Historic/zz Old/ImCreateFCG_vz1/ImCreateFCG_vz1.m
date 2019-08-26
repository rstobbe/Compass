%=========================================================
% 
%=========================================================

function [IM,IMPROP,IMPROC,KRN,warn,warnflag] = FCGridding_v1(Dat,SDC,ArrKmat,kstep,kmax,IMPROP,IMPROC,KRN)

Status('busy','Normalize Projections to Grid');
func = str2func(IMPROC.NORMPROJprms.method);
[Ksz,Kx,Ky,Kz,warn,warnflag] = func(ArrKmat,kmax,kstep,IMPROC.CONVprms.subsamp,IMPROC.KRNprms.W);
if warnflag == 1
    Status('warn',warn);
    return
end

Status('busy','Generate Convolution Kernel');
func = str2func(IMPROC.KRNprms.type);
if not(isfield(KRN,'type'))
    [KRN,warn,warnflag] = func(IMPROC.KRNprms);
else
    if not(strcmp(KRN.type,IMPROC.KRNprms.type));
        if not(strcmp(KRN.name,IMPROC.KRNprms.name));
            [KRN,warn,warnflag] = func(IMPROC.KRNprms);
        end
    end
end
if warnflag == 1
    Status('warn',warn);
    return
end

Status('busy','Convolve Data');
%--
%Dat = ones(1,length(SDC));
%--
compDat = Dat.*SDC;
func = str2func(IMPROC.CONVprms.type);
[CDat,warn,warnflag] = func(Ksz,Kx,Ky,Kz,KRN,compDat,IMPROC.CONVprms);
if warnflag == 1
    Status('warn',warn);
    return
end

%---------
all = 0;
orientation = 'y';
colour = 2;
if all == 1
    KRG = CDat;
    P = size(KRG);
    P = P(1);
    M = 5;
    skip = 1;
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
    figure;
    imshow(abs(I)/max(abs(I(:))),[-1 1]);
    truesize(gcf,[500 500]);
    if colour == 2
        %load('mycolormap2');
        %colormap(mycolormap2); 
        colormap 'jet';
    end
    %caxis([mean_pix-pix_dev mean_pix+pix_dev]);
    %colorbar;
    axis off;
    axis image;
    set(gcf,'PaperPositionMode','auto');
end
%error
%----------

Status('busy','Zero-Fill K-space'); 
zf = IMPROC.zf;                
CDat = Kzerofill_Kodd(ifftshift(CDat),zf,zf,zf);

Status('busy','FT k-space');    
IM = fftshift(ifftn(CDat));
clear CDat;

Status('busy','Inverse Filter');
global IFILPATH
[IM,file,abort,abortflag] = Inv_Filt_v1(IFILPATH,IM,zf,KRN.W,KRN.beta);
if abortflag == 1
    Status('error',abort);
    return
end

Status('busy','Return ~FoV');
% Check whether to do this...
L = length(IM);
edge0 = round(0.5*(L-(L/1.2))) + 1;
edge1 = L - round(0.5*(L-(L/1.2)));
IM = IM(edge0:edge1,edge0:edge1,edge0:edge1);

Status('busy','Save Relevant Info');
IMPROC.inv_filt = file;

FoV = 1000*IMPROC.CONVprms.subsamp/(kstep);      % in mm
IMPROP.ReconFoV = FoV; 
IMPROP.SupportedFoV = FoV/IMPROC.CONVprms.subsamp;
IMPROP.ReturnedFoV = length(IM)*FoV/zf;
IMPROP.IMpixx = FoV/zf;
IMPROP.IMpixy = FoV/zf;
IMPROP.IMpixz = FoV/zf;
IMPROP.IMvox = (FoV/zf)^3;



