%=========================================================
% 
%=========================================================

function [IC,err] = ImCon3DGridding_v1d_Func(IC,INPUT)

Status2('busy','Create Image Via Gridding',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
Dat0 = INPUT.FID.FIDmat;
ReconPars0 = INPUT.FID.ReconPars;
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

for m = 1:length(Dat0(1,1,:,1))

    Dat = Dat0(:,:,m,:);
    %---------------------------------------------
    % Compensate Data
    %---------------------------------------------
    DatSz = size(Dat);
    if DatSz(1) == 1 || DatSz(2) == 1    
        Dat = Dat.*SDC;
        [DAT] = DatArr2Mat(Dat,IMP.PROJimp.nproj,IMP.PROJimp.npro);
    else
        [Dat] = DatMat2Arr(Dat,IMP.PROJimp.nproj,IMP.PROJimp.npro);
        Dat = Dat.*SDC;
        [DAT] = DatArr2Mat(Dat,IMP.PROJimp.nproj,IMP.PROJimp.npro);
    end

    %---------------------------------------------
    % Grid Data
    %---------------------------------------------
    Status2('busy','Grid Data',2);
    func = str2func([IC.gridfunc,'_Func']);  
    INPUT.IMP = IMP;
    INPUT.DAT = DAT;
    INPUT.ZF = ZF;
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
    Status2('busy','Zero-Fill / FT',2);
    zfdims = size(IFprms.V);
    bot = ((zfdims(1)-zfdims(3))/2)+1; 
    top = zfdims(1)-bot+1;
    Im = GrdDat(:,:,bot:top);
    Im = fftshift(ifftn(ifftshift(Im)));

    %---------------------------------------------
    % Inverse Filter
    %---------------------------------------------
    Im = Im./IFprms.V;

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
        Im = Im(bot:top,bot:top,bot2:top2);
        %sz = [ZF ZF zfdims(3)]/SS;                     % delete
    else
        %sz = [ZF ZF zfdims(3)]; 
    end

    %---------------------------------------------
    % Orient
    %---------------------------------------------
    func = str2func([IC.orientfunc,'_Func']);  
    INPUT.Im = Im;
    INPUT.ReconPars = ReconPars0;
    [ORNT,err] = func(ORNT0,INPUT);
    if err.flag
        return
    end
    Im0 = ORNT.Im;
    ReconPars = ORNT.ReconPars;
    clear INPUT;
    clear ORNT;

    %---------------------------------------------
    % Array
    %---------------------------------------------    
    if m == 1
        Im1 = zeros([size(Im0) length(Dat0(1,1,:,1))]);
        Im1(:,:,:,1) = Im0;
    else
        Im1(:,:,:,m) = Im0;
    end  
end
Im = Im1;
    
%--------------------------------------------
% Panel
%--------------------------------------------
Panel(1,:) = {'ImFoV',ReconPars.ImfovLR,'Output'};
Panel(2,:) = {'ImSz',ReconPars.ImszLR,'Output'};
Panel(3,:) = {'ImMaxVal',max(abs(Im(:))),'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);

%---------------------------------------------
% Remove GrdDat (no need to save)
%---------------------------------------------
GRD = rmfield(GRD,'GrdDat');

%---------------------------------------------
% Return
%---------------------------------------------
IC.Im = Im;
%IC.ImSz_X = sz;            % delete
%IC.ImSz_Y = sz;
%IC.ImSz_Z = sz;
IC.maxval = max(abs(Im(:)));
IC.kSz0 = Ksz;
IC.GRD = GRD;
IC.ReconPars = ReconPars;
IC.PanelOutput = PanelOutput;

Status2('done','',2);
Status2('done','',3);
