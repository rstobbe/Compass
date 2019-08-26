%=========================================================
% 
%=========================================================

function [IC,err] = ImConst_3DNonCart_v1f_Func(IC,INPUT)

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
        % Recon inside DataOrg loop
        %---------------------------------------------
        func = str2func([DATORG.method,'_Func']);  
        INPUT.FID = FID;
        INPUT.IC = IC;
        INPUT.RECON = RECON;
        [DATORG,err] = func(DATORG,INPUT);
        if err.flag
            return
        end  
        clear INPUT;         
        Im = DATORG.Im;
        RECON = DATORG.RECON;
        ReconPars = DATORG.RECON.ReconPars;
        DATORG = rmfield(DATORG,{'RECON','Im'});
        IC.DATORG = DATORG;
        IC.RECON = RECON;
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
        IC.ORNT = ORNT;
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
        IC.RFOV = RFOV;
        ReconPars = RFOV.ReconPars;
        clear INPUT;

        %---------------------------------------------
        % Remove GrdDat (no need to save)
        %---------------------------------------------
        IC = rmfield(IC,{'IFprms','GRD','IMP','SDC'});

        %---------------------------------------------
        % Return
        %---------------------------------------------
        IC.Im = Im;
        IC.ReconPars = ReconPars;
        IC.PanelOutput = DATORG.PanelOutput;
end

Status2('done','',2);
Status2('done','',3);
