%==================================================
% 
%==================================================

function [SCRPTipt,SCRPTGBL,err] = Plot_kSpaceOrtho_v1a(SCRPTipt,SCRPTGBL)

errnum = 1;
err.flag = 0;
err.msg = '';

KSA = squeeze(SCRPTGBL.KSA);
T = SCRPTGBL.PROJdgn.tro*SCRPTGBL.T/max(SCRPTGBL.T);
kmax = SCRPTGBL.PROJdgn.kmax;

figure(450); hold on; plot(T,squeeze(KSA(:,1))*kmax,'b','linewidth',2); xlabel('Real Time (ms)'); ylabel('(1/m)'); title('x k-space');
figure(451); hold on; plot(T,squeeze(KSA(:,2))*kmax,'b','linewidth',2); xlabel('Real Time (ms)'); ylabel('(1/m)'); title('y k-space');
figure(452); hold on; plot(T,squeeze(KSA(:,3))*kmax,'b','linewidth',2); xlabel('Real Time (ms)'); ylabel('(1/m)'); title('z k-space');