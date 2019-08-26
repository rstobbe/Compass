%=========================================================
% 
%=========================================================

function [IC,err] = ImCon3DGriddingReturnAll_v1i_Func(IC,INPUT)

Status2('busy','Create Image Via Gridding',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
Dat0 = INPUT.FID.FIDmat;
ExpPars = INPUT.FID.ExpPars;
Sequence = ExpPars.Sequence;
IMP = IC.IMP;
SDC = IC.SDCS.SDC;
IFprms = IC.IFprms;
GRD0 = IC.GRD;
ORNT0 = IC.ORNT;
RFOV0 = IC.RFOV;
clear INPUT;
IC = rmfield(IC,{'SDCS','IMP','IFprms','GRD'});

%---------------------------------------------
% Variables
%---------------------------------------------
ZF = IFprms.ZF;
Nexp = length(Dat0(1,1,:,1));
Nrcvrs = length(Dat0(1,1,1,:));

%---------------------------------------------
% Setup / Test
%---------------------------------------------
Type = 'M2M';
[Ksz,SubSamp,~,~,~,~,~,err] = ConvSetupTest_v1a(IMP,GRD0.KRNprms,Type);
if err.flag
    return
end
if Ksz > ZF
    err.flag = 1;
    err.msg = ['ZF must be greater than ',num2str(Ksz)];
    return
end
if rem(ZF,SubSamp)
    err.flag = 1;
    err.msg = 'ZF must be a multiple of SubSamp';
    return
end

if strcmp(IC.test,'1RcvrOnly')
    Nrcvrs = 1;
end

tic
p = 1;
for n = 1:Nrcvrs
    for m = 1:Nexp
        %---------------------------------------------
        % Compensate Data
        %---------------------------------------------
        Dat = Dat0(:,:,m,n);
        
        %----------------------------
        %vec = ones(1,5000);                % usamp test
        %arr = 1:2:5000;
        %arr = round(5000*rand(1,119));
        %vec(arr) = 0;
        %Dat(logical(vec),:,:) = 0;
        %----------------------------
        
        DatSz = size(Dat);
        if DatSz(1) == 1 || DatSz(2) == 1    
            Dat = Dat.*SDC;
            DatMat = DatArr2Mat(Dat,IMP.PROJimp.nproj,IMP.PROJimp.npro);
        else
            Dat = DatMat2Arr(Dat,IMP.PROJimp.nproj,IMP.PROJimp.npro);
            Dat = Dat.*SDC;
            DatMat = DatArr2Mat(Dat,IMP.PROJimp.nproj,IMP.PROJimp.npro);
        end

        %---------------------------------------------
        % Grid Data
        %---------------------------------------------
        Status2('busy','Grid Data',2);
        func = str2func([IC.gridfunc,'_Func']);  
        INPUT.IMP = IMP;
        INPUT.DAT = DatMat;
        GRD0.type = 'complex';
        INPUT.StatLev = 3;
        [GRD,err] = func(GRD0,INPUT);
        if err.flag
            return
        end
        clear INPUT
        GrdDat = GRD.GrdDat;
        SS = GRD.SS;
        Ksz = GRD.Ksz;
        ReconPars.Imfovx = SS*IMP.PROJdgn.fov;
        ReconPars.Imfovy = SS*IMP.PROJdgn.fov;                 
        ReconPars.Imfovz = SS*IMP.PROJdgn.fov;
        
        %---------------------------------------------
        % Test
        %---------------------------------------------
        if not(isfield(IFprms,'Elip'))
            IFprms.Elip = 1;
        end
        if Ksz > ZF*IFprms.Elip
            err.flag = 1;
            err.msg = ['Zero-Fill is to small. Ksz = ',num2str(Ksz)];
            return
        end

        %---------------------------------------------
        % Zero Fill / FT
        %---------------------------------------------
        Status2('busy','Zero-Fill',2);
        ZFDat = zeros([ZF,ZF,ZF]);
        sz = size(GrdDat);
        bot = (ZF-sz(1))/2+1;
        top = bot+sz(1)-1;
        ZFDat(bot:top,bot:top,bot:top) = GrdDat;

        zfdims = size(IFprms.V);                        % elip stuff
        bot = ((zfdims(1)-zfdims(3))/2)+1; 
        top = zfdims(1)-bot+1;
        Im0 = ZFDat(:,:,bot:top);

        Status2('busy','FT',2);
        Im0 = fftshift(ifftn(ifftshift(Im0/SubSamp^3)));

        %---------------------------------------------
        % Inverse Filter
        %---------------------------------------------
        Im0 = Im0./IFprms.V;

        %---------------------------------------------
        % Plot
        %---------------------------------------------    
        if strcmp(IC.visuals,'SingleIm') || strcmp(IC.visuals,'MultiIm')
            if strcmp(IC.visuals,'SingleIm')
                fh = figure(10000); clf;
            else
                fh = figure(10000 + (m-1)*Nrcvrs + n); clf;
            end
            fh.Name = ['ImageSet ',num2str(m),'   Receiver ',num2str(n)];
            fh.NumberTitle = 'off';
            fh.Position = [200 400 1400 400];
            sz = size(Im0);
            maxval = max(abs(Im0(:)));
            subplot(1,3,1);
            ImAx = squeeze(abs(permute(Im0(:,:,sz(2)/2),[2,1,3])));
            ImAx = flip(ImAx,2);
            imshow(ImAx,[0 maxval]);
            title('Axial');
            subplot(1,3,2);
            ImCor = flip(squeeze(abs(permute(Im0(:,sz(2)/2,:),[3,1,2]))),1);
            ImCor = flip(ImCor,2);
            imshow(ImCor,[0 maxval]);
            title('Coronal');
            ImSag = flip(squeeze(abs(permute(Im0(sz(2)/2,:,:),[3,2,1]))),1);
            subplot(1,3,3); imshow(ImSag,[0 maxval]);
            title('Sagittal');
        end
        if p == 1
            sz = size(Im0);
            ImArr = zeros([sz Nexp Nrcvrs]);
        end
        ImArr(:,:,:,m,n) = Im0;
        p = p+1;
    end
end
clear Dat0 DatMat Dat SDC GRD0 GrdDat ZFDat IFprms Im0
Im = ImArr;
clear ImArr
whos

%---------------------------------------------
% Orient
%---------------------------------------------
func = str2func([IC.orientfunc,'_Func']);  
INPUT.Im = Im;
INPUT.IMP = IMP;
INPUT.ReconPars = ReconPars;
[ORNT,err] = func(ORNT0,INPUT);
if err.flag
    return
end
Im = ORNT.Im;
ReconPars = ORNT.ReconPars;
clear INPUT;
clear ORNT;

%---------------------------------------------
% FoV
%---------------------------------------------
func = str2func([IC.returnfovfunc,'_Func']);  
INPUT.Im = Im;
INPUT.IMP = IMP;
INPUT.ReconPars = ReconPars;
INPUT.Sequence = Sequence;
[RFOV,err] = func(RFOV0,INPUT);
if err.flag
    return
end
Im = RFOV.Im;
ReconPars = RFOV.ReconPars;
clear INPUT;
clear ORNT;

%---------------------------------------------
% Recon Duration
%---------------------------------------------
IC.ReconTime = toc;

%--------------------------------------------
% Panel
%--------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',IC.method,'Output'};
Panel(3,:) = {'ReconTime (seconds)',IC.ReconTime,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);

%---------------------------------------------
% Remove GrdDat (no need to save)
%---------------------------------------------
GRD = rmfield(GRD,'GrdDat');

%---------------------------------------------
% Return
%---------------------------------------------
IC.Im = Im;
IC.GRD = GRD;
IC.ReconPars = ReconPars;
IC.PanelOutput = PanelOutput;

Status2('done','',2);
Status2('done','',3);
