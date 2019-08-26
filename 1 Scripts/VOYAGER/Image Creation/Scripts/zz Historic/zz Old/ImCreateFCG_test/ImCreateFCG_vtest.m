%=========================================================
% 
%=========================================================

function [IM,IMPROP,IMPROC,KRN,warn,warnflag] = ImCreateFCG_v1(Dat,SDC,ArrKmat,kstep,kmax,IMPROC,KRN)

Status('busy','Grid Data');
[CDat,IMPROC,KRN,warn,warnflag] = FCGridding_v1(Dat,SDC,ArrKmat,kstep,kmax,IMPROC,KRN);
if warnflag == 1
    return
end

Status('busy','Zero-Fill K-space'); 
zf = IMPROC.zf;                
CDat = zerofill_isotropic_odd_singles(ifftshift(CDat),zf);

Status('busy','FT k-space');    
IM = fftshift(ifftn(CDat));
clear CDat;

Status('busy','Inverse Filter');
global IFILPATH
[IM,file,warn,warnflag] = Inv_Filt_v1(IFILPATH,IM,zf,KRN.W,KRN.beta);
if warnflag == 1
    return
end

Status('busy','Return ~FoV');
% Check whether to do this...
[IM] = ReturnFoV_v1(IM);

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



