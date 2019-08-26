%=========================================================
% 
%=========================================================

function [IC,err] = ImCon2DGridding_v1c_Func(IC,INPUT)

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

Im1 = zeros(ZF,ZF,ReconPars0.slices,ReconPars0.blocks,ReconPars0.nrcvrs);
for m = 1:ReconPars0.slices
    for n = 1:ReconPars0.blocks
        for p = 1:ReconPars0.nrcvrs
            Dat = Dat0(:,:,m,n,p).';
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
            if Ksz > ZF
                err.flag = 1;
                err.msg = ['Zero-Fill is to small. Ksz = ',num2str(Ksz)];
                return
            end
            if rem(ZF/SS,1) && strcmp(returnfov,'Yes')
                err.flag = 1;
                err.msg = 'ZF*SS must be a integer';
                return
            end

            %---------------------------------------------
            % Zero Fill / FT
            %---------------------------------------------
            Status2('busy','Zero-Fill / FT',2);
            GrdDat = ifftshift(GrdDat);
            sz = size(GrdDat);
            if sz(1) ~= ZF 
                GrdDat = zerofill_isotropic2D_odd_doubles(GrdDat,ZF);
            end
            Im = fftshift(ifftn(GrdDat));

            %---------------------------------------------
            % Inverse Filter
            %---------------------------------------------
            Im = Im./IFprms.V;

            %---------------------------------------------
            % Array
            %---------------------------------------------    
            Im1(:,:,m,n,p) = Im;
        end
    end
end
Im = Im1;

%---------------------------------------------
% ReturnFov
%---------------------------------------------
if strcmp(returnfov,'Yes')
    bot = ZF*(SS-1)/(2*SS)+1;
    top = ZF*(SS+1)/(2*SS);
    bot = floor(bot);
    top = ceil(top);
    Im = Im(bot:top,bot:top,:,:,:);
    sz = ZF/SS; 
else
    sz = ZF; 
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
Im = ORNT.Im;
ReconPars = ORNT.ReconPars;
clear INPUT;
clear ORNT;

%--------------------------------------------
% Panel
%--------------------------------------------
% Panel(1,:) = {'ImFoV_LR',ReconPars.ImfovLR,'Output'};
% Panel(2,:) = {'ImFoV_TB',ReconPars.ImfovTB,'Output'};
% Panel(3,:) = {'ImSz_LR',ReconPars.ImszLR,'Output'};
% Panel(4,:) = {'ImSz_TB',ReconPars.ImszTB,'Output'};
Panel(1,:) = {'ImMaxVal',max(abs(Im(:))),'Output'};
Panel(2,:) = {'kSz0',Ksz,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);

%---------------------------------------------
% Remove GrdDat (no need to save)
%---------------------------------------------
GRD = rmfield(GRD,'GrdDat');

%---------------------------------------------
% Return
%---------------------------------------------
IC.Im = Im;
IC.ReconPars = ReconPars;
IC.PanelOutput = PanelOutput;

Status2('done','',2);
Status2('done','',3);
