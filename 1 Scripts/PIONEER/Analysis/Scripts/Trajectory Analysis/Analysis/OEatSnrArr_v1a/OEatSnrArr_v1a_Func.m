%======================================================
% 
%======================================================

function [ANLZ,err] = OEatSnrArr_v1a_Func(ANLZ,INPUT)

Status('busy','Object Error (OE) across SNR array');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Input
%---------------------------------------------
TF = INPUT.TF; 
PSD = INPUT.PSD; 
OB = INPUT.OB;
ROI = OB;
clear INPUT

%---------------------------------------------
% Get Variables
%---------------------------------------------
zf = ANLZ.zf;
fov = TF.PROJdgn.fov;
vox = TF.PROJdgn.vox;
elip = TF.PROJdgn.elip;
vinvox0 = zf^3/PSD.kmatvol;
vinvox = ((vox/(fov/zf))^3)/elip;
if round(vinvox0*1e6) ~= round(vinvox*1e6)
    error
end

%---------------------------------------------
% Zero-Fill Transfer Function
%---------------------------------------------
tfmatwid = length(TF.tf);
tfzf = zeros(zf,zf,zf);
b = (zf/2)+1-(tfmatwid-1)/2;
t = (zf/2)+1+(tfmatwid-1)/2;
tfzf(b:t,b:t,b:t) = TF.tf;

%---------------------------------------------
% ZeroFill PSD
%---------------------------------------------
psdmatwid = length(PSD.psd);
psdzf = zeros(ANLZ.zf,ANLZ.zf,ANLZ.zf);
b = (ANLZ.zf/2)+1-(psdmatwid-1)/2;
t = (ANLZ.zf/2)+1+(psdmatwid-1)/2;
psdzf(b:t,b:t,b:t) = PSD.psd;

%---------------------------------------------
% Calculate ObShapeValStart
%---------------------------------------------  
Status2('busy','Build Object',2);
obfunc = str2func([ANLZ.objectfunc,'_Func']);
INPUT.zf = zf;
INPUT.fov = fov;
INPUT.shapeval = 10;
[OB,err] = obfunc(OB,INPUT);
clear INPUT;
if err.flag
    msg = err.msg
    error
end
isnr = ANLZ.snr0*ANLZ.obanlzvolcm/OB.volcm;
ObShapeValStart = floor((isnr/50)^(1/3) * 10);

%---------------------------------------------
% Calculate SNR array
%---------------------------------------------  
m = 1;
while true
    
    %---------------------------------------------
    % Build Object
    %---------------------------------------------  
    Status2('busy','Build Object',2);
    obfunc = str2func([ANLZ.objectfunc,'_Func']);
    INPUT.zf = zf;
    INPUT.fov = fov;
    INPUT.shapeval = ObShapeValStart + m - 1;
    [OB,err] = obfunc(OB,INPUT);
    clear INPUT;
    if err.flag
        msg = err.msg
        error
    end
    isnr0 = ANLZ.snr0*ANLZ.obanlzvolcm/OB.volcm;
    if isnr0 < 10
        break
    end
    isnr(m) = isnr0;
    vinob = sum(OB.Ob(:));
    nob(m) = vinob/vinvox;

    %---------------------------------------------
    % FT
    %---------------------------------------------
    Status2('busy','Fourier Transform',2);
    Im = fftshift(fftn(OB.Ob));
    Im = Im.*tfzf;
    Im = ifftn(ifftshift(Im));
    test = sum(imag(Im(:)));
    if test > 1e-19
        test
        error
    end
    Im = real(Im);
    %clear OB;

    %RoiArr = (ObShapeValStart+m-1:-1:ObShapeValStart+m-2);
    RoiArr = (ObShapeValStart+m-1);
    for n = 1:length(RoiArr)
        
        %---------------------------------------------
        % Build ROI 
        %---------------------------------------------  
        Status2('busy','Build Object',2);
        obfunc = str2func([ANLZ.objectfunc,'_Func']);
        INPUT.zf = zf;
        INPUT.fov = fov;
        INPUT.shapeval = RoiArr(n);
        [ROI,err] = obfunc(ROI,INPUT);
        clear INPUT;
        if err.flag
            msg = err.msg
            error
        end
        Mask = ROI.Ob;
        vinroi = sum(Mask(:));
        nroi = vinroi/vinvox;
        froi(m,n) = vinroi/vinob;

        %---------------------------------------------
        % Calculate CV
        %---------------------------------------------    
        Status2('busy','Noise Analysis',2);
        INPUT.roi = Mask;
        INPUT.psd = psdzf;
        INPUT.kmatvol = PSD.kmatvol;  
        CV = [];
        [CV,err] = CorVolCalc_v1a(CV,INPUT);
        if err.flag
            error
        end
        cv = CV.cv;
        siv = nroi/cv;
        mnr = sqrt(siv)*isnr(m);
        rnei(m,n) = 1.96*(1/mnr);

        %---------------------------------------------
        % IRS
        %---------------------------------------------  
        Status2('busy','Calculate IRS',2);
        Mask(Mask == 0) = NaN;
        Out = Mask.*Im;
        irs(m,n) = nanmean(Out(:));

        cove(m,n) = rnei(m,n)/irs(m,n);
    end
    m = m+1;
end
    
ANLZ.cove = cove;
ANLZ.irs = irs;
ANLZ.rnei = rnei;
ANLZ.froi = froi;
ANLZ.snr = isnr;
ANLZ.nob = nob;

%--------------------------------------------
% Panel
%--------------------------------------------
fh = figure(100); 
subplot(1,3,3); hold on;
plot(ANLZ.snr,100*ANLZ.cove(:,1))
%ylim([0 ceil(max(ANLZ.cove)*50)/50]);
ylim([0 22]);
xlabel('SNR');
ylabel('COVE (%)')
subplot(1,3,1); hold on;
plot(ANLZ.snr,100*ANLZ.rnei(:,1))
%ylim([0 ceil(max(ANLZ.rnei)*50)/50]);
ylim([0 100*ceil(max(ANLZ.rnei(:,1))*50)/50]);
xlabel('SNR');
ylabel('rNEI (%)')
subplot(1,3,2); hold on;
plot(ANLZ.snr,100*ANLZ.irs(:,1))
ylim([0 100*ceil(max(ANLZ.irs(:,1))*5)/5]);
xlabel('SNR');
ylabel('IRS (%)')
fh.Units = 'Inches';
fh.Position = [3,4,12,3];

figure(101); hold on;
plot(ANLZ.snr,ANLZ.nob)

%--------------------------------------------
% Panel
%--------------------------------------------
Panel(1,:) = {'',[],'Output'};
Panel(2,:) = {ANLZ.method,'','Output'};
Panel(3,:) = {'TF',TF.name,'Output'};
Panel(4,:) = {'PSD',PSD.name,'Output'};

ANLZ.PanelOutput = cell2struct(Panel,{'label','value','type'},2);
ANLZ.ExpDisp = PanelStruct2Text(ANLZ.PanelOutput);

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);

