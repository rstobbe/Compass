%====================================================
%
%====================================================

function [IMPTYPE,err] = ImpType_Radial3D_v1a_Func(IMPTYPE,INPUT)

Status2('busy','Radial3D Implementation',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

Func = INPUT.func;
IMPTYPE.name = 'SEO';
FINMETH = IMPTYPE.FINMETH;
REVO = IMPTYPE.REVO;

%=================================================================
% Generate
%=================================================================
if strcmp(Func,'Generate')

    PROJdgn = INPUT.PROJdgn;
    PROJimp = INPUT.PROJimp;
    GQNT = INPUT.GQNT;
    qT0 = INPUT.qT0;
    PSMP = INPUT.PSMP;
    clear INPUT;

    %---------------------------------------------
    % Radial Evolution
    %---------------------------------------------
    func = str2func([REVO.method,'_Func']);      
    INPUT.PROJdgn = PROJdgn;
    INPUT.PROJimp = PROJimp;
    INPUT.GQNT = GQNT;
    INPUT.qT0 = qT0;
    [REVO,err] = func(REVO,INPUT);
    if err.flag
        return
    end
    RadEvo = REVO.RadEvo;
 
    %---------------------------------------------
    % Create Projections
    %---------------------------------------------    
    GQKSA0 = zeros(PROJdgn.nproj,length(RadEvo),3);
    for n = 1:PROJdgn.nproj
        GQKSA0(n,:,1) = RadEvo.*sin(PSMP.phi(n)).*cos(PSMP.theta(n));                              
        GQKSA0(n,:,2) = RadEvo.*sin(PSMP.phi(n)).*sin(PSMP.theta(n));
        GQKSA0(n,:,3) = RadEvo.*cos(PSMP.phi(n)); 
    end   
    IMPTYPE.GQKSA0 = GQKSA0;
    
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

    