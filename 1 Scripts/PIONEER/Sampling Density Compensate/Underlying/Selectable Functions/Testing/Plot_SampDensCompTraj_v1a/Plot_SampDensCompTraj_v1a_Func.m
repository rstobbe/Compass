%==================================================
% 
%==================================================

function [PLOT,err] = Plot_SampDensCompTraj_v1a_Func(PLOT,INPUT)

Status2('busy','Plot SampDensCompTraj',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
N = PLOT.trajnum;
SDCS = INPUT.SDCS;
clear INPUT

test = SDCS.SDC(100000)
error

%-----------------------------------------------------
% Plot
%-----------------------------------------------------


% fh = figure(1000); hold on; box on;
% plot(L,Gvis(N,:,1),'b-'); plot(L,Gvis(N,:,2),'g-'); plot(L,Gvis(N,:,3),'r-');
% plot(L,Gmag,'k-');
% ylim([-15 15]);
% % xlim([0 5]);
% title(['Traj',num2str(N)]);
% xlabel('(ms)','fontsize',10,'fontweight','bold');
% ylabel('Gradients (mT/m)','fontsize',10,'fontweight','bold');
% fh.Units = 'inches';
% fh.Position = [5 5 3 2.4];


