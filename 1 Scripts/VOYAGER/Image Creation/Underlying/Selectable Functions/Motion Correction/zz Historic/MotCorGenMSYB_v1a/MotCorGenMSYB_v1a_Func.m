%=========================================================
% 
%=========================================================

function [MOTCOR,err] = MotCorMSYB_v1a_Func(MOTCOR,INPUT)

Status('busy','Correct for Motion');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Underlying Functions
%---------------------------------------------
func = str2func('GridkSpace_Pioneer_v1a_Func');  

%---------------------------------------------
% Get Input
%---------------------------------------------
DAT = INPUT.DAT;
IMP = INPUT.IMP;
GRD = MOTCOR.GRD;
Kmat = IMP.Kmat;
clear INPUT;

%---------------------------------------------
% Get Variables
%---------------------------------------------
subdiam = 5;       % fix to be input
kstep = IMP.impPROJdgn.kstep;
nproj = IMP.PROJimp.nproj;

%---------------------------------------------
% Isolate Centre
%---------------------------------------------
rad = (sqrt(Kmat(:,:,1).^2 + Kmat(:,:,2).^2 + Kmat(:,:,3).^2))/kstep;
rad = mean(rad,1);
subnpro = find(rad < (subdiam/2),1,'last');
subkmax = rad(subnpro)*kstep;
subKmat = Kmat(:,1:subnpro,:);
subDAT = DAT(:,1:subnpro,:);

%---------------------------------------------
% Determine Linear Motion
%---------------------------------------------
IMP.PROJimp.nproj = 1;
IMP.PROJimp.npro = subnpro;
IMP.impPROJdgn.kmax = subkmax;

for n = 1:nproj
    %----------------------------------------------
    % Isolate Each Trajectory
    DAT1 = subDAT(n,:);
    Kmat1 = subKmat(n,:,:);
    IMP.Kmat = Kmat1;    

    %----------------------------------------------
    % Grid Each Trajectory
    INPUT.IMP = IMP;
    INPUT.DAT = DAT1;
    INPUT.GRD = GRD;
    GRD.type = 'complex';
    [GRD,err] = func(GRD,INPUT);
    if err.flag
        return
    end
    clear INPUT;
    GrdDat1Traj = GRD.GrdDat;
    Ksz = GRD.Ksz;

    %----------------------------------------------
    % Isolate Centre
    Cen = (Ksz+1)/2;
    Crad = 1;
    CkSpace = GrdDat1Traj(Cen-Crad:Cen+Crad,Cen-Crad:Cen+Crad,Cen-Crad:Cen+Crad);

    %---------------------------------------------
    % Extract Linear Motion
    if n == 1
        phCkSpace1 = angle(CkSpace);
        phslp(1) = 0;
    %---------------------------------------------
    % Extract Motion
    elseif n > 1
        phCkSpace = angle(CkSpace);
        phdif = phCkSpace - phCkSpace1;

        %---------------------------------------------
        % Phase Ramp X
        meanXYphdif = mean(phdif,3);
        meanXphdif = mean(meanXYphdif,1);
        t = [-1 0 1];
        [r,phslp(n),pfoffset] = regression(t,meanXphdif);
        Xarr = (-Cen+1:Cen-1)*phslp(n);
        figure(100); hold on; plot(Xarr);
        
        %---------------------------------------------
        % Test     
        dotest = 0;
        if dotest == 1
            [Xcomp,~,~] = meshgrid(Xarr,zeros(1,Ksz),zeros(1,Ksz));
            GrdDat1Traj = GrdDat1Traj.*exp(-1i*Xcomp);
            testCkSpace = GrdDat1Traj(Cen-Crad:Cen+Crad,Cen-Crad:Cen+Crad,Cen-Crad:Cen+Crad);
            testphCkSpace = angle(testCkSpace);
            testphdif = testphCkSpace - phCkSpace1;
            meanXYphdif = mean(testphdif,3);
            meanXphdif = mean(meanXYphdif,1);
            t = [-1 0 1];
            [r,m,b] = regression(t,meanXphdif);
            if abs(m*1e6) > 1
                error();
            end
        end   
    end
end

%--------------------------------------------
% Compensate Data
%--------------------------------------------
for n = 1:nproj
    Kx = Kmat(n,:,2)/kstep;
    figure(101); hold on; plot(Kx,angle(exp(-1i*phslp(n)*Kx)));
    DAT(n,:) = DAT(n,:).*exp(-1i*phslp(n)*Kx);
end

%--------------------------------------------
% Return
%--------------------------------------------
MOTCOR.DAT = DAT;

Status2('done','',2);
Status2('done','',3);



%====================================================
% Plot kSpace
%====================================================
function PlotkSpace(kSpace,fighnd) 

sz = size(kSpace);
rows = floor(sqrt(sz(3))); 
IMSTRCT.type = 'real';
minval = -max(abs(kSpace(:)));
maxval = max(abs(kSpace(:)));
%IMSTRCT.type = 'phase';
%minval = -pi/5;
%maxval = pi/5;
IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = sz(3); 
IMSTRCT.rows = rows; IMSTRCT.lvl = [minval maxval]; IMSTRCT.SLab = 0; IMSTRCT.figno = fighnd; 
IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap4'; 
IMSTRCT.figsize = [1000 1000];
AxialMontage_v2a(kSpace,IMSTRCT);  