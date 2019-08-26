%======================================================
% 
%======================================================

function [ANLZ,err] = MEOVatTroSnrArr_v1a_Func(ANLZ,INPUT)

Status('busy','Calculate MEOV @ Tro - SNR Array');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Input
%---------------------------------------------
path = INPUT.PSF.path; 
name = INPUT.PSF.name; 

%---------------------------------------------
% Get Set
%---------------------------------------------
% PSFname = ['PSF_',name(5:end-1)];
% PSDname = ['PSD_',name(5:end-1)];
% Nstart = str2double(name(end:end));
PSFname = ['PSF_',name(5:end-2)];
PSDname = ['PSD_',name(5:end-2)];
Nstart = str2double(name(end-1:end));
Nmax = 20;

%---------------------------------------------
% Start
%---------------------------------------------
m = 1;
n = Nstart;
lb = ANLZ.start;
while true    

    %---------------------------------------------
    % Load
    %---------------------------------------------      
    if exist([path,PSFname,num2str(n),'.mat'],'file');
        PSF = load([path,PSFname,num2str(n)]);
        PSF = PSF.saveData.PSF;
        PSD = load([path,PSDname,num2str(n)]);   
        PSD = PSD.saveData.PSD;
        disp('-------------------------------------------------');
        disp(['Tro: ',num2str(PSF.PROJdgn.tro)]);
        disp('-------------------------------------------------');
    else
        n = n+1;
        if n > Nmax
            break
        end
        continue
    end

    %---------------------------------------------
    % Test / normalize
    %---------------------------------------------      
    rsnrArr(m) = PSD.rsnr;
    Standard = 6.12;
    norm = (Standard/rsnrArr(m))^(1/3);
    PSD.PROJdgn.vox = PSD.PROJdgn.vox*norm;
    
    %---------------------------------------------
    % Find Lower Bound
    %---------------------------------------------    
    while true
        INPUT.func = 'FindLB';
        INPUT.PSF = PSF;
        INPUT.PSD = PSD;
        [meov0,ANLZout] = MDOVatTroSnrArr_v1a_Reg(lb,ANLZ,INPUT);
        if meov0 == 0
            lb = lb+0.025;
        else
            break
        end
    end
    disp('-------------------------------------------------');
    disp(['lb: ',num2str(lb)]);
    disp('-------------------------------------------------');
    
    %---------------------------------------------
    % Build SNR Estimation Array
    %--------------------------------------------- 
    V = [lb lb+3 lb+8 lb+20];
    INPUT.func = 'FindMeov';
    for p = 1:4
        [meov(m,p),ANLZoutArr(m,p)] = MDOVatTroSnrArr_v1a_Reg(V(p),ANLZ,INPUT);
        snr(m,p) = ANLZoutArr(m,p).snr;
    end
    figure(100); clf; hold on;
    isnr = logspace(log10(4),log10(1.6/ANLZ.rnei),7);
    %isnr = linspace(4,1.6/ANLZ.rnei,7);
    iV = interp1(snr(m,1:4),V,isnr,'pchip','extrap');
    plot(V,snr(m,1:4),'*');
    plot(iV,isnr,'*');   
    
    %---------------------------------------------
    % Test
    %---------------------------------------------
    for p = 1:length(iV)
        [meov(m,p+4),ANLZoutArr(m,p+4)] = MDOVatTroSnrArr_v1a_Reg(iV(p),ANLZ,INPUT);
        snr(m,p+4) = ANLZoutArr(m,p+4).snr;
    end
    
    figure(1234); hold on;
    [b,inds] = sort(snr);
    plot(snr(m,inds),meov(m,inds),'-*');
    h = gca;
    h.XScale = 'log';
    h.XLim = [4 40];
    
    TroArr(m) = PSD.PROJdgn.tro;
    m = m+1;
    n = n+1;
    lb = lb - 0.3;
end
ANLZ.ANLZoutArr = ANLZoutArr;
ANLZ.TroArr = TroArr;
ANLZ.rsnrArr = rsnrArr;
%ANLZ.isnr = isnr;
%ANLZ.imeov = imeov;
ANLZ.snr = snr;
ANLZ.meov = meov;

%--------------------------------------------
% Panel
%--------------------------------------------
Panel(1,:) = {'',[],'Output'};
% Panel(2,:) = {'MEOV (mm3)',ANLZ.meov,'Output'};
% Panel(3,:) = {'MEOV (voxels)',ANLZ.nob,'Output'};
% Panel(4,:) = {'Voxel (mm3)',ANLZ.vox,'Output'};
% Panel(5,:) = {'IRS',ANLZ.aveirs,'Output'};
% Panel(6,:) = {'IRSout',ANLZ.aveirsout,'Output'};
% Panel(7,:) = {'rNEI',ANLZ.rnei,'Output'};
% Panel(8,:) = {'rNEIout',ANLZ.rneiout,'Output'};
% Panel(9,:) = {'SNR',ANLZ.snr,'Output'};
% Panel(10,:) = {'nROI',ANLZ.nroi,'Output'};
% Panel(11,:) = {'Object',ANLZ.objectfunc,'Output'};
% Panel(12,:) = {'',[],'Output'};
% Panel(13,:) = {'PSF',INPUT.PSF.name,'Output'};
% Panel(14,:) = {'PSD',INPUT.PSD.name,'Output'};

ANLZ.PanelOutput = cell2struct(Panel,{'label','value','type'},2);
ANLZ.ExpDisp = PanelStruct2Text(ANLZ.PanelOutput);

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);

