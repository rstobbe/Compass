%=====================================================
% 
%=====================================================

function [DATORG,err] = DataOrg_SubSetAverageBasic_v1a_Func(DATORG,INPUT)

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
Nproj = length(FIDmat(:,1,1,1,1,1));
Npro = length(FIDmat(1,:,1,1,1,1));
Nexp = length(FIDmat(1,1,:,1,1,1));
Nrcvrs = length(FIDmat(1,1,1,:,1,1));
Naverages = length(FIDmat(1,1,1,1,:,1));  
Nechos = length(FIDmat(1,1,1,1,1,:));  

%---------------------------------------------
% Test
%---------------------------------------------
projsampscnr = TORD.projsampscnr;
sz = size(FIDmat);
if sz(1) ~= length(projsampscnr) || not(isfield(TORD,'subsetsize'))
    err.flag = 1;
    err.msg = 'DataOrg_SubSetAverage not suitable for recon';
    return         
end
if Naverages > 2
    err.flag = 1;
    err.msg = 'DataOrg_SubSetAverage only coded for 1 acquisition average';
    return 
end

ProjPerImage = TORD.subsetsize*TORD.nsets;
FIDmat2 = zeros(ProjPerImage,Npro,Nexp,Nrcvrs,TORD.averages,Nechos);
projsampscnr2 = zeros(ProjPerImage,TORD.averages);
for n = 1:TORD.nsets
    for m = 1:TORD.averages
        projsampscnr2((n-1)*TORD.subsetsize+1:n*TORD.subsetsize,m) = ... 
                projsampscnr((n-1)*TORD.subsetsize*TORD.averages+(m-1)*TORD.subsetsize+1:(n-1)*TORD.subsetsize*TORD.averages+m*TORD.subsetsize); 
        FIDmat2((n-1)*TORD.subsetsize+1:n*TORD.subsetsize,:,:,:,m,:) = ...
                FIDmat((n-1)*TORD.subsetsize*TORD.averages+(m-1)*TORD.subsetsize+1:(n-1)*TORD.subsetsize*TORD.averages+m*TORD.subsetsize,:,:,:,:,:);
    end
end
clear FIDmat
% figure(1234123); hold on;
% for n = 1:TORD.averages
%     plot(projsampscnr2(:,n))
% end

%---------------------------------------------
% Reconstruction
%---------------------------------------------        
func = str2func([RECON.method,'_Func']);  
INPUT.IC = IC;
clear IC
INPUT.IC = rmfield(INPUT.IC,{'SDC',});

INPUT.Dat = zeros(PROJimp.nproj,Npro,Nexp,Nrcvrs,TORD.averages,Nechos);
for m = 1:TORD.averages
    INPUT.Dat(projsampscnr2(:,m),:,:,:,m,:) = FIDmat2(:,:,:,:,m,:);                  % do in case different for each average
end
clear FIDmat2
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


