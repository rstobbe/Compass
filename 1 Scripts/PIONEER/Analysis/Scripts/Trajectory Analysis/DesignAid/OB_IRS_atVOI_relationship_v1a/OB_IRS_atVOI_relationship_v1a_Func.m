%======================================================
% 
%======================================================

function [ANLZ,err] = OB_IRS_atVOI_relationship_v1a_Func(ANLZ,INPUT)

Status('busy','Object - IRS Relationship @ VOI');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PSF = INPUT.PSF;
ROI = INPUT.ROI;
OB = INPUT.OB;
clear INPUT

%---------------------------------------------
% Get Variables
%---------------------------------------------
zf = ANLZ.zf;
fov = PSF.PROJdgn.fov;
vox = PSF.PROJdgn.vox;
elip = PSF.PROJdgn.elip;
vinvox = ((vox/(fov/zf))^3)/elip;

%---------------------------------------------
% Zero-Fill Transfer Function
%---------------------------------------------
tfmatwid = length(PSF.tf);
tfzf = zeros(zf,zf,zf);
b = (zf/2)+1-(tfmatwid-1)/2;
t = (zf/2)+1+(tfmatwid-1)/2;
tfzf(b:t,b:t,b:t) = PSF.tf;

%---------------------------------------------
% Build Roi
%---------------------------------------------  
Status2('busy','Build VOI',2);
obfunc = str2func([ANLZ.objectfunc,'_Func']);
INPUT.zf = zf;
INPUT.fov = fov;
INPUT.arrval = ROI.arr;
INPUT.pcntmaxerr = 5;
[ROI,err] = obfunc(ROI,INPUT);
if err.flag
    return
end
vinroi = sum(ROI.Ob(:));
nroi = vinroi/vinvox;
ROIprof = squeeze(ROI.Ob(:,zf/2+1,zf/2+1));
ROIprof2 = squeeze(ROI.Ob(zf/2+1,zf/2+1,:));
figure(10); hold on; 
plot((ROI.voxdim:ROI.voxdim:fov),ROIprof,'b'); 
plot((ROI.voxdim:ROI.voxdim:fov),ROIprof2,'b:'); 
title('Object Profile');
xlabel('Dimensions');
xlim([0 fov]);

for n = 1:length(OB.arr);

    %---------------------------------------------
    % Build Object
    %---------------------------------------------  
    Status2('busy','Build Object',2);
    obfunc = str2func([ANLZ.objectfunc,'_Func']);
    INPUT.zf = zf;
    INPUT.fov = fov;
    INPUT.arrval = OB.arr(n);
    INPUT.pcntmaxerr = 5;
    [OB,err] = obfunc(OB,INPUT);
    if err.flag
        return
    end
    vinob = sum(OB.Ob(:));
    nob(n) = vinob/vinvox;
    OBprof = squeeze(OB.Ob(:,zf/2+1,zf/2+1));
    OBprof2 = squeeze(OB.Ob(zf/2+1,zf/2+1,:));
    figure(10); hold on; 
    plot((OB.voxdim:OB.voxdim:fov),OBprof,'k'); 
    plot((OB.voxdim:OB.voxdim:fov),OBprof2,'k:'); 
    
    %---------------------------------------------
    % FT
    %---------------------------------------------
    Status2('busy','Fourier Transform',2);
    Im = fftshift(fftn(OB.Ob));
    Im = Im.*tfzf;
    Im = ifftn(ifftshift(Im));
    test = sum(imag(Im(:)));
    if test > 1e-20
        error
    end
    Improf1 = real(squeeze(Im(:,zf/2+1,zf/2+1)));
    Improf2 = real(squeeze(Im(zf/2+1,zf/2+1,:)));
    figure(10);
    plot((OB.voxdim:OB.voxdim:fov),Improf1,'r'); plot((OB.voxdim:OB.voxdim:fov),Improf2,'r:');
    legend('VOI','','Object','','IRS','');

    %--------------------------------------
    % Find Average IRS
    %--------------------------------------    
    meanirs(n) = mean(abs(Im(logical(ROI.Ob))));
end

%---------------------------------------------
% Save
%---------------------------------------------
ROI = rmfield(ROI,'Ob');
OB = rmfield(OB,'Ob');
ANLZ.OB = OB;
ANLZ.ROI = ROI;
ANLZ.nroi = nroi;
ANLZ.nob = nob;
ANLZ.meanirs = meanirs;

%---------------------------------------------
% Plot
%---------------------------------------------
figure(1000); 
plot(nob,meanirs);
box on;

%--------------------------------------------
% Panel
%--------------------------------------------
Panel(1,:) = {'nroi',nroi,'Output'};
ANLZ.PanelOutput = cell2struct(Panel,{'label','value','type'},2);
ANLZ.ExpDisp = PanelStruct2Text(ANLZ.PanelOutput);

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);
