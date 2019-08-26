%=========================================================
% 
%=========================================================

function [MOTCOR,err] = TranskShiftFollowMSYB_v1a_Func(MOTCOR,INPUT)

Status2('busy','Correct for Tranlational Motion',2);
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
GRD = MOTCOR.GRD;
TRANSCOR = MOTCOR.TRANSCOR;
Kmat = IMP.Kmat;
clear INPUT;

%---------------------------------------------
% Get Variables
%---------------------------------------------
trajmax = MOTCOR.trajmax;       
kstep = IMP.impPROJdgn.kstep;
nproj = IMP.PROJimp.nproj;
subsamp = GRD.SS;
cenrad = ceil(trajmax*subsamp);
MOTCOR.cenrad = cenrad;

%---------------------------------------------
% Compensate Data
%---------------------------------------------
arrDAT = arrDAT.*arrSDC;
[DAT] = DatArr2Mat(arrDAT,IMP.PROJimp.nproj,IMP.PROJimp.npro);

%---------------------------------------------
% Isolate Centre
%---------------------------------------------
rad = (sqrt(Kmat(:,:,1).^2 + Kmat(:,:,2).^2 + Kmat(:,:,3).^2))/kstep;
subnpro0 = find(mean(rad,1) < (trajmax),1,'last');
subnpro = 1861;
subkmax = max(max(rad(:,1:subnpro)*kstep));
subKmat = Kmat(:,1:subnpro,:);
subDAT = DAT(:,1:subnpro,:);

%---------------------------------------------
% Gridding Setup
%---------------------------------------------
IMP1 = IMP;
IMP1.PROJimp.nproj = 1;
IMP1.PROJimp.npro = subnpro;
IMP1.impPROJdgn.kmax = subkmax;
GRD.type = 'complex';
INPUT.GRD = GRD;
gridfunc = str2func([MOTCOR.gridfunc,'_Func']);
GrdDatCen = zeros(nproj,2*cenrad+1,2*cenrad+1,2*cenrad+1);

%---------------------------------------------
% Grid Central Portion of Each Trajectory
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
    [GRD,err] = gridfunc(GRD,INPUT);
    if err.flag
        return
    end
    
    PlotkSpace(GRD.GrdDat,100); 
    
    %-----------------------------------------
    % Isolate Centre   
    Ksz = GRD.Ksz;
    C = (Ksz+1)/2;
    GrdDatCen(n,:,:,:) = GRD.GrdDat(C-cenrad:C+cenrad,C-cenrad:C+cenrad,C-cenrad:C+cenrad); 
end    

%---------------------------------------------
% TransCor Function
%---------------------------------------------
clear INPUT
INPUT.IMP = IMP;
INPUT.GrdDatCen = GrdDatCen;
INPUT.MOTCOR = MOTCOR;
INPUT.KSMP = KSMP;
func = str2func([MOTCOR.transcorfunc,'_Func']);
[TRANSCOR,err] = func(TRANSCOR,INPUT);
if err.flag
    return
end
SampDat = TRANSCOR.SampDat;
TRANSCOR = rmfield(TRANSCOR,'SampDat');

%--------------------------------------------
% Return
%--------------------------------------------
MOTCOR.SampDat = SampDat;
MOTCOR.Kmat = Kmat;
MOTCOR.TRANSCOR = TRANSCOR;

Status2('done','',2);
Status2('done','',3);


%====================================================
% Plot kSpace
%====================================================
function PlotkSpace(kSpace,fighnd) 

sz = size(kSpace);
rows = floor(sqrt(sz(3))); 
%IMSTRCT.type = 'real';
%minval = -max(abs(kSpace(:)));
%maxval = max(abs(kSpace(:)));
IMSTRCT.type = 'phase';
minval = -pi;
maxval = pi;
IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = sz(3); 
IMSTRCT.rows = rows; IMSTRCT.lvl = [minval maxval]; IMSTRCT.SLab = 0; IMSTRCT.figno = fighnd; 
IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap4'; 
IMSTRCT.figsize = [600 600];
AxialMontage_v2a(kSpace,IMSTRCT);  

