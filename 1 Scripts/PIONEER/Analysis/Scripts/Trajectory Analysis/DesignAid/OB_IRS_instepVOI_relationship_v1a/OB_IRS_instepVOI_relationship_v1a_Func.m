%======================================================
% 
%======================================================

function [ANLZ,err] = OB_IRS_instepVOI_relationship_v1a_Func(ANLZ,INPUT)

Status('busy','Object - IRS Relationship (instep VOI)');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PSF = INPUT.PSF;
OB = INPUT.OB;
ROI = OB;
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
% Test
%---------------------------------------------
OBvolmin = PSF.PROJdgn.vox^3;
OBvolarr = logspace(log10(0.9),log10(280),20)*OBvolmin;
Diam = 2*((OBvolarr*(3/(4*pi))).^(1/3));

%for n = 1:length(OB.arr);
for n = 1:length(Diam);

    %---------------------------------------------
    % Build Object
    %---------------------------------------------  
    Status2('busy','Build Object',2);
    obfunc = str2func([ANLZ.objectfunc,'_Func']);
    INPUT.zf = zf;
    INPUT.fov = fov;
    %INPUT.arrval = OB.arr(n);
    INPUT.arrval = Diam(n);
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

    %---------------------------------------------
    % Build ROI / Find Average IRS
    %---------------------------------------------  
    Status2('busy','Build ROI',2);
    for m = 1:length(ANLZ.instep)
        roifunc = str2func([ANLZ.objectfunc,'_Func']);
        INPUT.zf = zf;
        INPUT.fov = fov;
        %INPUT.arrval = ROI.arr(n) - vox*ANLZ.instep(m)
        INPUT.arrval = Diam(n) - vox*ANLZ.instep(m)
        if INPUT.arrval < 1.7
            nroi(n,m) = NaN;
            meanirs(n,m) = NaN;
            continue
        end
        INPUT.pcntmaxerr = 30;
        [ROI,err] = roifunc(ROI,INPUT);
        if err.flag
            return
        end
        vinroi = sum(ROI.Ob(:));
        nroi(n,m) = vinroi/vinvox;
        ROIprof = squeeze(ROI.Ob(:,zf/2+1,zf/2+1));
        ROIprof2 = squeeze(ROI.Ob(zf/2+1,zf/2+1,:));
        figure(10); hold on; 
        plot((ROI.voxdim:ROI.voxdim:fov),ROIprof,'b'); 
        plot((ROI.voxdim:ROI.voxdim:fov),ROIprof2,'b:');    
        meanirs(n,m) = mean(abs(Im(logical(ROI.Ob))));
    end
end

%---------------------------------------------
% Save
%---------------------------------------------
OB = rmfield(OB,'Ob');
ANLZ.OB = OB;
ANLZ.nob = nob;
ANLZ.nroi = nroi;
ANLZ.meanirs = meanirs;

%---------------------------------------------
% Plot
%---------------------------------------------
figure(1000); 
plot(nob,meanirs);
h = gca;
h.XScale = 'log';
box on;

%--------------------------------------------
% Panel
%--------------------------------------------
Panel(1,:) = {'','','Output'};
ANLZ.PanelOutput = cell2struct(Panel,{'label','value','type'},2);
ANLZ.ExpDisp = PanelStruct2Text(ANLZ.PanelOutput);

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);
