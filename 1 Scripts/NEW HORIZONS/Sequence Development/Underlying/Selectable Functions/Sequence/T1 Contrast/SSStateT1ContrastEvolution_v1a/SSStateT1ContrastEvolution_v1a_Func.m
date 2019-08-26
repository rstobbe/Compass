%=========================================================
% 
%=========================================================

function [TST,err] = SSStateT1ContrastEvolution_v1a_Func(TST,INPUT)

Status2('busy','Spoiled Steady State T1 Contrast',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
T1 = INPUT.NMR.T1;
TR = TST.TR;
Flip = TST.Flip;
clear INPUT;

%---------------------------------------------
% Test
%---------------------------------------------
if length(T1) ~= 2
    err.flag = 1;
    err.msg = 'Nmrfunc should have 2 T1 values';
    return
end

%---------------------------------------------
% Arrays
%---------------------------------------------
TRarr = (0.1:0.1:TR-0.1);
M = [1 1];
time = 0;
for m = 1:200
    M(end+1,:) = cos(pi*Flip/180)*M(end,:);
    M(end+1:end+length(TRarr),:) = 1-(1-M(end,:)).*exp(-[TRarr;TRarr].'./T1);
    time(end+1:end+length(TRarr)+1) = time(end)+[TRarr TR];   
end
MDif = M(:,2)-M(:,1);

% figure(100); hold on;
% plot(time,M);
% plot(time,-MDif)
% ylim([-1 1]);
% plot([0 time(end)],[0 0],'k:');

ind1 = length(time)-2*length(TRarr)-13;
ind2 = ind1 + length(TRarr)+23;
figure(100); hold on;
plot(time(ind1:ind2),M(ind1:ind2,:));
plot(time(ind1:ind2),MDif(ind1:ind2,:));
ylim([0 0.4]);
xlim([time(ind1) time(ind2)]);

ind = length(time)-length(TRarr)-1; 
MzDifEnd = MDif(ind)
SigDif = sin(pi*Flip/180)*MzDifEnd

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',TST.method,'Output'};
Panel(3,:) = {'MzDifTE',MzDifEnd,'Output'};
Panel(4,:) = {'SigDif',SigDif,'Output'};
TST.Panel = Panel;

Status2('done','',2);
Status2('done','',3);


