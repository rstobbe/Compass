%==================================================
% 
%==================================================

function [SCRPTipt,SCRPTGBL,err] = Plot_TrajVelAcc_v1a(SCRPTipt,SCRPTGBL)

errnum = 1;
err.flag = 0;
err.msg = '';

N = str2double(SCRPTipt(strcmp('TrajNum',{SCRPTipt.labelstr})).entrystr);

T = SCRPTGBL.T;
magaccpre = SCRPTGBL.PROJdgn.magaccpre;
magvelpre = SCRPTGBL.PROJdgn.magvelpre;
magaccpost = SCRPTGBL.PROJdgn.magaccpost;
magvelpost = SCRPTGBL.PROJdgn.magvelpost;
kstep = SCRPTGBL.PROJdgn.kstep;

figure(200); hold on; plot(T,magaccpre,'b','linewidth',2); xlim([0 T(length(T))]); ylim([0 100000]); xlabel('Real Time (ms)'); ylabel('Magnitude of Acceleration (1/(m*ms^2)'); title('Magnitude of Acceleration Through k-Space');
figure(201); hold on; plot(T,magaccpre,'b','linewidth',2); xlim([0 0.1]); ylim([0 100000]);  xlabel('Real Time (ms)'); ylabel('Magnitude of Acceleration (1/(m*ms^2)'); title('Magnitude of Acceleration Through k-Space');
figure(202); hold on; plot(T,magvelpre,'b','linewidth',2); xlim([0 T(length(T))]); ylim([0 1000]); xlabel('Real Time (ms)'); ylabel('Magnitude of Velocity (1/(m*ms)'); title('Magnitude of Velocity');
figure(203); hold on; plot(T,kstep./magvelpre,'b','linewidth',2); xlim([0 T(length(T))]); ylim([0 2*kstep/min(magvelpre(2:length(magvelpre)))]); xlabel('Real Time (ms)'); ylabel('Maximum Sampling Dwell'); title('Maximum Sampling Dwell');


figure(200); hold on; plot(T,magaccpost,'r','linewidth',2); ylim([0 10000]); xlabel('Real Time (ms)'); ylabel('Magnitude of Acceleration (1/(m*ms^2)'); title('Magnitude of Acceleration Through k-Space');
figure(201); hold on; plot(T,magaccpost,'r*-','linewidth',2); ylim([0 10000]); xlabel('Real Time (ms)'); ylabel('Magnitude of Acceleration (1/(m*ms^2)'); title('Magnitude of Acceleration Through k-Space');
figure(202); hold on; plot(T,magvelpost,'r','linewidth',2); xlabel('Real Time (ms)'); ylabel('Magnitude of Velocity (1/(m*ms)'); title('Magnitude of Velocity Through k-Space');
figure(203); hold on; plot(T,kstep./magvelpost,'r','linewidth',2); xlabel('Real Time (ms)'); ylabel('Maximum Sampling Dwell'); title('Maximum Sampling Dwell');
%ylim([0 2*kstep/max(magvelpost)]);
