%=====================================================
% 
%=====================================================

function [DATORG,err] = DataOrg_AsIs_v1c_Func(DATORG,INPUT)

Status2('busy','Data Organization',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IC = INPUT.IC;
SDC = IC.SDC;
IMP = IC.IMP;
if isfield(IMP,'TORD')
    TORD = IMP.TORD;
elseif isfield(IMP,'WRTRCN')
    TORD = IMP.WRTRCN;
end
FID = INPUT.FID;
RECON = INPUT.RECON;
clear INPUT

%---------------------------------------------
% Data Organization
%---------------------------------------------
projsampscnr = TORD.projsampscnr;

%---------------------------------------------
% Data Array Setup
%---------------------------------------------
Nexp = length(FID.FIDmat(1,1,:,1,1));
Nrcvrs = length(FID.FIDmat(1,1,1,:,1));
Naverages = length(FID.FIDmat(1,1,1,1,:));   

sz = size(FID.FIDmat);
if sz(1) ~= length(projsampscnr)
    error;          
end

%---------------------------------------------
% Reconstruction
%---------------------------------------------        
func = str2func([RECON.method,'_Func']);  
INPUT.IC = IC;
INPUT.IC = rmfield(INPUT.IC,{'SDC',});
for n = 1:Naverages
    DatMat = zeros(IMP.PROJimp.nproj,IMP.PROJimp.npro,Nexp,Nrcvrs);
    DatMat(projsampscnr,:,:,:) = FID.FIDmat(:,:,:,:,n);
    INPUT.Dat = DatMat.*repmat(SDC,1,1,Nexp,Nrcvrs);
    [RECON,err] = func(RECON,INPUT);
    if err.flag
        return
    end
    if n == 1
        sz = size(RECON.Im);
        if length(sz) < 4
            sz(4) = 1;
        end
        if length(sz) < 5
            sz(5) = 1;
        end
        Im = zeros([sz Naverages]);
    end
    Im(:,:,:,:,:,n) = RECON.Im;
end

%---------------------------------------------
% Return
%---------------------------------------------    
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',DATORG.method,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
DATORG.PanelOutput = [PanelOutput;RECON.PanelOutput];

DATORG.Im = Im;
RECON = rmfield(RECON,'Im');
DATORG.RECON = RECON;
clear INPUT;  


