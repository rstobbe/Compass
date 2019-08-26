%====================================================
%
%====================================================

function [TST,err] = DesTest_TpiGslew_v1c_Func(TST,INPUT)

Status('busy','Test TPI Design');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
func = INPUT.func;
DESMETH = INPUT.DESMETH;
clear INPUT

%---------------------------------------------
% Get Info
%---------------------------------------------
if strcmp(func,'GetInfo')
    TST.testspeed = 'rapid';
    TST.CACC.Vis = 'Yes';
    TST.DESOL.Vis = 'No';
    return
end

%---------------------------------------------
% Plot
%---------------------------------------------
PROJdgn = DESMETH.PROJdgn;
if strcmp(func,'TestPlot')
    KSA = DESMETH.KSA; 
    fh = figure(500); 
    fh.Name = 'Test Waveform';
    fh.NumberTitle = 'off';
    fh.Position = [850 400 500 400];
    hold on; axis equal; grid on; box off;
    set(gca,'cameraposition',[-200 -250 40]); 
    %sz = size(KSA);
    for n = 1:length(KSA(:,1,1))
        plot3(PROJdgn.rad*KSA(n,:,1),PROJdgn.rad*KSA(n,:,2),PROJdgn.rad*KSA(n,:,3),'k','linewidth',1);
    end
    xlim([-PROJdgn.rad*1.1,PROJdgn.rad*1.1]); ylim([-PROJdgn.rad*1.1,PROJdgn.rad*1.1]); zlim([-PROJdgn.rad*1.1,PROJdgn.rad*1.1]);
    xlabel('kStep_x'); ylabel('kStep_y'); zlabel('kStep_z');  
    title('TPI Waveform');

    %------------------------------------------
    % Calculate Timings
    %------------------------------------------    
    T0 = DESMETH.T0;
    [vel,Tvel0] = CalcVelMulti_v2a(KSA*PROJdgn.kmax,T0);
    [acc,Tacc0] = CalcAccMulti_v2a(vel,Tvel0);
    [jerk,Tjerk0] = CalcJerkMulti_v2a(acc,Tacc0);
    magvel0 = sqrt(vel(:,:,1).^2 + vel(:,:,2).^2 + vel(:,:,3).^2);
    magacc0 = sqrt(acc(:,:,1).^2 + acc(:,:,2).^2 + acc(:,:,3).^2);
    magjerk0 = sqrt(jerk(:,:,1).^2 + jerk(:,:,2).^2 + jerk(:,:,3).^2);  
    maxmagvel0 = max(magvel0,[],1);
    maxmagacc0 = max(magacc0,[],1);
    maxmagjerk0 = max(magjerk0,[],1);
    r = (sqrt(KSA(1,:,1).^2 + KSA(1,:,2).^2 + KSA(1,:,3).^2)); 

    %------------------------------------------
    % Find p
    %------------------------------------------        
    Tp = interp1(r,T0,PROJdgn.p,'spline');
    test = max(r(:))
    
    %------------------------------------------
    % Initial Visualization
    %------------------------------------------  
    if strcmp(TST.nuc,'1H')
        gamma = 42.577;
    elseif strcmp(TST.nuc,'23Na')
        gamma = 11.26;
    end
    clr = 'b';
    fh = figure(15); 
    fh.Name = 'Test Trajectory Evolution';
    fh.NumberTitle = 'off';
    fh.Position = [400 150 1000 800];
    subplot(2,2,1); hold on;
    plot(Tvel0,magvel0/gamma,'k-'); 
    plot(Tvel0,maxmagvel0/gamma,clr); 
    plot([Tp Tp],[0 20],'r:');
    xlabel('tro (ms)'); ylabel('Gradient Magnitude (mT/m)'); title('Gradient Magnitude');
    xlim([0 PROJdgn.tro]);
    ylim([0 20]);
    subplot(2,2,2); hold on;
    plot(Tacc0,magacc0/gamma,'k-');
    plot(Tacc0,maxmagacc0/gamma,clr);
    plot([Tp Tp],[0 250],'r:');
    xlabel('tro (ms)'); ylabel('Gradient Speed (mT/m/ms)'); title('Gradient Speed');
    xlim([0 PROJdgn.tro]);
    ylim([0 250]); 
    subplot(2,2,3); hold on;
    plot(Tjerk0,magjerk0/gamma,'k-');
    plot(Tjerk0,maxmagjerk0/gamma,clr);
    plot([Tp Tp],[0 1e4],'r:');
    xlabel('tro (ms)'); ylabel('Gradient Acceleration (mT/m/ms2)'); title('Gradient Acceleration');
    xlim([0 PROJdgn.tro]);     
    ylim([0 1e4]);
    subplot(2,2,4); hold on;
    %plot(T0,r,'k-');
    plot(DESMETH.TPIT.tatr,DESMETH.TPIT.r,'k-');
    xlabel('tro (ms)'); ylabel('Radial Evolution'); title('Standard TPI Radial Evolution');
    xlim([0 PROJdgn.tro]);     
    %ylim([0 1e4]);  
end

%----------------------------------------------------
% Panel Items
%----------------------------------------------------
Panel0(1,:) = {'Method',PROJdgn.method,'Output'};
Panel0(2,:) = {'FovDim (mm)',PROJdgn.fov,'Output'};
Panel0(3,:) = {'VoxDim (mm)',PROJdgn.vox,'Output'};
Panel0(4,:) = {'VoxCeq (mm3)',((PROJdgn.vox*1.24)^3)*(1/PROJdgn.elip),'Output'};
Panel0(5,:) = {'Tro (ms)',PROJdgn.tro,'Output'};
Panel0(6,:) = {'Ntraj',PROJdgn.nproj,'Output'};
Panel0(7,:) = {'p',PROJdgn.p,'Output'};

Panel1(1,:) = {'StandardTpiProjLen',DESMETH.TPIT.StdProjLen,'Output'};
Panel1(2,:) = {'StandardInitRadEvRate (1/m/ms)',DESMETH.TPIT.StdInitRadEvRate,'Output'};
Panel1(3,:) = {'ProjOverSamp',PROJdgn.projosamp,'Output'};
Panel1(4,:) = {'EdgeSampDens',PROJdgn.edgeSD,'Output'};
Panel1(5,:) = {'rSNR (Brain 5-min PASS)',round(DESMETH.TPIT.rSNR*(34/520)*10)/10,'Output'};

Panel = [Panel0;DESMETH.TPIT.Panel;Panel1];

PanelOutput = cell2struct(Panel,{'label','value','type'},2);
TST.PanelOutput = PanelOutput;
TST.Panel2Imp = Panel;    
    
