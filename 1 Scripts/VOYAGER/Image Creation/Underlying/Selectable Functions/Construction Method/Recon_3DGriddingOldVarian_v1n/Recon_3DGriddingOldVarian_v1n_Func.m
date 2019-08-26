%=========================================================
% 
%=========================================================

function [RECON,err] = Recon_3DGriddingOldVarian_v1n_Func(RECON,INPUT)

Status2('busy','Create Image Via Gridding',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
DatMat = INPUT.Dat;
IMP = INPUT.IC.IMP;
SDC = INPUT.IC.SDC;
IFprms = INPUT.IC.IFprms;
GRD = INPUT.IC.GRD;
gridfunc = INPUT.IC.gridfunc;
clear INPUT;

%---------------------------------------------
% Variables
%---------------------------------------------
ZF = IFprms.ZF;
Nexp = length(DatMat(1,1,:,1,1,1));
Nrcvrs = length(DatMat(1,1,1,:,1,1));
Naverages = length(DatMat(1,1,1,1,:,1));
Nechos = length(DatMat(1,1,1,1,1,:));

%---------------------------------------------
% Setup / Test
%---------------------------------------------
Type = 'M2M';
Kmat0 = IMP.Kmat;
sz = size(Kmat0);
if length(sz) > 3
    IMP.Kmat = Kmat0(:,:,:,1);
end
[Ksz,SubSamp,~,~,~,~,~,err] = ConvSetupTest_v1a(IMP,GRD.KRNprms,Type);
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

FullReconTimeTic = tic;
p = 1;
for n = 1:Nrcvrs
    for m = 1:Nexp
        for q = 1:Naverages
            for r = 1:Nechos
                
                %---------------------------------------------
                % Grid Data
                %---------------------------------------------
                Status2('busy','Grid Data',2);
                func = str2func([gridfunc,'_Func']);  
                INPUT.IMP = IMP;
                INPUT.IMP.Kmat = Kmat0(:,:,:,r);
                INPUT.DAT = DatMat(:,:,m,n,q,r).*SDC(:,:,r);
                GRD.type = 'complex';
                INPUT.StatLev = 3;
                GridTimeTic = tic;
                [GRDout,err] = func(GRD,INPUT);
                if err.flag
                    return
                end
                RECON.GridTime = toc(GridTimeTic);
                clear INPUT
                GrdDat = GRDout.GrdDat;
                SS = GRDout.SS;
                Ksz = GRDout.Ksz;
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
                RECON.visuals = 'None';               
                if strcmp(RECON.visuals,'SingleIm') || strcmp(RECON.visuals,'NewSingleIm') || strcmp(RECON.visuals,'MultiIm')
                    if strcmp(RECON.visuals,'SingleIm')
                        fh = figure(10000); clf;
                        if p == 1
                            fh.NumberTitle = 'off';
                            fh.Position = [200 150 1400 800];
                        end
                    elseif strcmp(RECON.visuals,'NewSingleIm')
                        if p == 1
                            fh = figure;
                        else
                            clf(fh);
                        end
                    elseif strcmp(RECON.visuals,'MultiIm')
                        fh = figure(10000 + p); clf;
                    end
                    fh.Name = ['ImageSet ',num2str(m),'   Receiver ',num2str(n),'   Average ',num2str(q),'   Echo ',num2str(r)];
                    ImPlot = flip(flip(Im0,3),2);
                    sz = size(ImPlot);
                    maxval = max(max(max(abs(ImPlot(round(sz/8):7*round(sz/8),round(sz/8):7*round(sz/8),round(sz/8):7*round(sz/8))))))*1.1;
                    subplot(1,3,1);
                    ImAx = squeeze(abs(permute(ImPlot(:,:,sz(2)/2),[2,1,3])));
                    ImAx = flip(ImAx,2);
                    imshow(ImAx,[0 maxval]);
                    title('Axial');
                    subplot(1,3,2);
                    ImCor = flip(squeeze(abs(permute(ImPlot(:,sz(2)/2,:),[3,1,2]))),1);
                    ImCor = flip(ImCor,2);
                    imshow(ImCor,[0 maxval]);
                    title('Coronal');
                    ImSag = flip(squeeze(abs(permute(ImPlot(sz(2)/2,:,:),[3,2,1]))),1);
                    subplot(1,3,3); imshow(ImSag,[0 maxval]);
                    title('Sagittal');
                end
                if p == 1
                    sz = size(Im0);
                    ImArr = zeros([sz Nexp Nrcvrs Naverages Nechos]);
                end
                ImArr(:,:,:,m,n,q,r) = Im0;
                p = p+1;
            end
        end
    end
end
RECON.FullReconTime = toc(FullReconTimeTic);

%--------------------------------------------
% Panel
%--------------------------------------------
Panel(1,:) = {'',RECON.method,'Output'};
Panel(2,:) = {'SDC',IMP.SDCname,'Output'};
Panel(3,:) = {'GridTime (seconds)',RECON.GridTime,'Output'};
Panel(4,:) = {'FullReconTime (seconds)',RECON.FullReconTime,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);

%---------------------------------------------
% Return
%---------------------------------------------
RECON.Im = ImArr;
RECON.ReconPars = ReconPars;
RECON.PanelOutput = PanelOutput;

Status2('done','',2);
Status2('done','',3);
