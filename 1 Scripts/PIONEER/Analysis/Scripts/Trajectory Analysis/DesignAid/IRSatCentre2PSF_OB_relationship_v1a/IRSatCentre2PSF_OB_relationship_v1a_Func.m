%======================================================
% 
%======================================================

function [ANLZ,err] = IRSatCentre2PSF_OB_relationship_v1a_Func(ANLZ,INPUT)

Status('busy','IRS 2PSF @ Centre - Object Relationship');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PSFob = INPUT.PSFob;
PSFbg = INPUT.PSFbg;
OB = INPUT.OB;
clear INPUT

%---------------------------------------------
% Get Variables
%---------------------------------------------
zf = ANLZ.zf;
fov = PSFob.PROJdgn.fov;
vox = PSFob.PROJdgn.vox;
elip = PSFob.PROJdgn.elip;
vinvox = ((vox/(fov/zf))^3)/elip;

%---------------------------------------------
% Zero-Fill Transfer Function
%---------------------------------------------
tfmatwid = length(PSFob.tf);
tfzfob = zeros(zf,zf,zf);
tfzfbg = zeros(zf,zf,zf);
b = (zf/2)+1-(tfmatwid-1)/2;
t = (zf/2)+1+(tfmatwid-1)/2;
tfzfob(b:t,b:t,b:t) = PSFob.tf;
tfzfbg(b:t,b:t,b:t) = PSFbg.tf;

for n = 1:length(OB.arr);

    %---------------------------------------------
    % Build Object
    %---------------------------------------------  
    Status2('busy','Build Object',2);
    obfunc = str2func([ANLZ.objectfunc,'_Func']);
    INPUT.zf = zf;
    INPUT.fov = fov;
    INPUT.arrval = OB.arr(n);
    INPUT.pcntmaxerr = 10;
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
    figure(11); hold on; 
    plot((OB.voxdim:OB.voxdim:fov)/vox+0.16,OBprof*2.07+1,'k'); 
    plot((OB.voxdim:OB.voxdim:fov)/vox+0.16,OBprof2*2.07+1,'k:'); 
    
    %---------------------------------------------
    % FT
    %---------------------------------------------
    Status2('busy','Fourier Transform',2);
    Imob = fftshift(fftn(OB.Ob));
    Imob = Imob.*tfzfob;
    Imob = ifftn(ifftshift(Imob));
    test = sum(imag(Imob(:)));
    if test > 1e-20
        error
    end
    Imbg = fftshift(fftn(1-OB.Ob));
    Imbg = Imbg.*tfzfob;
    Imbg = ifftn(ifftshift(Imbg));
    test = sum(imag(Imbg(:)));
    if test > 1e-20
        error
    end    
    
    Im = 3.07*Imob + Imbg;
    
    Improf1 = real(squeeze(Im(:,zf/2+1,zf/2+1)));
    Improf2 = real(squeeze(Im(zf/2+1,zf/2+1,:)));
    figure(10);
    plot((OB.voxdim:OB.voxdim:fov),Improf1,'r'); plot((OB.voxdim:OB.voxdim:fov),Improf2,'r:');
    legend('Object','','IRS','');
    figure(11);
    plot((OB.voxdim:OB.voxdim:fov)/vox+0.16,Improf1,'r'); plot((OB.voxdim:OB.voxdim:fov)/vox+0.16,Improf2,'r:');
    legend('Object','','IRS','');
    ylim([0.5 3.5]); 
    xlim([39 49]); box on;
       
    %--------------------------------------
    % Find Average IRS
    %--------------------------------------    
    meanirs(n) = mean(abs(Im(zf/2+1,zf/2+1,zf/2+1)));
end

%---------------------------------------------
% Save
%---------------------------------------------
OB = rmfield(OB,'Ob');
ANLZ.OB = OB;
ANLZ.nob = nob;
ANLZ.meanirs = meanirs;

%---------------------------------------------
% Plot
%---------------------------------------------
meanirs = (meanirs-1)/2.07;

figure(1000); 
plot(nob,meanirs);
box on;
%set(gca,'XScale','log');
ylim([0 1.1]); %xlim([1 300]);

%--------------------------------------------
% Panel
%--------------------------------------------
Panel(1,:) = {'','','Output'};
ANLZ.PanelOutput = cell2struct(Panel,{'label','value','type'},2);
ANLZ.ExpDisp = PanelStruct2Text(ANLZ.PanelOutput);

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);
