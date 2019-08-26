%=========================================================
% 
%=========================================================

function [IM,IMPROP,IMPROC,KRN,warn,warnflag] = Interpolation_v1(Dat,SDC,ArrKmat,kstep,kmax,IMPROP,IMPROC,KRN)

Status('busy','Normalize Projections to Grid');
func = str2func(IMPROC.NORMPROJprms.method);
[Ksz,Kx,Ky,Kz,warn,warnflag] = func(ArrKmat,kmax,kstep,IMPROC.subsamp);
if warnflag == 1
    Status('warn',warn);
    return
end

Freal = TriScatteredInterp(Kx',Ky',Kz',real(Dat)');
Fimag = TriScatteredInterp(Kx',Ky',Kz',imag(Dat)');

[X,Y,Z] = meshgrid(1:Ksz,1:Ksz,1:Ksz);
KMatreal = Freal(X,Y,Z);
KMatimag = Fimag(X,Y,Z);
KMat = KMatreal + 1i.*KMatimag;
KMat(logical(isnan(KMat))) = 0;

Status('busy','Zero-Fill K-space'); 
zf = length(KMat)+1;                
KMat = Kzerofill_Kodd(ifftshift(KMat),zf,zf,zf);

addpath('D:\8 Programs\A0 Shared Routines\4 Filters\UPF\Cartesian Filters');
Filt = (Hamming(zf,zf,zf));

KMat = fftshift(KMat).*Filt;

%---------
show = 0;
orientation = 'z';
colour = 2;
if show == 1
    KRG = KMat;
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
    imshow(abs(I)/max(abs(I(:))),[-0.1 0.1]);
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



Status('busy','FT k-space');    
IM = fftshift(ifftn(ifftshift(KMat)));
clear KMat;

%Status('busy','Save Relevant Info');
%FoV = 1000*IMPROC.CONVprms.subsamp/(kstep);      % in mm
%IMPROP.ReconFoV = FoV; 
%IMPROP.SupportedFoV = FoV/IMPROC.CONVprms.subsamp;
%IMPROP.ReturnedFoV = length(IM)*FoV/zf;
%IMPROP.IMpixx = FoV/zf;
%IMPROP.IMpixy = FoV/zf;
%IMPROP.IMpixz = FoV/zf;
%IMPROP.IMvox = (FoV/zf)^3;



