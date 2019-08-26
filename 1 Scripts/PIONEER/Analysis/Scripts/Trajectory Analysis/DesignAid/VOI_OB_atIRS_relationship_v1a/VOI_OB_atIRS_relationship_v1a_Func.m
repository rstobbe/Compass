%======================================================
% 
%======================================================

function [ANLZ,err] = VOI_OB_atIRS_relationship_v1a_Func(ANLZ,INPUT)

Status('busy','Calculate VOI_OB_IRS relationship');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PSF = INPUT.PSF;
CALC = INPUT.CALC;
OB = INPUT.OB;
clear INPUT

%---------------------------------------------
% Get Variables
%---------------------------------------------
zf = ANLZ.zf;
fov = PSF.PROJdgn.fov;
vox = PSF.PROJdgn.vox;
vinvox = (vox/(fov/zf))^3;

%---------------------------------------------
% Zero-Fill Transfer Function
%---------------------------------------------
tfmatwid = length(PSF.tf);
tfzf = zeros(zf,zf,zf);
b = (zf/2)+1-(tfmatwid-1)/2;
t = (zf/2)+1+(tfmatwid-1)/2;
tfzf(b:t,b:t,b:t) = PSF.tf;

for n = 1:length(OB.arr);

    %---------------------------------------------
    % Build Object
    %---------------------------------------------  
    Status2('busy','Build Object',2);
    obfunc = str2func([ANLZ.objectfunc,'_Func']);
    INPUT.zf = zf;
    INPUT.fov = fov;
    INPUT.arrval = OB.arr(n);
    [OB,err] = obfunc(OB,INPUT);
    if err.flag
        return
    end
    vinob = sum(OB.Ob(:));
    nob(n) = vinob/vinvox;
    OBprof = squeeze(OB.Ob(zf/2+1,zf/2+1,:));
    figure(10); hold on; 
    plot((OB.voxdim:OB.voxdim:fov),OBprof,'b'); 
    title('Object Profile');
    xlabel('Dimensions');
    xlim([0 fov]);

    %---------------------------------------------
    % FT
    %---------------------------------------------
    Status2('busy','Fourier Transform',2);
    Im = fftshift(fftn(OB.Ob));
    Im = Im.*tfzf;
    clear tfzf
    Im = ifftn(ifftshift(Im));
    test = sum(imag(Im(:)));
    if test > 1e-20
        error
    end
    Improf1 = real(squeeze(Im(:,zf/2+1,zf/2+1)));
    Improf2 = real(squeeze(Im(zf/2+1,zf/2+1,:)));
    figure(10);
    plot((OB.voxdim:OB.voxdim:fov),Improf1,'r'); plot((OB.voxdim:OB.voxdim:fov),Improf2,'r:');
    legend('Base','In-Plane','Out-Of-Plane');

    %--------------------------------------
    % Analyze ROIs
    %--------------------------------------    
    Status2('busy','Analyze ROIs',2);
    func = str2func([ANLZ.calcfunc,'_Func']);
    INPUT.SmearIm = abs(Im);
    [CALC,err] = func(CALC,INPUT);
    if err.flag
        return
    end
    vinROI = sum(CALC.Mask(:));
    nroi(n) = vinROI/vinvox;
end

%---------------------------------------------
% Save
%---------------------------------------------
ANLZ.
figure(1000); 
plot(nob,nroi);
box on;
xlim([0 300]); ylim([0 200]); 
%set(gca,'XScale','log'); set(gca,'YScale','log');

%---------------------------------------------
% Return
%---------------------------------------------  
CVARR.ExpDisp = '';

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);
