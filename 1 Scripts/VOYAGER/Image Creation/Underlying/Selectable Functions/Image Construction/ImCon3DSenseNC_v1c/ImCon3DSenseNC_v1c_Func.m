%=====================================================
%
%=====================================================

function [SENSE,err] = ImCon3DSenseNC_v1c_Func(SENSE,INPUT)

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
Imsz = Imtop-Imbot+1;
Dat = Dat0;

%---------------------------------------------
% ZeroFill RcvrProf
%---------------------------------------------
Rsz = Imsz;
RcvrProf = zeros(Rsz,Rsz,Rsz,Nrcvrs);
Rcvrbot = (Rsz/2)-length(RcvrProf0)/2+1;
Rcvrtop = (Rsz/2)+length(RcvrProf0)/2;
Rcvrsz = Rcvrtop-Rcvrbot+1;
Filt = Kaiser(Rsz,Rsz,Rsz,8);
for n = 1:Nrcvrs
    zfR = zeros(Rsz,Rsz,Rsz);
    R = fftshift(fftn(ifftshift(squeeze(RcvrProf0(:,:,:,n)))));
    zfR(Rcvrbot:Rcvrtop,Rcvrbot:Rcvrtop,Rcvrbot:Rcvrtop) = R;
    zfR = zfR.*Filt;
    RcvrProf(:,:,:,n) = real(fftshift(ifftn(ifftshift(zfR))));
end
I = 1./(sum((RcvrProf.^2),4).^0.5);

%---------------------------------------------
% Test Profile ZeroFill
%---------------------------------------------
test = 0;
if test == 1
    RcvrProfScale = max(abs(RcvrProf(:)));
    for n = 1:Nrcvrs;
        tIm = RcvrProf(:,:,:,n);
        IMSTRCT.type = 'real'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = Rcvrsz; 
        IMSTRCT.rows = floor(sqrt(Rcvrsz)); IMSTRCT.lvl = [0 RcvrProfScale]; IMSTRCT.SLab = 0; IMSTRCT.figno = 1000+n; 
        IMSTRCT.docolor = 0; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
        AxialMontage_v2a(tIm,IMSTRCT);
    end
end

%===================================================
% Sense Algorithm
%===================================================
stop = 0;
for its = 1:100

    %---------------------------------------------
    % Create Images
    %---------------------------------------------
    func = str2func([SENSE.gridfunc,'_Func']);  
    Ims = zeros(Imsz,Imsz,Imsz,Nrcvrs);
    INPUT.IMP = IMP;
    for n = 1:Nrcvrs;
        INPUT.DAT = squeeze(Dat(:,:,n).*SDCmat(:,:,n));
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
        Im = zerofill_isotropic_odd_doubles(ifftshift(GRD.GrdDat/SubSamp^3),ZF);
        Im = (fftshift(ifftn(Im)));
        Im = Im./IFprms.V;
        Ims(:,:,:,n) = Im(Imbot:Imtop,Imbot:Imtop,Imbot:Imtop);
    end

    %---------------------------------------------
    % Test Images
    %---------------------------------------------
    test = 0;
    if test == 1
        tImInt0scale = max(abs(Ims(:)));
        for n = 1:Nrcvrs;
            tIm = abs(Ims(:,:,:,n));
            IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = Imsz; 
            IMSTRCT.rows = floor(sqrt(Imsz)); IMSTRCT.lvl = [0 tImInt0scale]; IMSTRCT.SLab = 0; IMSTRCT.figno = 1000+n; 
            IMSTRCT.docolor = 0; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
            AxialMontage_v2a(tIm,IMSTRCT);
        end
    end

    %---------------------------------------------
    % Sum of Squares ('half' intensity correct)
    %---------------------------------------------
    Ims = Ims.*conj(RcvrProf);
    Im = sum(Ims,4);
    Im = Im.*I;

    %---------------------------------------------
    % Test Intermediate Image
    %---------------------------------------------
    test = 0;
    if test == 1
        tIm = abs(Im.*I);
        if its == 1
            tImIntscale = max(tIm(:));
        end
        IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = Imsz; 
        IMSTRCT.rows = floor(sqrt(Imsz)); IMSTRCT.lvl = [0 tImIntscale]; IMSTRCT.SLab = 0; IMSTRCT.figno = 2001; 
        IMSTRCT.docolor = 0; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
        AxialMontage_v2a(tIm,IMSTRCT);
    end    

    %---------------------------------------------
    % Exit if only 1 iteration
    %---------------------------------------------    
    if SENSE.maxits == 1
        Imout = Im.*I;
        break
    end
    
    %---------------------------------------------
    % Conjugate Gradient Calc
    %---------------------------------------------
    [xsz,ysz,zsz] = size(Im);
    if its == 1
        b = reshape(Im,[numel(Im),1]);    % Ax=b  (A=IE'DEI and b=IE'Dm)  
        x = zeros(size(b));
        r = b;              % residual
        p = b;              % conjugate vector
    else
        Ap = reshape(Im,[numel(Im),1]);
        alpha = (r'*r)/(p'*Ap);
        x = x + alpha*p;
        rnew = r - alpha*Ap;
        CGerr = (rnew'*rnew)/(b'*b)
        if CGerr < SENSE.cgerrbreak
            stop = 1;
        end
        beta = (rnew'*rnew)/(r'*r);
        p = rnew + beta*p;
        r = rnew;
    end
    Im = reshape(p,[xsz,ysz,zsz]);

    %---------------------------------------------
    % Output Image
    %---------------------------------------------
    Imout = reshape(x,[xsz,ysz,zsz]);
    Imout = Imout.*I;

    %---------------------------------------------
    % Test Output Image
    %---------------------------------------------    
    test = 1;
    if test == 1
        tIm = abs(Imout);
        tImOutscale = max(tIm(:));
        IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = Imsz; 
        IMSTRCT.rows = floor(sqrt(Imsz)); IMSTRCT.lvl = [0 tImOutscale]; IMSTRCT.SLab = 0; IMSTRCT.figno = 4001; 
        IMSTRCT.docolor = 0; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
        AxialMontage_v2a(tIm,IMSTRCT);
    end    

    %---------------------------------------------
    % End
    %---------------------------------------------      
    if stop == 1 || its == (SENSE.maxits+1)
        its = its-1
        SENSE.its = its-1;
        break
    end
    
    %---------------------------------------------
    % 'Complete' intensity correct
    %---------------------------------------------
    Im = Im.*I;

    %---------------------------------------------
    % Test Intermediate Image
    %---------------------------------------------
    test = 1;
    if test == 1
        tIm = abs(Im);
        tImInt2scale = max(tIm(:));
        IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = Imsz; 
        IMSTRCT.rows = floor(sqrt(Imsz)); IMSTRCT.lvl = [0 tImInt2scale]; IMSTRCT.SLab = 0; IMSTRCT.figno = 3001; 
        IMSTRCT.docolor = 0; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
        AxialMontage_v2a(tIm,IMSTRCT);
    end     
    
    %---------------------------------------------
    % Separate and Reconstruct k-Space
    %---------------------------------------------    
    Ims0 = repmat(Im,[1 1 1 Nrcvrs]).*RcvrProf;
    Ims = zeros(ZF,ZF,ZF,Nrcvrs);
    Ims(Imbot:Imtop,Imbot:Imtop,Imbot:Imtop,:) = Ims0;
    clear Ims0
    Ims = Ims./repmat(IFprms.V,[1 1 1 Nrcvrs]);
    kMat = zeros(size(Ims));
    for n = 1:Nrcvrs
        kMat(:,:,:,n) = fftshift(fftn(ifftshift(Ims(:,:,:,n))));
    end
    kbot = (ZF/2)-(GRD.Ksz+1)/2+2;
    ktop = (ZF/2)+(GRD.Ksz+1)/2;
    kMat = kMat(kbot:ktop,kbot:ktop,kbot:ktop,:);
    clear Ims

    %---------------------------------------------
    % Reverse Grid
    %---------------------------------------------
    func = str2func([SENSE.gridrevfunc,'_Func']);  
    Dat = zeros(size(Dat0));
    INPUT.IMP = IMP;
    for n = 1:Nrcvrs
        INPUT.kDat = squeeze(kMat(:,:,:,n));
        INPUT.KRNprms = KRNprms;
        INPUT.SubSamp = SubSamp;
        GRDR.type = 'complex';
        [GRDR,err] = func(GRDR,INPUT);
        if err.flag
            return
        end
        Dat(:,:,n) = DatArr2Mat(GRDR.SampDat/SubSamp^3,IMP.PROJimp.nproj,IMP.PROJimp.npro);
    end        
end


%---------------------------------------------
% Return
%---------------------------------------------
SENSE.Im = Imout;
SENSE.ImSz = length(Imout);

Status2('done','',2);
Status2('done','',3);

