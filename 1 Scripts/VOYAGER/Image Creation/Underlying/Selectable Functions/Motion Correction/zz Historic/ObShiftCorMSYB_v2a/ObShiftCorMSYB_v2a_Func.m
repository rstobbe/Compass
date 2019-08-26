%=========================================================
% 
%=========================================================

function [OBSHFT,err] = ObShiftCorMSYB_v2a_Func(OBSHFT,INPUT)

Status2('busy','Correct for Object Shifts Between Trajectories (MSYB)',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
KSMP = INPUT.KSMP;
%rot0 = KSMP.ROT.rot0;
trans0 = KSMP.TRANS.translations;
IMP = INPUT.IMP;
arrSDC = INPUT.SDC;
arrDAT = KSMP.SampDat;
IMG = OBSHFT.IMG;
OBSHFTREG = OBSHFT.OBSHFTREG;
Kmat = IMP.Kmat;
clear INPUT;

%---------------------------------------------
% Get Variables
%---------------------------------------------
trajmax = OBSHFT.trajmax; 
imthresh = OBSHFT.imthresh;
kstep = IMP.impPROJdgn.kstep;
vox = IMP.impPROJdgn.vox;
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
imagefunc = str2func([OBSHFT.imagefunc,'_Func']);
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
regfunc = str2func([OBSHFT.obshftregfunc,'_Reg']);
options = optimset( 'Algorithm','trust-region-reflective',...
                    'Display','iter','Diagnostics','on',...
                    'FinDiffType','forward',...    
                    'DiffMinChange',0.01,...
                    'TolFun',1e-6,...
                    'TolX',0.01);
lb = [];
ub = [];

%---------------------------------------------
% Create Low-Res Images
%---------------------------------------------
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
    %INPUT.scale = [0.1 0.1 0.1 1 1 1];
    INPUT.scale = [100 100 100];
    func = @(V)regfunc(V,OBSHFTREG,INPUT);
    
    %-----------------------------------------
    % Regression
    %V0 = [0 0 0 0 0 0];
    V0 = [0 0 0];
    %[V,resnorm,residual,exitflag,output,lambda,jacobian] = lsqnonlin(func,V0);
    [V,resnorm,residual,exitflag,output,lambda,jacobian] = lsqnonlin(func,V0,lb,ub,options);
    %ni = nlparci(V,residual,jacobian)

    V = V.*INPUT.scale;
    
    transcor(n,1:3) = V(1:3);
    %rotcor(n,1:3) = V(4:6);
    
    %-----------------------------------------
    % Compare Angles 
    %figure(400); hold on;
    %plot(n,rotcor(n,1),'b*'); plot(n,rot0(n,1),'bo');
    %plot(n,rotcor(n,2),'r*'); plot(n,rot0(n,2),'ro');
    %plot(n,rotcor(n,3),'g*'); plot(n,rot0(n,3),'go');  
    
    figure(401); hold on;
    plot(n,transcor(n,1),'b*'); plot(n,trans0(n,1),'bo');
    plot(n,transcor(n,2),'r*'); plot(n,trans0(n,2),'ro');
    plot(n,transcor(n,3),'g*'); plot(n,trans0(n,3),'go');     
    
end    

%--------------------------------------------
% Return
%--------------------------------------------
OBSHFT.SampDat = [];
OBSHFT.Kmat = Kmat;
OBSHFT.OBSHFTREG = OBSHFTREG;

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

