%=========================================================
% 
%=========================================================

function [IC,err] = ImCon3DGridding_v1g_Func(IC,INPUT)

Status2('busy','Create Image Via Gridding',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
Dat0 = INPUT.FID.FIDmat;
IMP = IC.IMP;
SDC = IC.SDCS.SDC;
IFprms = IC.IFprms;
GRD0 = IC.GRD;
ORNT0 = IC.ORNT;
clear INPUT;
IC = rmfield(IC,{'SDCS','IMP','IFprms','GRD'});

%---------------------------------------------
% Variables
%---------------------------------------------
returnfov = IC.returnfov;
ZF = IFprms.ZF;
Nexp = length(Dat0(1,1,:,1));
Nrcvrs = length(Dat0(1,1,1,:));
if Nexp ~= 1
    err.flag = 1;
    err.msg = 'Multi-experiment not supported';
    return
end
if strcmp(IC.test,'1RcvrOnly')
    N = 1;
else
    N = Nrcvrs;
end

for n = 1:N
    %---------------------------------------------
    % Compensate Data
    %---------------------------------------------
    Dat = Dat0(:,:,1,n);
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
    Im0 = fftshift(ifftn(ifftshift(Im0)));

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
            fh = figure(10000 + n); clf;
        end
        fh.Name = ['Receiver ',num2str(n)];
        fh.NumberTitle = 'off';
        fh.Position = [200 150 1400 800];
        sz = size(Im0);
        maxval = max(abs(Im0(:)));
        ImAx = squeeze(abs(permute(Im0(:,:,sz(2)/2),[2,1,3])));
        subplot(2,3,1); imshow(ImAx,[0 maxval]),
        ImCor = flip(squeeze(abs(permute(Im0(:,sz(2)/2,:),[3,1,2]))),1);
        subplot(2,3,2); imshow(ImCor,[0 maxval]),
        ImSag = flip(squeeze(abs(permute(Im0(sz(2)/2,:,:),[3,2,1]))),1);
        subplot(2,3,3); imshow(ImSag,[0 maxval]);
    end
    
    ReconPars.Imfovx = SS*IMP.PROJdgn.fov;
    ReconPars.Imfovy = SS*IMP.PROJdgn.fov;                 
    ReconPars.Imfovz = SS*IMP.PROJdgn.fov;
    if N > 1
        %-------------------------------------------
        % Create Filter (for profile estimate)
        %-------------------------------------------
        if n == 1
            Status2('busy','Create Profile Estimate Filter',3);
            fwidx = 2*round((ReconPars.Imfovx/IC.profres)/2);
            fwidy = 2*round((ReconPars.Imfovy/IC.profres)/2);
            fwidz = 2*round((ReconPars.Imfovz/IC.profres)/2);
            F0 = Kaiser_v1b(fwidx,fwidy,fwidz,IC.proffilt,'unsym');
            [x,y,z] = size(Im0);
            F = zeros(x,y,z);
            F(x/2-fwidx/2+1:x/2+fwidx/2,y/2-fwidy/2+1:y/2+fwidy/2,z/2-fwidz/2+1:z/2+fwidz/2) = F0;

            ImLowSoS = complex(zeros(x,y,z),zeros(x,y,z));
            ImHighSoS = complex(zeros(x,y,z),zeros(x,y,z));
        end

        %-------------------------------------------
        % Create Low Res Image
        %-------------------------------------------
        Status2('busy','Create Low Resolution Image',2);
        ImLow = fftshift(ifftn(ifftshift(fftshift(fftn(ifftshift(Im0))).*F)));

        %---------------------------------------------
        % Plot
        %---------------------------------------------    
        if strcmp(IC.visuals,'SingleIm') || strcmp(IC.visuals,'MultiIm')
            sz = size(ImLow);
            maxval = max(abs(ImLow(:)));
            ImAx = squeeze(abs(permute(ImLow(:,:,sz(2)/2),[2,1,3])));
            subplot(2,3,4); imshow(ImAx,[0 maxval]),
            ImCor = flip(squeeze(abs(permute(ImLow(:,sz(2)/2,:),[3,1,2]))),1);
            subplot(2,3,5); imshow(ImCor,[0 maxval]),
            ImSag = flip(squeeze(abs(permute(ImLow(sz(2)/2,:,:),[3,2,1]))),1);
            subplot(2,3,6); imshow(ImSag,[0 maxval]);
        end

        %-------------------------------------------
        % Receiver Combine Stuff
        %-------------------------------------------    
        ImLowSoS = ImLowSoS + ImLow.*conj(ImLow);
        ImHighSoS = ImHighSoS + Im0.*conj(ImLow); 
    end
end
clear Dat0 DatMat Dat SDC GRD0 GrdDat ZFDat IFprms 

if N > 1
    %-------------------------------------------
    % Finish Receiver Combine
    %-------------------------------------------  
    Im = ImHighSoS./sqrt(ImLowSoS);
    clear ImLosSOS
    clear ImHighSoS
else
    Im = Im0;
end
clear Im0
whos

%---------------------------------------------
% ReturnFov
%---------------------------------------------
if strcmp(returnfov,'Yes')
    bot = ZF*(SS-1)/(2*SS)+1;
    top = ZF*(SS+1)/(2*SS);
    bot = floor(bot);
    top = ceil(top);
    bot2 = zfdims(3)*(SS-1)/(2*SS)+1;
    top2 = zfdims(3)*(SS+1)/(2*SS);
    bot2 = floor(bot2);
    top2 = ceil(top2);
    Im = Im(bot:top,bot:top,bot2:top2,:,:);
    ReconPars.Imfovx = IMP.PROJdgn.fov;
    ReconPars.Imfovy = IMP.PROJdgn.fov;                 
    ReconPars.Imfovz = IMP.PROJdgn.fov;
end

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
        
%--------------------------------------------
% Panel
%--------------------------------------------
Panel(1,:) = {'','','Output'};
%Panel(1,:) = {'ImFoV',ReconPars.ImfovLR,'Output'};
%Panel(2,:) = {'ImSz',ReconPars.ImszLR,'Output'};
%Panel(3,:) = {'ImMaxVal',max(abs(Im(:))),'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);

%---------------------------------------------
% Remove GrdDat (no need to save)
%---------------------------------------------
GRD = rmfield(GRD,'GrdDat');

%---------------------------------------------
% Return
%---------------------------------------------
IC.Im = Im;
IC.maxval = max(abs(Im(:)));
IC.kSz0 = Ksz;
IC.GRD = GRD;
IC.ReconPars = ReconPars;
IC.PanelOutput = PanelOutput;

Status2('done','',2);
Status2('done','',3);
