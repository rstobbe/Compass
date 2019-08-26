%=========================================================
% 
%=========================================================

function [IC,err] = ImCon3DGriddingMulti_v1e_Func(IC,INPUT)

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
RCOMB = IC.RCOMB;
clear INPUT;
IC = rmfield(IC,{'SDCS','IMP','IFprms','GRD'});

%---------------------------------------------
% Variables
%---------------------------------------------
returnfov = IC.returnfov;
ZF = IFprms.ZF;

Nexp = length(Dat0(1,1,:,1));
Nrcvrs = length(Dat0(1,1,1,:));

if strcmp(IC.test,'1RcvrOnly')
    N = 1;
else
    N = Nrcvrs;
end

for m = 1:Nexp
    for n = 1:N
        
        %---------------------------------------------
        % Compensate Data
        %---------------------------------------------
        Dat = Dat0(:,:,m,n);
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
            Im0 = Im0(bot:top,bot:top,bot2:top2);
            ReconPars.Imfovx = IMP.PROJdgn.fov;
            ReconPars.Imfovy = IMP.PROJdgn.fov;                 
            ReconPars.Imfovz = IMP.PROJdgn.fov;
        else
            ReconPars.Imfovx = SS*IMP.PROJdgn.fov;
            ReconPars.Imfovy = SS*IMP.PROJdgn.fov;                 
            ReconPars.Imfovz = SS*IMP.PROJdgn.fov;
        end

        %---------------------------------------------
        % Orient
        %---------------------------------------------
        func = str2func([IC.orientfunc,'_Func']);  
        INPUT.Im = Im0;
        INPUT.IMP = IMP;
        INPUT.ReconPars = ReconPars;
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
        if m == 1 && n == 1
            Im = zeros([size(Im0) Nexp N]);
            Im(:,:,:,1,1) = Im0;
        else
            Im(:,:,:,m,n) = Im0;
        end
    end
end
clear Im0 Dat0 DatMat Dat SDC GRD0 GrdDat ZFDat IFprms 
whos

%------------------------------------------
% Combine Receivers
%------------------------------------------
if N > 1
    func = str2func([IC.rcvcombfunc,'_Func']);  
    INPUT.vis = IC.visuals;
    INPUT.Im = Im;
    INPUT.ReconPars = ReconPars;
    [RCOMB,err] = func(RCOMB,INPUT);
    if err.flag
        return
    end
    Im = RCOMB.Im;
    clear INPUT;
    clear RCOMB;
end

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
