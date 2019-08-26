%=====================================================
%
%=====================================================

function [SENSE,err] = ImCon3DSenseNC_v1a_Func(SENSE,INPUT)

Status2('busy','Non-Cartesian Sense Image Construction',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
Dat = INPUT.Dat;
GRD = SENSE.GRD;
GRDR = SENSE.GRDR;
RcvrProf0 = SENSE.RcvrProf;
IMP = SENSE.IMP;
SDCS = SENSE.SDCS;
SDC = SDCS.SDC;
clear SDCS;
KRNprms = SENSE.KRNprms;
clear INPUT;
IFprms = SENSE.IFprms;
SENSE = rmfield(SENSE,{'IMP','SDCS','RcvrProf','KRNprms','IFprms'});

%---------------------------------------------
% Sense - Setup
%---------------------------------------------
ZF = IFprms.ZF;
Nrcvrs = length(Dat(1,:));
Dat0 = zeros(IMP.PROJimp.nproj,IMP.PROJimp.npro,8);
SDCmat = zeros(IMP.PROJimp.nproj,IMP.PROJimp.npro,8);
for n = 1:Nrcvrs
    Dat0(:,:,n) = DatArr2Mat(squeeze(Dat(:,n)),IMP.PROJimp.nproj,IMP.PROJimp.npro);
    SDCmat(:,:,n) = SDCArr2Mat(SDC,IMP.PROJimp.nproj,IMP.PROJimp.npro);
end
clear SDC;
clear Dat;
SubSamp = 1.25;
Imbot = floor(ZF*(SubSamp-1)/(2*SubSamp)+1);
Imtop = ceil(ZF*(SubSamp+1)/(2*SubSamp));
Dat = Dat0;

%figure(1000);
%plot(IFprms.V(:,46,46));

for its = 1:10

    %---------------------------------------------
    % Create Images
    %---------------------------------------------
    func = str2func([SENSE.gridfunc,'_Func']);  
    INPUT.IMP = IMP;
    INPUT.DAT = squeeze(Dat(:,:,1).*SDCmat(:,:,1));
    INPUT.KRNprms = KRNprms;
    INPUT.SubSamp = SubSamp;
    GRD.type = 'complex';
    [GRD,err] = func(GRD,INPUT);
    if err.flag
        return
    end
    if GRD.Ksz > ZF
        error();
    end   
    %----
    ImTest1 = fftshift(ifftn(ifftshift(GRD.GrdDat/SubSamp^3)));
    %----
    Im = zerofill_isotropic_odd_doubles(ifftshift(GRD.GrdDat/SubSamp^3),ZF);
    Im = (fftshift(ifftn(Im)));
    Im = Im./IFprms.V;
    Im0 = zeros(ZF,ZF,ZF);
    Im0(Imbot:Imtop,Imbot:Imtop,Imbot:Imtop) = Im(Imbot:Imtop,Imbot:Imtop,Imbot:Imtop);
    Im = Im0;    
    %Im(Im<0.05) = 0;
    
    %----
    if its == 1;
        Im = zeros(size(Im));
        Im(30:60,30:60,30:60) = 1;
    end
    %----
    
    %---------------------------------------------
    % Test Images
    %---------------------------------------------
    scale = max(abs(Im(:)));
    tIm = abs(Im);
    Imsz = length(tIm);
    IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = Imsz; 
    IMSTRCT.rows = floor(sqrt(Imsz)); IMSTRCT.lvl = [0 scale]; IMSTRCT.SLab = 0; IMSTRCT.figno = 1000; 
    IMSTRCT.docolor = 0; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
    AxialMontage_v2a(tIm,IMSTRCT);

    %---------------------------------------------
    % Reverse Grid
    %---------------------------------------------
    Im = Im./IFprms.V;
    kMat = fftshift(fftn(ifftshift(Im)));
    kbot = (ZF/2)-(GRD.Ksz+1)/2+2;
    ktop = (ZF/2)+(GRD.Ksz+1)/2;
    kMat = kMat(kbot:ktop,kbot:ktop,kbot:ktop);
    %----
    ImTest2 = fftshift(ifftn(ifftshift(kMat)));
    ImTest3 = ImTest2./ImTest1;
    figure(5); hold on;
    plot(abs(ImTest3(:,42,42)),'r');
    %----
    func = str2func([SENSE.gridrevfunc,'_Func']);  
    INPUT.IMP = IMP;
    INPUT.kDat = kMat;
    INPUT.KRNprms = KRNprms;
    INPUT.SubSamp = SubSamp;
    GRDR.type = 'complex';
    [GRDR,err] = func(GRDR,INPUT);
    if err.flag
        return
    end
    Dat(:,:,1) = DatArr2Mat(GRDR.SampDat/SubSamp^3,IMP.PROJimp.nproj,IMP.PROJimp.npro);

    clf(figure(6000)); hold on;
    plot(squeeze(abs(Dat0(1,:,1))),'k');
    plot(squeeze(abs(Dat(1,:,1))),'r');   

end
    
error();

%---------------------------------------------
% Return
%---------------------------------------------
SENSE.kDat = kDat;

Status2('done','',2);
Status2('done','',3);

