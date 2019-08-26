%=========================================================
% 
%=========================================================

function [IM,IMPROP,IMPROC,KRN,warn,warnflag] = ImCreateFCG_v1(Dat,SDC,ArrKmat,kstep,kmax,IMPROC,KRN,IFILPATH,ANLZ,dostatus)

IMPROP = struct();

if strcmp(dostatus,'yes') 
    StatLev1 = 1;
    StatLev2 = 2;
else
    StatLev1 = 0;
    StatLev2 = 0;
end
Status2('busy','Grid Data',StatLev1);
[CDat,IMPROC,KRN,warn,warnflag] = FCGridding_v1(Dat,SDC,ArrKmat,kstep,kmax,IMPROC,KRN,StatLev2);
if warnflag == 1
    return
end

if ANLZ.kshow == 1
    C = (length(CDat)+1)/2;
    figure; plot(squeeze(CDat(C,C,:)));
    figure; imshow(squeeze(real(CDat(C,:,:))),[-max(abs(CDat(:))) max(abs(CDat(:)))]);
    truesize(gcf,[250 250]);
    colormap 'jet';
    axis image;
    set(gcf,'PaperPositionMode','auto');
    return
end

Status2('busy','Zero-Fill K-space',StatLev1); 
zf = IMPROC.zf;
if zf < length(CDat)
    warnflag = 1;
    warn = 'Increase ZF';
    return
end
CDat = zerofill_isotropic_odd_singles(ifftshift(CDat),zf);

Status2('busy','FT k-space',StatLev1);    
IM = fftshift(ifftn(CDat));
clear CDat;

Status2('busy','Inverse Filter',StatLev1);
[IM,file,warn,warnflag] = Inv_Filt_v1(IFILPATH,IM,zf,KRN.W,KRN.beta);
if warnflag == 1
    return
end

Status2('busy','Return ~FoV',StatLev1);
% Check whether to do this...
[IM] = ReturnFoV_v1(IM);

Status2('busy','Save Relevant Info',StatLev1);
IMPROC.inv_filt = file;

FoV = 1000*IMPROC.CONVprms.subsamp/(kstep);      % in mm
IMPROP.ReconFoV = FoV; 
IMPROP.SupportedFoV = FoV/IMPROC.CONVprms.subsamp;
IMPROP.ReturnedFoV = length(IM)*FoV/zf;
IMPROP.IMpixx = FoV/zf;
IMPROP.IMpixy = FoV/zf;
IMPROP.IMpixz = FoV/zf;
IMPROP.IMvox = (FoV/zf)^3;



