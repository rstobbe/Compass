%=========================================================
% 
%=========================================================

function [TRANSCOR,err] = TransCorMSYB_v1a_Func(TRANSCOR,INPUT)

Status2('busy','Correct for Tranlational Motion',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
KSMP = INPUT.KSMP;
IMP = INPUT.IMP;
Kmat = IMP.Kmat;
IMPCOR = INPUT.IMPCOR;
KmatCor = IMPCOR.Kmat;
arrSDC = INPUT.SDC;
arrDAT = KSMP.SampDat;
GRD = TRANSCOR.GRD;
TRANSCORREG = TRANSCOR.TRANSCORREG;
clear INPUT;

%---------------------------------------------
% Get Variables
%---------------------------------------------
trajmax = TRANSCOR.trajmax;       
kstep = IMP.impPROJdgn.kstep;
nproj = IMP.PROJimp.nproj;
subsamp = GRD.SS;
cenrad = ceil(trajmax*subsamp);
TRANSCOR.cenrad = cenrad;

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
subKmat = KmatCor(:,1:subnpro,:);
subrad = sqrt(subKmat(:,:,1).^2 + subKmat(:,:,2).^2 + subKmat(:,:,3).^2);
subkmax = max(subrad(:));
%subkmaxOrig = rad(subnpro)*kstep;
subDAT = DAT(:,1:subnpro);

%---------------------------------------------
% Gridding Setup
%---------------------------------------------
IMP1 = IMP;
IMP1.PROJimp.nproj = 1;
IMP1.PROJimp.npro = subnpro;
IMP1.impPROJdgn.kmax = subkmax;
GRD.type = 'complex';
INPUT.GRD = GRD;
gridfunc = str2func([TRANSCOR.gridfunc,'_Func']);
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
INPUT.TRANSCOR = TRANSCOR;
INPUT.KSMP = KSMP;
func = str2func([TRANSCOR.transcorregfunc,'_Func']);
[TRANSCORREG,err] = func(TRANSCORREG,INPUT);
if err.flag
    return
end
SampDat = TRANSCORREG.SampDat;
TRANSCORREG = rmfield(TRANSCORREG,'SampDat');

%--------------------------------------------
% Return
%--------------------------------------------
TRANSCOR.SampDat = SampDat;
TRANSCOR.Kmat = Kmat;
TRANSCOR.TRANSCORREG = TRANSCORREG;

Status2('done','',2);
Status2('done','',3);


