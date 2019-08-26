%====================================================
%
%====================================================

function [IMPTYPE,err] = ImpType_ConesStd_v1c_Func(IMPTYPE,INPUT)

Status2('busy','Standard Cones Implementation',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

Func = INPUT.func;
IMPTYPE.name = 'Std';
FINMETH = IMPTYPE.FINMETH;

%=================================================================
% Generate
%=================================================================
if strcmp(Func,'Generate')

    PROJdgn = INPUT.PROJdgn;
    PROJimp = INPUT.PROJimp;
    qT0 = INPUT.qT0;
    SYS = INPUT.SYS;
    TST = INPUT.TST;
    clear INPUT;

    %---------------------------------------------
    % Figure
    %---------------------------------------------
    fh = figure(12345); 
    if strcmp(fh.NumberTitle,'on')
        fh.Name = 'Cones Development';
        fh.NumberTitle = 'off';
        fh.Position = [200+TST.figshift 550 1400 400];
    else
        redraw = 1;
        if isfield(TST,'redraw')
            if strcmp(TST.redraw,'No')
                redraw = 0;
            end
        end
        if redraw == 1
            clf(fh);
        end
    end  

    %---------------------------------------------
    % Build Cones
    %---------------------------------------------
    DesGradPeriod = 0.001;          % in ms
    Precision = 0.001;              % to get readout length right...
    GradRewindInTro = 0;            % include rewinder in length
    OverSample = 1;                 % oversample
    SlewRate = IMPTYPE.Slew;        % Slew rate (in mT/m/ms)
    GradMax = SYS.GradMax;          % Max Gradient Amplitude (in mT/m)
    DCF = 1.0;                      % Density Compensation Factor

    Len = PROJdgn.tro/DesGradPeriod;
    Ncones = 2*ceil(((pi/2)*(PROJdgn.fov/PROJdgn.vox)+1)/2);
    ThetaStep = pi/Ncones;
    ThetaArr = [(ThetaStep/2:ThetaStep:pi/2) pi/2];
    G = zeros(length(ThetaArr),Len,3);
    GradSampTim = (DesGradPeriod:DesGradPeriod:PROJdgn.tro);

    for n = 1:round(IMPTYPE.SlvFrac*length(ThetaArr))
        [GradTemp,~,NumIntlve(n)] = findcone(PROJdgn.vox,PROJdgn.fov/10,Len,ThetaArr(n),...
                                 Precision,DesGradPeriod/1000,GradRewindInTro,OverSample,SlewRate*100,GradMax/10,DCF);
        GradTemp = GradTemp*10;
        DevLen = length(GradTemp);
        if DevLen < Len
            GradTempEnd = GradTemp(DevLen,:);
            for p = DevLen+1:Len
                GradTemp(p,:) = GradTempEnd;
            end
        end
        
        figure(fh); clf; subplot(1,3,1); hold on;
        plot(GradSampTim,GradTemp(:,1),'b'); plot(GradSampTim,GradTemp(:,2),'g'); plot(GradSampTim,GradTemp(:,3),'r');
        xlim([0 PROJdgn.tro]);
        if n == 1
            setylim = [-10*round(max(GradTemp(:))/10) 10*round(max(GradTemp(:))/10)];
        end
        ylim(setylim);
        xlabel('Readout Duration (ms)');
        ylabel('Gradient (mT/m)');   
        title('Cone Development');
        G(n,1:length(GradTemp),:) = GradTemp;
    end
    N = n;
    
    %---------------------------------------------
    % Build Small Cones
    %---------------------------------------------    
    [GradPi2,~,NumIntlveRange] = findcone(PROJdgn.vox,PROJdgn.fov/10,Len,[ThetaArr(N) pi/2],...
                             Precision,DesGradPeriod/1000,GradRewindInTro,OverSample,SlewRate*100,GradMax/10,DCF);
    GradPi2 = GradPi2*10;
    figure(fh); subplot(1,3,2); hold on;
    plot(GradSampTim,GradPi2(:,1),'b'); plot(GradSampTim,GradPi2(:,2),'g'); plot(GradSampTim,GradPi2(:,3),'r');
    xlim([0 PROJdgn.tro]);
    ylim(setylim);
    xlabel('Readout Duration (ms)');
    ylabel('Gradient (mT/m)'); 
    title('Tightest Cone');
    for n = N+1:length(ThetaArr)
        NumIntlve(n) = (pi*(PROJdgn.fov/PROJdgn.vox)*cos(ThetaArr(n)))/sqrt(1 + ((cos(ThetaArr(n))^2)/(cos(ThetaArr(N))^2))*max([0 ((pi*(PROJdgn.fov/PROJdgn.vox)*(cos(ThetaArr(N))/NumIntlveRange))^2 - 1)])); 
        %NumIntlve(n) = NumIntlve(N);
        scale = cos(ThetaArr(n))/cos(ThetaArr(N));
        G(n,1:length(GradPi2),1) = scale*GradPi2(:,1);
        G(n,1:length(GradPi2),2) = scale*GradPi2(:,2);
        scale = sin(ThetaArr(n))/sin(pi/2);
        G(n,1:length(GradPi2),3) = scale*GradPi2(:,3);
    end
    
    %---------------------------------------------
    % Determine Interleaves
    %---------------------------------------------
    CeilNumIntlve = ceil(NumIntlve);
    TotalTrajEst = sum(CeilNumIntlve)*2;
    osamp = PROJdgn.nproj/TotalTrajEst;
    PROJdgn.projosamp = osamp;
    if osamp < 1
        answer = questdlg(['Trajectory Undersampled (',num2str(osamp),') Continue?']);
        if not(strcmp(answer,'Yes'))
            err.flag = 4;
            return
        end
    end
    while true
        NumIntlve = NumIntlve*osamp;
        CeilNumIntlve = ceil(NumIntlve);
        TotalTrajEst = sum(CeilNumIntlve)*2;
        osampN = PROJdgn.nproj/TotalTrajEst;
        if osampN == 1
            break
        end
        osamp = (osampN + osamp)/2;
    end
    IMPTYPE.NumIntlve = CeilNumIntlve;
 
    %---------------------------------------------
    % Distribute Gradients
    %---------------------------------------------   
    if strcmp(TST.testing,'Yes')
        Gfull = G;
    else
        Gfull = zeros(PROJdgn.nproj,Len,3);
        m = 0;
        for n = 1:length(ThetaArr)
            PhiStep = 2*pi/CeilNumIntlve(n);
            Phi = (PhiStep/2:PhiStep:2*pi);
            if length(Phi) ~= CeilNumIntlve(n)
                error;
            end
            for p = 1:CeilNumIntlve(n)
                m = m+1;
                Gfull(m,:,1) = cos(Phi(p))*G(n,:,1) - sin(Phi(p))*G(n,:,2);
                Gfull(m,:,2) = sin(Phi(p))*G(n,:,1) + cos(Phi(p))*G(n,:,2);
                Gfull(m,:,3) = G(n,:,3);
            end
        end
        for n = 1:length(ThetaArr)
            PhiStep = 2*pi/CeilNumIntlve(n);
            Phi = (PhiStep/2:PhiStep:2*pi);
            for p = 1:CeilNumIntlve(n)
                m = m+1;
                Gfull(m,:,1) = cos(Phi(p))*G(n,:,1) - sin(Phi(p))*G(n,:,2);
                Gfull(m,:,2) = sin(Phi(p))*G(n,:,1) + cos(Phi(p))*G(n,:,2);
                Gfull(m,:,3) = -G(n,:,3);
            end
        end
    end
    
    %---------------------------------------------
    % Quantize Waveforms
    %---------------------------------------------
    T = (0:DesGradPeriod:PROJdgn.tro-DesGradPeriod);
    samp = (0:DesGradPeriod:PROJdgn.tro);
    [Kmat,~] = ReSampleKSpace_v7a(Gfull,T,samp,PROJimp.gamma);
    GQKSA0 = Quantize_Projections_v1c(samp,Kmat,qT0);   
    IMPTYPE.GQKSA0 = GQKSA0;
    IMPTYPE.PROJdgn = PROJdgn;

    figure(fh); subplot(1,3,3); hold on;
    plot(qT0,GQKSA0(end,:,1),'b-'); plot(qT0,GQKSA0(end,:,2),'g'); plot(qT0,GQKSA0(end,:,3),'r');
    xlabel('Readout Duration (ms)');
    ylabel('k-Space (1/m)'); 
    ylim([-PROJdgn.kmax PROJdgn.kmax]);
    title('kSpace Evolution Tightest');
    
%=================================================================
% Finish
%=================================================================
elseif strcmp(Func,'Finish')

    %---------------------------------------------
    % Get Input
    %---------------------------------------------
    PROJdgn = INPUT.PROJdgn;
    PROJimp = INPUT.PROJimp;
    GQKSA0 = INPUT.GQKSA0;
    qT0 = INPUT.qT0; 
    SYS = INPUT.SYS;
    SYSRESP = INPUT.SYSRESP;
    TEND = INPUT.TEND;
    TST = INPUT.TST;
    GQNT = INPUT.GQNT;
    clear INPUT;
    
    %---------------------------------------------
    % Finish
    %---------------------------------------------               
    func = str2func([FINMETH.method,'_Func']);      
    INPUT.PROJdgn = PROJdgn;
    INPUT.PROJimp = PROJimp;
    INPUT.GQKSA0 = GQKSA0;
    INPUT.qT0 = qT0;
    INPUT.SYS = SYS;
    INPUT.SYSRESP = SYSRESP;
    INPUT.TEND = TEND;
    INPUT.TST = TST;
    INPUT.GQNT = GQNT;
    [FINMETH,err] = func(FINMETH,INPUT);
    if err.flag
        return
    end
    clear INPUT; 
    IMPTYPE.qT = FINMETH.qT;
    IMPTYPE.GQKSA = FINMETH.GQKSA;
    IMPTYPE.qTtot = FINMETH.qTtot;
    IMPTYPE.Gtot = FINMETH.Gtot;
    IMPTYPE.GWFM = FINMETH.GWFM;

%=================================================================
% PostResample
%=================================================================
elseif strcmp(Func,'PostResample')

    %---------------------------------------------
    % Get Input
    %---------------------------------------------
    Samp0 = INPUT.Samp0;
    Kmat0 = INPUT.Kmat0;
    SampRecon0 = INPUT.SampRecon;
    KmatRecon0 = INPUT.KmatRecon;
    npro = length(SampRecon0);
    nptot = length(Samp0);
    KSMP = INPUT.KSMP;
    TSMP = INPUT.TSMP;
    TST = INPUT.TST;
    clear INPUT

    if strcmp(TST.IMPTYPE.Vis,'Yes')
        fh = figure(5963455); hold on;
        fh.Name = 'Radial Evolution';
        fh.NumberTitle = 'off';
        fh.Position = [650+TST.figshift 550 500 400];
        Rad0 = sqrt(Kmat0(1,:,1).^2 + Kmat0(1,:,2).^2 + Kmat0(1,:,3).^2);
        plot(Rad0,'k');
        ylabel('Radius (1/m)');
        xlabel('Sample');
    end
         
    KmatDisplay = NaN*ones([nptot 3 1]);
    ind = find(round(Samp0*1e6) == round(SampRecon0(1)*1e6));
    KmatDisplay(ind:ind+npro-1,:,1) = squeeze(KmatRecon0(1,:,:));
    
    %---------------------------------------------
    % Fit 1st Image
    %---------------------------------------------
    tKmatRecon = squeeze(KmatRecon0(1,:,:));
    Rad0 = sqrt(tKmatRecon(:,1).^2 + tKmatRecon(:,2).^2 + tKmatRecon(:,3).^2);
    ind = 1:1:50;
    for n = 1:length(ind)
        tKmat0 = squeeze(Kmat0(1,ind(n):ind(n)+npro-1,:));
        Rad1 = sqrt(tKmat0(:,1).^2 + tKmat0(:,2).^2 + tKmat0(:,3).^2);
        resid = Rad0 - Rad1;
        residsum(n) = sum(abs(resid(:)));
    end
    SampStart1 = ind(residsum == min(residsum));
    if residsum(SampStart1) ~= 0
        error
    end
    if strcmp(TST.IMPTYPE.Vis,'Yes')
        plot([NaN*ones(SampStart1-1,1);Rad0],'r','linewidth',2);
    end
        
    IMPTYPE.SampStart = SampStart1;
    IMPTYPE.KmatRecon = KmatRecon0;
    IMPTYPE.KmatDisplay = KmatDisplay;
    IMPTYPE.numberofimages = 1;
   
    %---------------------------------------------
    % Return Relavent to KSMP Structure
    %---------------------------------------------    
    KSMP.SampStart = IMPTYPE.SampStart;
    CenSamp = KSMP.SampStart;
    KSMP.Delay2Centre = Samp0(CenSamp);
    KSMP.flip = 0;
    IMPTYPE.KSMP = KSMP;
    IMPTYPE.TSMP = TSMP;
    
end

    