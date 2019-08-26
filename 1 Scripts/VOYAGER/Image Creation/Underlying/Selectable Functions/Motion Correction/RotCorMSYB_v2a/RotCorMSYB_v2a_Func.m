%=========================================================
% 
%=========================================================

function [ROTCOR,err] = RotCorMSYB_v2a_Func(ROTCOR,INPUT)

Status2('busy','Correct for Rotation Between Trajectories (MSYB)',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
KSMP = INPUT.KSMP;
rot0 = KSMP.ROT.rot0;
IMP = INPUT.IMP;
Kmat = IMP.Kmat;
IMPCOR = INPUT.IMPCOR;
KmatCor = IMPCOR.Kmat;
arrSDC = INPUT.SDC;
arrDAT = KSMP.SampDat;
IMG = ROTCOR.IMG;
ROTCORREG = ROTCOR.ROTCORREG;
clear INPUT;

%---------------------------------------------
% Get Variables
%---------------------------------------------
trajmax = ROTCOR.trajmax; 
imthresh = ROTCOR.imthresh;
rottol = ROTCOR.rottol;
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
subKmat = KmatCor(:,1:subnpro,:);
subrad = sqrt(subKmat(:,:,1).^2 + subKmat(:,:,2).^2 + subKmat(:,:,3).^2);
subkmax = max(subrad(:));
%subkmaxOrig = rad(subnpro)*kstep;
subDAT = DAT(:,1:subnpro);

%---------------------------------------------
% Low-Res Image Creation Setup
%---------------------------------------------
IMP1 = IMP;
IMP1.PROJimp.nproj = 1;
IMP1.PROJimp.npro = subnpro;
IMP1.impPROJdgn.kmax = subkmax;

%---------------------------------------------
% Reference Image From First Trajectory
%---------------------------------------------
DAT1 = subDAT(1,:);
IMP1.Kmat = subKmat(1,:,:);   
INPUT.IMP = IMP1;
INPUT.DAT = DAT1;
imagefunc = str2func([ROTCOR.imagefunc,'_Func']);
[IMG,err] = imagefunc(IMG,INPUT);
if err.flag
    return
end 
Im0 = abs(IMG.Im);
Im0 = flipdim(Im0,1);         % only for simulation (should fix ksamp)
Im0 = flipdim(Im0,2);
Im0 = flipdim(Im0,3);    
Im0 = Im0/max(Im0(:));
Im0(Im0 < imthresh) = 0;
PlotImage(Im0,'abs',0,1,100); 

%---------------------------------------------
% Regression Setup
%---------------------------------------------
regfunc = str2func([ROTCOR.rotcorregfunc,'_Reg']);
options = optimset( 'Algorithm','trust-region-reflective',...
                    'Display','iter','Diagnostics','on',...
                    'FinDiffType','forward',...                  % forward    
                    'DiffMinChange',0.025,...                    % 0.01 (0.025)
                    'TolFun',1e-6,...
                    'TolX',rottol);
lb = [];
ub = [];

%---------------------------------------------
% Create Low-Res Images
%---------------------------------------------
rotcor = zeros(nproj,3);
resnorm = zeros(nproj,1);
exitflag = zeros(nproj,1);
CI = ones(nproj,3,2);
for n = 2:nproj
    %-----------------------------------------
    % Isolate Each Trajectory
    DAT1 = squeeze(subDAT(n,:));
    IMP1.Kmat = squeeze(subKmat(n,:,:));   
    INPUT.IMG = IMG;
    INPUT.IMP = IMP1;
    INPUT.DAT = DAT1;
    INPUT.Im0 = Im0;
    INPUT.imthresh = imthresh;
    INPUT.imagefunc = imagefunc;
    func = @(V)regfunc(V,ROTCORREG,INPUT);
    
    %-----------------------------------------
    % Regression
    V0 = [0 0 0];
    [V,resnorm(n),residual,exitflag(n),output(n),~,jacobian] = lsqnonlin(func,V0,lb,ub,options);
    %ci = nlparci(V,residual,jacobian);
    %CI(n,:,:) = ci;
    rotcor(n,1:3) = V(1:3);
    
    %-----------------------------------------
    % Compare Angles 
    figure(400); hold on;
    plot(n,rotcor(n,1),'bx'); plot(n,rot0(n,1),'bo');
    plot(n,rotcor(n,2),'rx'); plot(n,rot0(n,2),'ro');
    plot(n,rotcor(n,3),'gx'); plot(n,rot0(n,3),'go');  
end    

%---------------------------------------------
% show exit flags
%---------------------------------------------
%exitflags = exitflag

%---------------------------------------------
% Calculate Standard Deviation of Rotations
%---------------------------------------------
stdrotations = std(rotcor(:));

%---------------------------------------------
% mean square error
%---------------------------------------------
meansqrerr = sum(sum((rotcor - rot0).^2))

%---------------------------------------------
% Correct Trajectories
%---------------------------------------------
rotKmat = zeros(size(KmatCor));
rotKmat(1,:,:) = KmatCor(1,:,:);
for a = 2:nproj
    Status2('busy',['Correct Trajectory: ',num2str(a)],2);
    Karr = permute(squeeze(KmatCor(a,:,:)),[2 1]);
    Karr = Rotate3DPoints_v1a(Karr,rotcor(a,1),rotcor(a,2),rotcor(a,3));
    rotKmat(a,:,:) = permute(Karr,[2 1]);
end

%--------------------------------------------
% Return
%--------------------------------------------
ROTCOR.Kmat = rotKmat;
ROTCOR.rot0 = rot0;
ROTCOR.rotcor = rotcor;
ROTCOR.stdrotations = stdrotations;
ROTCOR.meansqrerr = meansqrerr;
ROTCOR.resnorm = resnorm;
ROTCOR.exitflag = exitflag;
ROTCOR.output = output;
ROTCOR.CI = CI;
ROTCOR.ROTCORREG = ROTCORREG;

Status2('done','',2);
Status2('done','',3);



%====================================================
% Plot Image
%====================================================
function PlotImage(Im,type,min,max,fighnd) 

sz = size(Im);
rows = floor(sqrt(sz(3))); 
IMSTRCT.type = type; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = sz(3); 
IMSTRCT.rows = rows; IMSTRCT.lvl = [min max]; IMSTRCT.SLab = 0; IMSTRCT.figno = fighnd; 
IMSTRCT.docolor = 0; IMSTRCT.ColorMap = 'ColorMap4'; 
IMSTRCT.figsize = [500 500];
AxialMontage_v2a(Im,IMSTRCT);  

