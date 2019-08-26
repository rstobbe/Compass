%=========================================================
% 
%=========================================================

function [ROTCOR,err] = RotCorMSYB_v1a_Func(ROTCOR,INPUT)

Status2('busy','Correct for Rotation (MSYB)',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
KSMP = INPUT.KSMP;
rot0 = KSMP.ROT.rot0;
ImsLowRes = INPUT.ImsLowRes;
IMP = INPUT.IMP;
Kmat = IMP.Kmat;
clear INPUT;

%---------------------------------------------
% Get Variables
%---------------------------------------------
nproj = IMP.PROJimp.nproj;
imthresh = ROTCOR.imthresh;

%---------------------------------------------
% Correct to First Trajectory
%---------------------------------------------
Im1 = squeeze(ImsLowRes(1,:,:,:));
Im1(Im1 < imthresh) = 0;
PlotImage(Im1,'abs',0,1,100); 

%---------------------------------------------
% Find Rotations
%---------------------------------------------
CourseSrchMax = 10;
CourseSrchStep = 2.5;
FineSrchMax = 1;
FineSrchStep = 0.25;

%---------------------------------------------
% Find Rotations
%---------------------------------------------
for a = 2:nproj
    %-----------------------------------------
    % Plot Original
    Im2 = squeeze(ImsLowRes(a,:,:,:));
    pltIm2 = Im2;
    pltIm2(pltIm2 < imthresh) = 0;
    PlotImage(pltIm2,'abs',0,1,200); 

    %-----------------------------------------
    % Course Search
    rotx = (-CourseSrchMax:CourseSrchStep:CourseSrchMax);
    roty = (-CourseSrchMax:CourseSrchStep:CourseSrchMax);
    rotz = (-CourseSrchMax:CourseSrchStep:CourseSrchMax);
    
    %-----------------------------------------
    % Find Rotation Course  
    Status2('busy',['Correct for Rotation, Trajectory: ',num2str(a)],2);
    L2err = zeros(length(rotx),length(roty),length(rotz));
    for n = 1:length(rotx)
        for m = 1:length(roty)
            for p = 1:length(rotz)
                rIm2 = Rotate3DMatrix_v1c(Im2,rotx(n),roty(m),rotz(p));
                rIm2(rIm2 < imthresh) = 0;
                %L1err(n,m,p) = sum(rIm2(:) - Im1(:));
                L2err(n,m,p) = sum((rIm2(:) - Im1(:)).^2);
                Status2('busy',[num2str(rotx(n)),' ',num2str(roty(m)),' ',num2str(rotz(p))],3);
            end
        end
    end
    RotErr = L2err;
    [xind,yind,zind] = ind2sub(size(RotErr),find(RotErr == min(RotErr(:)),1));
    figure(301); hold on;
    plot(rotx,squeeze(RotErr(:,yind,zind)),'b:');
    plot(roty,squeeze(RotErr(xind,:,zind)),'r:');
    plot(rotz,squeeze(RotErr(xind,yind,:)),'g:');
    
    %-----------------------------------------
    % Interpolate
    [X,Y,Z] = meshgrid(rotx,roty,rotz);
    ceninterparr = (-CourseSrchMax:0.1:CourseSrchMax);
    [XI,YI,ZI] = meshgrid(ceninterparr,ceninterparr,ceninterparr);
    ierr = interp3(X,Y,Z,RotErr,XI,YI,ZI,'cubic');  

    [xind,yind,zind] = ind2sub(size(ierr),find(ierr == min(ierr(:)),1));
    figure(301); hold on;
    plot(ceninterparr,squeeze(ierr(:,yind,zind)),'b');
    plot(ceninterparr,squeeze(ierr(xind,:,zind)),'r');
    plot(ceninterparr,squeeze(ierr(xind,yind,:)),'g');    

    %-----------------------------------------
    % Fine Search
    rotx = (ceninterparr(xind)-FineSrchMax:FineSrchStep:ceninterparr(xind)+FineSrchMax);
    roty = (ceninterparr(yind)-FineSrchMax:FineSrchStep:ceninterparr(yind)+FineSrchMax);
    rotz = (ceninterparr(zind)-FineSrchMax:FineSrchStep:ceninterparr(zind)+FineSrchMax);
    
    %-----------------------------------------
    % Find Rotation Fine  
    Status2('busy',['Correct for Rotation, Trajectory: ',num2str(a)],2);
    L2err = zeros(length(rotx),length(roty),length(rotz));
    for n = 1:length(rotx)
        for m = 1:length(roty)
            for p = 1:length(rotz)
                rIm2 = Rotate3DMatrix_v1c(Im2,rotx(n),roty(m),rotz(p));
                rIm2(rIm2 < imthresh) = 0;
                %L1err(n,m,p) = sum(rIm2(:) - Im1(:));
                L2err(n,m,p) = sum((rIm2(:) - Im1(:)).^2);
                Status2('busy',[num2str(rotx(n)),' ',num2str(roty(m)),' ',num2str(rotz(p))],3);
            end
        end
    end
    RotErr = L2err;
    [xind,yind,zind] = ind2sub(size(RotErr),find(RotErr == min(RotErr(:)),1));
    figure(301); hold on;
    plot(rotx,squeeze(RotErr(:,yind,zind)),'b:');
    plot(roty,squeeze(RotErr(xind,:,zind)),'r:');
    plot(rotz,squeeze(RotErr(xind,yind,:)),'g:');
    
    %-----------------------------------------
    % Interpolate
    [X,Y,Z] = meshgrid(rotx,roty,rotz);
    ceninterparrx = (rotx(1):0.01:rotx(length(rotx)));
    ceninterparry = (roty(1):0.01:roty(length(roty)));
    ceninterparrz = (rotz(1):0.01:rotz(length(rotz)));    
    [XI,YI,ZI] = meshgrid(ceninterparrx,ceninterparry,ceninterparrz);
    ierr = interp3(X,Y,Z,RotErr,XI,YI,ZI,'cubic');  

    [xind,yind,zind] = ind2sub(size(ierr),find(ierr == min(ierr(:)),1));
    figure(301); hold on;
    plot(ceninterparrx,squeeze(ierr(:,yind,zind)),'b','linewidth',2);
    plot(ceninterparry,squeeze(ierr(xind,:,zind)),'r','linewidth',2);
    plot(ceninterparrz,squeeze(ierr(xind,yind,:)),'g','linewidth',2);  
    
    %-----------------------------------------
    % Save Angles 
    rotcor(a,1) = ceninterparrx(xind);
    rotcor(a,2) = ceninterparry(yind);
    rotcor(a,3) = ceninterparrz(zind);    
    
    %-----------------------------------------
    % Plot Rotated   
    rIm2 = Rotate3DMatrix_v1c(Im2,rotcor(a,1),rotcor(a,2),rotcor(a,3));
    rIm2(rIm2 < imthresh) = 0;
    PlotImage(rIm2,'abs',0,1,201); 
    
    %-----------------------------------------
    % Compare Angles 
    figure(400); hold on;
    plot(a,rotcor(a,1),'b*'); plot(a,-rot0(a,1),'bo');
    plot(a,rotcor(a,2),'r*'); plot(a,-rot0(a,2),'ro');
    plot(a,rotcor(a,3),'g*'); plot(a,-rot0(a,3),'go');    
end

%---------------------------------------------
% Correct Trajectories
%---------------------------------------------
rotKmat = zeros(size(Kmat));
rotKmat(1,:,:) = Kmat(1,:,:);
for a = 2:nproj
    Karr = permute(squeeze(Kmat(a,:,:)),[2 1]);
    Karr = Rotate3DPoints_v1a(Karr,-rotcor(a,1),-rotcor(a,2),-rotcor(a,3));
    rotKmat(a,:,:) = permute(Karr,[2 1]);
    Status2('busy',['Randomly Rotate Trajectory: ',num2str(a)],3);
end

%--------------------------------------------
% Return
%--------------------------------------------
ROTCOR.Kmat = rotKmat;
ROTCOR.rotcor = rotcor;
ROTCOR.rot0 = rot0;

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

