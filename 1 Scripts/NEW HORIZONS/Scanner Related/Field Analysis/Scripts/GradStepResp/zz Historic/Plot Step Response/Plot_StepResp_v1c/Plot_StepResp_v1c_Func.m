%==================================================
% 
%==================================================

function [PLOT,err] = Plot_StepResp_v1c_Func(PLOT,INPUT)

Status('busy','Plot Step Response');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
GRD = INPUT.GRD;
EDDY = INPUT.EDDY;
clear INPUT;

%-----------------------------------------------------
% Get Gradient Info
%-----------------------------------------------------
L = GRD.L;
Gvis = GRD.Gvis;

%-----------------------------------------------------
% Get Transient Field Info
%-----------------------------------------------------
Time = EDDY.Time;
Geddy = EDDY.Geddy;
if strcmp(PLOT.dir,'Neg')
    Geddy = -Geddy;
end

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
clf(figure(1000));
figure(1000); hold on; 
plot([0 max(Time)],[0 0],'k:'); 
for n = 1:length(Geddy(:,1));
    plot(L,Gvis(n,:),'b-');
    plot(Time,Geddy(n,:),'k');
end
xlabel('(ms)'); ylabel('Gradient Evolution (mT/m)');


