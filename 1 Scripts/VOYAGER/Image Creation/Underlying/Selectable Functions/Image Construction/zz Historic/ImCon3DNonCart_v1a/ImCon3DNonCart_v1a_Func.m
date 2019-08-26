%=========================================================
% 
%=========================================================

function [IC,err] = ImCon3DNonCart_v1a_Func(IC,INPUT)

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
ORNT = IC.ORNT;
RFOV = IC.RFOV;
process = INPUT.func;
clear INPUT;

switch process
    
    %==================================================
    % Load Implementation Data
    %==================================================
    case 'ImpLoad'
        func = str2func([IC.imploadfunc,'_Func']);  
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
        func = str2func([IC.reconfunc,'_Func']);  
        INPUT.FID = FID;
        INPUT.IC = IC;
        [RECON,err] = func(RECON,INPUT);
        if err.flag
            return
        end
        Im = RECON.Im;
        RECON = rmfield(RECON,'Im');
        ReconPars = RECON.ReconPars;
        clear INPUT;  

        %---------------------------------------------
        % Orient
        %---------------------------------------------
        func = str2func([IC.orientfunc,'_Func']);  
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
        func = str2func([IC.returnfovfunc,'_Func']);  
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
        IC = rmfield(IC,{'IFprms','GRD','ORNT','RFOV','RECON','IMPLD','IMP','SDC'});

        %---------------------------------------------
        % Return
        %---------------------------------------------
        IC.Im = Im;
        IC.ReconPars = ReconPars;
        IC.PanelOutput = RECON.PanelOutput;
end

Status2('done','',2);
Status2('done','',3);
