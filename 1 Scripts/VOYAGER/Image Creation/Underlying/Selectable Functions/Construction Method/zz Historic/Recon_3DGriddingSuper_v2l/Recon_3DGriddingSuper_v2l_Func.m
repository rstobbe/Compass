%=========================================================
% 
%=========================================================

function [RECON,err] = Recon_3DGriddingSuper_v2l_Func(RECON,INPUT)

Status2('busy','Create Image Via Gridding',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
DatMat = INPUT.Dat;
IMP = INPUT.IC.IMP;
IFprms = INPUT.IC.IFprms;
GRD = INPUT.IC.GRD;
gridfunc = INPUT.IC.gridfunc;
SDC = INPUT.SDC;
clear INPUT;

%---------------------------------------------
% Variables
%---------------------------------------------
ZF = IFprms.ZF;
Nexp = length(DatMat(1,1,:,1,1));
Nrcvrs = length(DatMat(1,1,1,:,1));
Naverages = length(DatMat(1,1,1,1,:));

%---------------------------------------------
% Setup / Test
%---------------------------------------------
Type = 'M2M';
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

if strcmp(RECON.test,'1RcvrOnly')
    Nrcvrs = 1;
end

tic
p = 1;
for n = 1:Nrcvrs
    for m = 1:Nexp
        for q = 1:Naverages
        
            %---------------------------------------------
            % Grid Data
            %---------------------------------------------
            Status2('busy','Grid Data',2);
            func = str2func([gridfunc,'_Func']);  
            INPUT.IMP = IMP;
            INPUT.DAT = DatMat(:,:,m,n,q).*SDC;
            GRD.type = 'complex';
            INPUT.StatLev = 3;
            [GRDout,err] = func(GRD,INPUT);
            if err.flag
                return
            end
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
            if strcmp(RECON.visuals,'SingleIm') || strcmp(RECON.visuals,'NewSingleIm') || strcmp(RECON.visuals,'MultiIm')
                if strcmp(RECON.visuals,'SingleIm')
                    fh = figure(10000); clf;
                elseif strcmp(RECON.visuals,'NewSingleIm')
                    if p == 1
                        fh = figure;
                    else
                        clf(fh);
                    end
                elseif strcmp(RECON.visuals,'MultiIm')
                    fh = figure(10000 + p); clf;
                end
                fh.Name = ['ImageSet ',num2str(m),'   Receiver ',num2str(n),'   Average ',num2str(q)];
                fh.NumberTitle = 'off';
                fh.Position = [200 150 1400 800];
                sz = size(Im0);
                maxval = max(abs(Im0(:)));
                subplot(2,3,1);
                ImAx = squeeze(abs(permute(Im0(:,:,sz(2)/2),[2,1,3])));
                ImAx = flip(ImAx,2);
                imshow(ImAx,[0 maxval]);
                title('Axial');
                subplot(2,3,2);
                ImCor = flip(squeeze(abs(permute(Im0(:,sz(2)/2,:),[3,1,2]))),1);
                ImCor = flip(ImCor,2);
                imshow(ImCor,[0 maxval]);
                title('Coronal');
                ImSag = flip(squeeze(abs(permute(Im0(sz(2)/2,:,:),[3,2,1]))),1);
                subplot(2,3,3); imshow(ImSag,[0 maxval]);
                title('Sagittal');
            end
            if p == 1
                sz = size(Im0);
                ImArr = zeros([sz Nexp Naverages]);
                %PhaseArr = zeros([sz Nexp Naverages]);
            end
            ImArr(:,:,:,m,q) = Im0;
            %PhaseArr(:,:,:,m,q) = angle(Im0);
            p = p+1;
        end
    end
    
    if Nrcvrs > 1
        %-------------------------------------------
        % Create Filter (for profile estimate)
        %-------------------------------------------
        if n == 1
            Status2('busy','Create Profile Estimate Filter',3);
            fwidx = 2*round((ReconPars.Imfovx/RECON.profres)/2);
            fwidy = 2*round((ReconPars.Imfovy/RECON.profres)/2);
            fwidz = 2*round((ReconPars.Imfovz/RECON.profres)/2);
            F0 = Kaiser_v1b(fwidx,fwidy,fwidz,RECON.proffilt,'unsym');
            [x,y,z] = size(Im0);
            F = zeros(x,y,z);
            F(x/2-fwidx/2+1:x/2+fwidx/2,y/2-fwidy/2+1:y/2+fwidy/2,z/2-fwidz/2+1:z/2+fwidz/2) = F0;
        end

        %-------------------------------------------
        % Create Low Res Image
        %-------------------------------------------
        Status2('busy','Create Low Resolution Image',2);
        ImLow = fftshift(ifftn(ifftshift(fftshift(fftn(ifftshift(ImArr(:,:,:,1,1)))).*F)));           % use first image / first average

        %---------------------------------------------
        % Plot
        %---------------------------------------------    
        if strcmp(RECON.visuals,'SingleIm') || strcmp(RECON.visuals,'NewSingleIm') || strcmp(RECON.visuals,'MultiIm')
            sz = size(ImLow);
            maxval = max(abs(ImLow(:)));
            ImAx = squeeze(abs(permute(ImLow(:,:,sz(2)/2),[2,1,3])));
            ImAx = flip(ImAx,2);
            subplot(2,3,4); imshow(ImAx,[0 maxval]),
            ImCor = flip(squeeze(abs(permute(ImLow(:,sz(2)/2,:),[3,1,2]))),1);
            ImCor = flip(ImCor,2);
            subplot(2,3,5); imshow(ImCor,[0 maxval]),
            ImSag = flip(squeeze(abs(permute(ImLow(sz(2)/2,:,:),[3,2,1]))),1);
            subplot(2,3,6); imshow(ImSag,[0 maxval]);
        end
        
        %-------------------------------------------
        % Initialize
        %-------------------------------------------            
        if n == 1
            ImLowSoS = complex(zeros(x,y,z),zeros(x,y,z));
            ImHighSoS = complex(zeros(x,y,z,Nexp,Naverages),zeros(x,y,z,Nexp,Naverages));
        end

        %-------------------------------------------
        % Receiver Combine 
        %-------------------------------------------    
        ImLowSoS = ImLowSoS + ImLow.*conj(ImLow);
        for m = 1:Nexp
            for q = 1:Naverages
                ImHighSoS(:,:,:,m,q) = ImHighSoS(:,:,:,m,q) + ImArr(:,:,:,m,q).*conj(ImLow);
            end
        end
    end    
end
clear DatMat GrdDat ZFDat IFprms Im0

%PhaseArr = PhaseArr/Nrcvrs;
if Nrcvrs > 1
    %-------------------------------------------
    % Finish Receiver Combine
    %-------------------------------------------  
    Im = complex(zeros(x,y,z,Nexp,Naverages),zeros(x,y,z,Nexp,Naverages));
    for m = 1:Nexp
        for q = 1:Naverages
            Im(:,:,:,m,q) = ImHighSoS(:,:,:,m,q)./sqrt(ImLowSoS);
        end
    end
    clear ImLosSOS
    clear ImHighSoS
else
    Im = ImArr;
end
clear ImArr
whos

RECON.ReconTime = toc;

%--------------------------------------------
% Panel
%--------------------------------------------
Panel(1,:) = {'',RECON.method,'Output'};
Panel(2,:) = {'SDC',IMP.SDCname,'Output'};
Panel(3,:) = {'ZeroFill',ZF,'Output'};
Panel(4,:) = {'ReconTime (seconds)',RECON.ReconTime,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);

%---------------------------------------------
% Return
%---------------------------------------------
RECON.Im = Im;
RECON.ReconPars = ReconPars;
RECON.PanelOutput = PanelOutput;

Status2('done','',2);
Status2('done','',3);