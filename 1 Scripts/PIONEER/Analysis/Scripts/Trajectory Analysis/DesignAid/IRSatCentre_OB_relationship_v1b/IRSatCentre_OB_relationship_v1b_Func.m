%======================================================
% 
%======================================================

function [ANLZ,err] = IRSatCentre_OB_relationship_v1b_Func(ANLZ,INPUT)

Status('busy','IRS @ Centre - Object Relationship');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
TF = INPUT.TF;
OB = INPUT.OB;
clear INPUT

%---------------------------------------------
% Get Variables
%---------------------------------------------
zf = ANLZ.zf;
fov = TF.PROJdgn.fov;
vox = TF.PROJdgn.vox;
elip = TF.PROJdgn.elip;
vinvox = ((vox/(fov/zf))^3)/elip;
voxvol = vox^3/elip;

%---------------------------------------------
% Zero-Fill Transfer Function
%---------------------------------------------
tfmatwid = length(TF.tf);
tfzf = zeros(zf,zf,zf);
b = (zf/2)+1-(tfmatwid-1)/2;
t = (zf/2)+1+(tfmatwid-1)/2;
tfzf(b:t,b:t,b:t) = TF.tf;

for n = 1:length(OB.arr)

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
    
    Imob = fftshift(fftn(OB.Ob));
    Imob = Imob.*tfzf;
    Imob = ifftn(ifftshift(Imob));
    test = sum(imag(Imob(:)));
    if test > 1e-20
        error
    end  
    
    figure(10); hold on;
    Improf = real(squeeze(Im(:,zf/2+1,zf/2+1)));
    Improf2 = real(squeeze(Im(zf/2+1,zf/2+1,:)));
    plot((OB.voxdim:OB.voxdim:fov),Improf,'r'); 
    plot((OB.voxdim:OB.voxdim:fov),Improf2,'r:'); 
    
    CenVal(n) = max(Improf);

end

%---------------------------------------------
% Save
%---------------------------------------------
OB = rmfield(OB,'Ob');
ANLZ.OB = OB;
ANLZ.nob = nob;
ANLZ.CenVal = CenVal;

%---------------------------------------------
% Plot
%---------------------------------------------
figure(1000); 
plot(nob*voxvol/1000,CenVal);
box on;
xlabel('cm^3');
%set(gca,'XScale','log');
%ylim([0 1.1]); xlim([1 300]);

%--------------------------------------------
% Panel
%--------------------------------------------
Panel(1,:) = {'','','Output'};
ANLZ.PanelOutput = cell2struct(Panel,{'label','value','type'},2);
ANLZ.ExpDisp = PanelStruct2Text(ANLZ.PanelOutput);

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);
