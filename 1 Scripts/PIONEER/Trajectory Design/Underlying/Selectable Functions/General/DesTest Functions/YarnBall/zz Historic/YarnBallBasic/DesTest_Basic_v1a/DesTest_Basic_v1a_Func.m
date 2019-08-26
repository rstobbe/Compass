%====================================================
%
%====================================================

function [TST,err] = DesTest_Basic_v1a_Func(TST,INPUT)

Status('busy','Test YarnBall Design');
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
    TST.SPIN.Vis = 'No';
    TST.CACC.Vis = 'No';
    TST.DESOL.Vis = 'No';
    return
end

PROJdgn = DESMETH.PROJdgn;
if strcmp(func,'TestPlot')
    KSA = squeeze(DESMETH.KSA); 
    fh = figure(500); 
    fh.Name = 'Test Waveform';
    fh.NumberTitle = 'off';
    fh.Position = [850 400 500 400];
    hold on; axis equal; grid on; box off;
    set(gca,'cameraposition',[-200 -250 40]); 
    plot3(PROJdgn.rad*KSA(:,1),PROJdgn.rad*KSA(:,2),PROJdgn.rad*KSA(:,3),'k','linewidth',1);
    xlim([-PROJdgn.rad*1.1,PROJdgn.rad*1.1]); ylim([-PROJdgn.rad*1.1,PROJdgn.rad*1.1]); zlim([-PROJdgn.rad*1.1,PROJdgn.rad*1.1]);
    xlabel('kStep_x'); ylabel('kStep_y'); zlabel('kStep_z');  
    title('YarnBall Waveform');
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

Panel1(1,:) = {'BestCaseMaxSlew (mT/m)',PROJdgn.maxaveacc/42.577,'Output'};

Panel = [Panel0;Panel1];
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
TST.PanelOutput = PanelOutput;
TST.Panel2Imp = Panel0;    
    
