%=========================================================
% 
%=========================================================

function [MOTCOR,err] = RotCorOnlyMSYB_v1a_Func(MOTCOR,INPUT)

Status2('busy','Correct for Rotation (MSYB)',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
KSMP = INPUT.KSMP;
IMP = INPUT.IMP;
arrSDC = INPUT.SDC;
arrDAT = KSMP.SampDat;
IMG = MOTCOR.IMG;
ROTCOR = MOTCOR.ROTCOR;
Kmat = IMP.Kmat;
clear INPUT;

%---------------------------------------------
% Get Variables
%---------------------------------------------
trajmax = MOTCOR.trajmax;       
kstep = IMP.impPROJdgn.kstep;
nproj = IMP.PROJimp.nproj;

%---------------------------------------------
% Compensate Data
%---------------------------------------------
arrDAT = arrDAT.*arrSDC;
[DAT] = DatArr2Mat(arrDAT,IMP.PROJimp.nproj,IMP.PROJimp.npro);

%---------------------------------------------
% Isolate Centre
%---------------------------------------------
rad = (sqrt(Kmat(:,:,1).^2 + Kmat(:,:,2).^2 + Kmat(:,:,3).^2))/kstep;
rad = mean(rad,1);
subnpro = find(rad < (trajmax),1,'last');
subkmax = rad(subnpro)*kstep;
subKmat = Kmat(:,1:subnpro,:);
subDAT = DAT(:,1:subnpro,:);

%---------------------------------------------
% Low-Res Image Creation Setup
%---------------------------------------------
IMP1 = IMP;
IMP1.PROJimp.nproj = 1;
IMP1.PROJimp.npro = subnpro;
IMP1.impPROJdgn.kmax = subkmax;
imagefunc = str2func([MOTCOR.imagefunc,'_Func']);

%---------------------------------------------
% Create Low-Res Images
%---------------------------------------------
for n = 1:nproj
    %-----------------------------------------
    % Isolate Each Trajectory
    DAT1 = subDAT(n,:);
    Kmat1 = subKmat(n,:,:);
    IMP1.Kmat = Kmat1;    

    %-----------------------------------------
    % Grid Each Trajectory
    INPUT.IMP = IMP1;
    INPUT.DAT = DAT1;
    [IMG,err] = imagefunc(IMG,INPUT);
    if err.flag
        return
    end
    %-----------------------------------------
    % Store 
    if n == 1
        [x,y,z] = size(IMG.Im);
        ImsLowRes = zeros(nproj,x,y,z);
    end    
    Im = flipdim(IMG.Im,1);         % only for simulation (should fix ksamp)
    Im = flipdim(Im,2);
    Im = flipdim(Im,3);    
    ImsLowRes(n,:,:,:) = abs(Im);
end    

%---------------------------------------------
% Normalize
%---------------------------------------------
ImsLowRes = ImsLowRes/max(ImsLowRes(:));

%---------------------------------------------
% Rotation Correction
%---------------------------------------------
clear INPUT
INPUT.IMP = IMP;
INPUT.ImsLowRes = ImsLowRes;
INPUT.MOTCOR = MOTCOR;
INPUT.KSMP = KSMP;
func = str2func([MOTCOR.rotcorfunc,'_Func']);
[ROTCOR,err] = func(ROTCOR,INPUT);
if err.flag
    return
end
Kmat = ROTCOR.Kmat;
ROTCOR = rmfield(ROTCOR,'Kmat');

%--------------------------------------------
% Return
%--------------------------------------------
MOTCOR.SampDat = [];
MOTCOR.Kmat = Kmat;
MOTCOR.ROTCOR = ROTCOR;

Status2('done','',2);
Status2('done','',3);


