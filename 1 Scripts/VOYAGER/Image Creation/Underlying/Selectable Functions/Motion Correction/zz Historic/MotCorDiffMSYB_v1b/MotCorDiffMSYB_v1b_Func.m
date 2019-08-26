%=========================================================
% 
%=========================================================

function [MOTCOR,err] = MotCorDiffMSYB_v1b_Func(MOTCOR,INPUT)

Status2('busy','Correct for Total Motion During Diffusion Sequence',2);
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
KSHFTCOR = MOTCOR.KSHFTCOR;
TRANSCOR = MOTCOR.TRANSCOR;
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
rad = mean(rad,1);
subnpro = find(rad < (trajmax),1,'last');
subkmax = rad(subnpro)*kstep;
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

%***
nproj = 2;
%***

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
% kShift Function
%---------------------------------------------
clear INPUT
INPUT.IMP = IMP;
INPUT.GrdDatCen = GrdDatCen;
INPUT.MOTCOR = MOTCOR;
INPUT.KSMP = KSMP;
func = str2func([MOTCOR.kshftcorfunc,'_Func']);
[KSHFTCOR,err] = func(KSHFTCOR,INPUT);
if err.flag
    return
end
KshftCorKmat = KSHFTCOR.Kmat;
KSHFTCOR = rmfield(KSHFTCOR,'Kmat');

%---------------------------------------------
% Re-Isolate Centre
%---------------------------------------------
rad = (sqrt(Kmat(:,:,1).^2 + Kmat(:,:,2).^2 + Kmat(:,:,3).^2))/kstep;
rad = mean(rad,1);
subnpro = find(rad < (trajmax),1,'last');
subkmax = rad(subnpro)*kstep;
subKmat = Kmat(:,1:subnpro,:);
subDAT = DAT(:,1:subnpro,:);




%--------------------------------------------
% Return
%--------------------------------------------
MOTCOR.DAT = DAT;
MOTCOR.Kmat = Kmat;
MOTCOR.KSHFTCOR = KSHFTCOR;

Status2('done','',2);
Status2('done','',3);


