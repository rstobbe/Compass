%=====================================================
% 
%=====================================================

function [DATORG,err] = DataOrg_AsIs_v1d_Func(DATORG,INPUT)

Status2('busy','Data Organization',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IC = INPUT.IC;
SDC = IC.SDC;
PROJimp = IC.IMP.PROJimp;
TORD = IC.IMP.TORD;
FIDmat = INPUT.FID.FIDmat;
RECON = INPUT.RECON;
clear INPUT

%---------------------------------------------
% Data Array Setup
%---------------------------------------------
Nproj = length(FIDmat(:,1,1,1,1));
Npro = length(FIDmat(1,:,1,1,1));
Nexp = length(FIDmat(1,1,:,1,1));
Nrcvrs = length(FIDmat(1,1,1,:,1));
Naverages = length(FIDmat(1,1,1,1,:));  

%---------------------------------------------
% Data Organization
%---------------------------------------------
projsampscnr = TORD.projsampscnr;
sz = size(FIDmat);
if sz(1) ~= length(projsampscnr)
    error;          
end

%---------------------------------------------
% Reconstruction
%---------------------------------------------        
func = str2func([RECON.method,'_Func']);  
INPUT.IC = IC;
clear IC
INPUT.IC = rmfield(INPUT.IC,{'SDC',});

INPUT.Dat = zeros(PROJimp.nproj,Npro,Nexp,Nrcvrs,Naverages);
INPUT.Dat(projsampscnr,:,:,:,:) = FIDmat;
clear FIDmat
INPUT.SDC = SDC;
clear SDC

[RECON,err] = func(RECON,INPUT);
if err.flag
    return
end

%---------------------------------------------
% Return
%---------------------------------------------    
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',DATORG.method,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
DATORG.PanelOutput = [PanelOutput;RECON.PanelOutput];

DATORG.Im = RECON.Im;
RECON = rmfield(RECON,'Im');
DATORG.RECON = RECON;
clear INPUT;  

