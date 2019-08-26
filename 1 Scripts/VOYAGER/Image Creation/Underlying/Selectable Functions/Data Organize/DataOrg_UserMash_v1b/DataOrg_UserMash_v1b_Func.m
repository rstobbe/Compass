%=====================================================
% 
%=====================================================

function [DATORG,err] = DataOrg_UserMash_v1b_Func(DATORG,INPUT)

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
FID = INPUT.FID;
RECON = INPUT.RECON;
clear INPUT

%---------------------------------------------
% Load User Mash File
%---------------------------------------------
UserMash = [];
load(DATORG.UserMashFile.loc);

%---------------------------------------------
% Data Array Setup
%---------------------------------------------
Nproj = length(FID.FIDmat(:,1,1,1,1));
Npro = length(FID.FIDmat(1,:,1,1,1));
Nexp = length(FID.FIDmat(1,1,:,1,1));
Nrcvrs = length(FID.FIDmat(1,1,1,:,1));
Naverages = length(FID.FIDmat(1,1,1,1,:));  

%---------------------------------------------
% Data Organization
%---------------------------------------------
projsampscnr = TORD.projsampscnr;
sz = size(FID.FIDmat);
if sz(1) ~= length(projsampscnr)
    error;          
end

%---------------------------------------------
% Traj/Ave Use
%---------------------------------------------
FIDmat = zeros([Nproj,Npro,Nexp,Nrcvrs]);
multiusearray = zeros([Nproj,1]);
for n = 1:length(UserMash)
    FIDmat(UserMash(n,1),:,:,:) = FIDmat(UserMash(n,1),:,:,:) + FID.FIDmat(UserMash(n,1),:,:,:,UserMash(n,2));
    multiusearray(UserMash(n,1)) = multiusearray(UserMash(n,1)) + 1;
end
multiusearray(multiusearray == 0) = 1;
for n = 1:Nproj
    FIDmat(n,:,:,:) = FIDmat(n,:,:,:)/multiusearray(n);
end
clear FID

%---------------------------------------------
% Reconstruction
%---------------------------------------------        
func = str2func([RECON.method,'_Func']);  
INPUT.IC = IC;
clear IC
INPUT.IC = rmfield(INPUT.IC,{'SDC',});

INPUT.Dat = zeros(PROJimp.nproj,Npro,Nexp,Nrcvrs);
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


