%=========================================================
% 
%=========================================================

function [IMG,err] = CompareSingleTrajIms_v1a_Func(INPUT)

Status('busy','Create Simulated Image');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMG = INPUT.IMG;
IMP = INPUT.IMP;
Kmat = IMP.Kmat;
arrSDC = INPUT.SDC;
arrDAT1 = INPUT.DAT1;
arrDAT2 = INPUT.DAT2;
IC = INPUT.IC;
clear INPUT;

%---------------------------------------------
% Common Variables
%---------------------------------------------
kstep = IMP.impPROJdgn.kstep;
subdiam = 9;
traj = '1';
imthresh = 0.2;

%---------------------------------------------
% Compensate Data
%---------------------------------------------
arrDAT1 = arrDAT1.*arrSDC;
[DATmat1] = DatArr2Mat(arrDAT1,IMP.PROJimp.nproj,IMP.PROJimp.npro);
arrDAT2 = arrDAT2.*arrSDC;
[DATmat2] = DatArr2Mat(arrDAT2,IMP.PROJimp.nproj,IMP.PROJimp.npro);

%---------------------------------------------
% Isolate Centre
%---------------------------------------------
rad = (sqrt(Kmat(:,:,1).^2 + Kmat(:,:,2).^2 + Kmat(:,:,3).^2))/kstep;
rad = mean(rad,1);
subnpro = find(rad < (subdiam/2),1,'last');
subkmax = rad(subnpro)*kstep;
subKmat = Kmat(:,1:subnpro,:);
subDATmat1 = DATmat1(:,1:subnpro,:);
subDATmat2 = DATmat2(:,1:subnpro,:);

%---------------------------------------------
% Isolate Proj
%---------------------------------------------
if strcmp(traj,'All')
    Kmat = subKmat;
    DAT1 = subDATmat1;
    DAT2 = subDATmat2;
else
    nproj = 1;
    %traj = str2double(traj);
    traj1 = 1;
    traj2 = 20;
    Kmat1 = subKmat(traj1,:,:);
    Kmat2 = subKmat(traj2,:,:);
    DAT1 = subDATmat1(traj1,:,:);
    DAT2 = subDATmat2(traj2,:,:);
end

%---------------------------------------------
% Consolidate
%---------------------------------------------
IMP.impPROJdgn.kmax = subkmax;
IMP.PROJimp.nproj = nproj;
IMP.PROJimp.npro = subnpro;

%----------------------------------------------
% Create Image
%----------------------------------------------
func = str2func([IMG.imagecreatefunc,'_Func']);  
IMP.Kmat = Kmat1;
INPUT.IMP = IMP;
INPUT.DAT = DAT1;
[IC,err] = func(IC,INPUT);
if err.flag
    return
end
clear INPUT;

%--------------------------------------
% Get Image in right orientation (for some reason flipped)
%--------------------------------------
Im1 = IC.Im;
IC = rmfield(IC,'Im');
Im1 = flipdim(Im1,1);
Im1 = flipdim(Im1,2);
Im1 = flipdim(Im1,3);
Im1 = abs(Im1)/max(abs(Im1(:)));
Im1(Im1 < imthresh) = 0;
PlotImage(Im1,'abs',0,1,100); 

%----------------------------------------------
% Create Image
%----------------------------------------------
func = str2func([IMG.imagecreatefunc,'_Func']);  
IMP.Kmat = Kmat2;
INPUT.IMP = IMP;
INPUT.DAT = DAT2;
[IC,err] = func(IC,INPUT);
if err.flag
    return
end
clear INPUT;

%--------------------------------------
% Get Image in right orientation (for some reason flipped)
%--------------------------------------
Im2 = IC.Im;
IC = rmfield(IC,'Im');
Im2 = flipdim(Im2,1);
Im2 = flipdim(Im2,2);
Im2 = flipdim(Im2,3);
Im2 = abs(Im2)/max(abs(Im2(:)));
Im2(Im2 < imthresh) = 0;
PlotImage(Im2,'abs',0,1,101); 

rIm2 = Rotate3DMatrix_v1c(Im2,0,0,-5);
PlotImage(rIm2,'abs',0,max(abs(rIm2(:))),102);

%---------------------------------------------
% Find Rotation
%---------------------------------------------
SrchMax = 12;
rotx = (-SrchMax:2:SrchMax);
%rotx = 0;
roty = (-SrchMax:2:SrchMax);
%roty = 0;
rotz = (-SrchMax:2:SrchMax);
%rotz = 0;

Status2('busy','Correct for Rotation',2);
for n = 1:length(rotx)
    for m = 1:length(roty)
        for p = 1:length(rotz)
            rIm2 = Rotate3DMatrix_v1c(Im2,rotx(n),roty(m),rotz(p));
            %L1err(n,m,p) = sum(rIm2(:) - Im1(:));
            L2err(n,m,p) = sum((rIm2(:) - Im1(:)).^2);
            Status2('busy',[num2str(rotx(n)),' ',num2str(roty(m)),' ',num2str(rotz(p))],3);
        end
    end
end
%figure(300); hold on;
%plot(rotz,squeeze(L2err(1,1,:)),'r')
%error(0);

RotErr = L2err;
[xind,yind,zind] = ind2sub(size(RotErr),find(RotErr == min(RotErr(:)),1));
figure(301); hold on;
plot(rotx,squeeze(RotErr(:,yind,zind)),'b:');
plot(roty,squeeze(RotErr(xind,:,zind)),'r:');
plot(rotz,squeeze(RotErr(xind,yind,:)),'g:');



%---------------------------------------------
% Return
%---------------------------------------------
IMG.Im = Im;
IMG.ImSz = IC.ImSz;
IMG.zf = IC.zf;
IMG.returnfov = IC.returnfov;
IMG.IC = IC;

Status('done','');
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
IMSTRCT.figsize = [1000 1000];
AxialMontage_v2a(Im,IMSTRCT);  

