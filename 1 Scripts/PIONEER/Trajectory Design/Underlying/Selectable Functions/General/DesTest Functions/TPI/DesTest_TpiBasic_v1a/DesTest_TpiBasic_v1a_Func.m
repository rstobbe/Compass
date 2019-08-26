%====================================================
%
%====================================================

function [TST,err] = DesTest_TpiBasic_v1a_Func(TST,INPUT)

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

if strcmp(func,'GetInfo')
    TST.testspeed = 'rapid';
    TST.CACC.Vis = 'Yes';
    TST.DESOL.Vis = 'No';
    return
end

PROJdgn = DESMETH.PROJdgn;
if strcmp(func,'TestPlot')
    KSA = DESMETH.KSA; 
    fh = figure(500); 
    fh.Name = 'Test Waveform';
    fh.NumberTitle = 'off';
    fh.Position = [850 400 500 400];
    hold on; axis equal; grid on; box off;
    set(gca,'cameraposition',[-200 -250 40]); 
    for n = 1:length(KSA(:,1,1))
        plot3(PROJdgn.rad*KSA(n,:,1),PROJdgn.rad*KSA(n,:,2),PROJdgn.rad*KSA(n,:,3),'k','linewidth',1);
    end
    xlim([-PROJdgn.rad*1.1,PROJdgn.rad*1.1]); ylim([-PROJdgn.rad*1.1,PROJdgn.rad*1.1]); zlim([-PROJdgn.rad*1.1,PROJdgn.rad*1.1]);
    xlabel('kStep_x'); ylabel('kStep_y'); zlabel('kStep_z');  
    title('YarnBall Waveform');
end
    
%----------------------------------------------------
% Panel Items
%----------------------------------------------------
Panel(1,:) = {'Method',PROJdgn.method,'Output'};
Panel(2,:) = {'FovDim (mm)',PROJdgn.fov,'Output'};
Panel(3,:) = {'VoxDim (mm)',PROJdgn.vox,'Output'};
Panel(4,:) = {'VoxCeq (mm3)',((PROJdgn.vox*1.24)^3)*(1/PROJdgn.elip),'Output'};
Panel(5,:) = {'Tro (ms)',PROJdgn.tro,'Output'};
Panel(6,:) = {'Ntraj',PROJdgn.nproj,'Output'};
Panel(7,:) = {'ProjOsamp',PROJdgn.projosamp,'Output'};

PanelOutput = cell2struct(Panel,{'label','value','type'},2);
TST.PanelOutput = PanelOutput;
TST.Panel2Imp = Panel;    
    
