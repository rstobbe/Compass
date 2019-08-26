%=========================================================
% 
%=========================================================

function [IC,err] = ImConst_3DNonCart_v1d_Func(IC,INPUT)

Status2('busy','Create Image 3D Non-Cartesian',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
FID = INPUT.FID;
IMPLD = IC.IMPLD;
RECON = IC.RECON;
DATORG = IC.DATORG;
ORNT = IC.ORNT;
RFOV = IC.RFOV;
process = INPUT.func;
clear INPUT;

switch process
    
    %==================================================
    % Load Implementation Data
    %==================================================
    case 'ImpLoad'
        func = str2func([IMPLD.method,'_Func']);  
        INPUT.FID = FID;
        [IMPLD,err] = func(IMPLD,INPUT);
        if err.flag
            return
        end
        IC.IMP = IMPLD.IMP;
        IC.SDC = IMPLD.SDC;
        clear INPUT;  

    %==================================================
    % Construct Image
    %==================================================
    case 'Create'

        %---------------------------------------------
        % Data Array Setup
        %---------------------------------------------
        Nexp = length(FID.FIDmat(1,1,:,1,1));
        Nrcvrs = length(FID.FIDmat(1,1,1,:,1));
        Naverages = length(FID.FIDmat(1,1,1,1,:));        
        
        %---------------------------------------------
        % Organize Data
        %---------------------------------------------
        func = str2func([IC.dataorgfunc,'_Func']);  
        INPUT.FID = FID;
        INPUT.IMPLD = IMPLD;
        [DATORG,err] = func(DATORG,INPUT);
        if err.flag
            return
        end  
        clear INPUT;         
        clear IMPLD;
        IC = rmfield(IC,{'IMPLD'});
        
        sz = size(FID.FIDmat);
        if sz(1) ~= length(DATORG.projsampscnr(:))
            error;          % probably needs cases added
        end
        
        %---------------------------------------------
        % Reconstruction
        %---------------------------------------------        
        func = str2func([IC.reconfunc,'_Func']);  
        INPUT.IC = IC;
        INPUT.IC.IMP.PROJimp.npro = DATORG.npro;
        INPUT.IC.IMP.Kmat = IC.IMP.Kmat(:,1:DATORG.npro,:);
        INPUT.IC = rmfield(INPUT.IC,{'SDC',});
        whos
        p = 1;
        TotalSeriesNum = Naverages*DATORG.subarrlen;
        for n = 1:Naverages
            for m = 1:DATORG.subarrlen
                DatMat = zeros(IC.IMP.PROJimp.nproj,IC.IMP.PROJimp.npro,Nexp,Nrcvrs);
                DatMat(DATORG.projsampscnr(:,m),:,:,:) = FID.FIDmat((m-1)*DATORG.trajpersweep+1:m*DATORG.trajpersweep,:,:,:,n);
                if DATORG.subarrlen == 1 && Naverages == 1
                    clear FID
                end
                DatMat = DatMat(:,1:DATORG.npro,:,:);
                INPUT.Dat = DatMat.*repmat(IC.SDC(:,1:DATORG.npro),1,1,Nexp,Nrcvrs);
                clear DatMat;
                %whos
                [RECON,err] = func(RECON,INPUT);
                if err.flag
                    return
                end
                if p == 1
                    sz = size(RECON.Im);
                    if length(sz) < 4
                        sz(4) = 1;
                    end
                    if length(sz) < 5
                        sz(5) = 1;
                    end
                    Im = zeros([sz TotalSeriesNum]);
                end
                Im(:,:,:,:,:,p) = RECON.Im;
                p = p+1;
            end
        end
        RECON = rmfield(RECON,'Im');
        ReconPars = RECON.ReconPars;
        clear INPUT;  

        %---------------------------------------------
        % Orient
        %---------------------------------------------
        func = str2func([ORNT.method,'_Func']);  
        INPUT.Im = Im;
        INPUT.IMP = IC.IMP;
        INPUT.ReconPars = ReconPars;
        [ORNT,err] = func(ORNT,INPUT);
        if err.flag
            return
        end
        Im = ORNT.Im;
        ORNT = rmfield(ORNT,'Im');
        ReconPars = ORNT.ReconPars;
        clear INPUT;

        %---------------------------------------------
        % FoV
        %---------------------------------------------
        func = str2func([RFOV.method,'_Func']);  
        INPUT.Im = Im;
        INPUT.IMP = IC.IMP;
        INPUT.ReconPars = ReconPars;
        [RFOV,err] = func(RFOV,INPUT);
        if err.flag
            return
        end
        Im = RFOV.Im;
        RFOV = rmfield(RFOV,'Im');
        ReconPars = RFOV.ReconPars;
        clear INPUT;

        %---------------------------------------------
        % Remove GrdDat (no need to save)
        %---------------------------------------------
        IC = rmfield(IC,{'IFprms','GRD','ORNT','RFOV','RECON','IMP','SDC'});

        %---------------------------------------------
        % Return
        %---------------------------------------------
        IC.Im = Im;
        IC.ReconPars = ReconPars;
        IC.PanelOutput = RECON.PanelOutput;
end

Status2('done','',2);
Status2('done','',3);
