%==================================================
% 
%==================================================

function [PLOT,err] = Plot_SingleFidAnlz_v1a_Func(PLOT,INPUT)

Status2('busy','Plot Single Fid Anlz',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
MFEVO = INPUT.MFEVO;
clear INPUT;

field = '';
if isfield(MFEVO,'FIDANLZ')
    field = 'FIDANLZ';
end
if isempty(field)
    err.flag = 1;
    err.msg = 'File does not contain a ''SingleFID'' measurement';
    return
end

%-----------------------------------------------------
% Load Data
%-----------------------------------------------------
BG_expT = MFEVO.(field).Data.BG_expT;
BG_Bloc1 = MFEVO.(field).Data.BG_Bloc1;
BG_smthBloc1 = MFEVO.(field).BG_smthBloc1;
BG_PH1 = MFEVO.(field).Data.BG_PH1;
BG_Fid1 = MFEVO.(field).Data.BG_Fid1;

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
figure(1000); 
clr = 'k';

subplot(2,2,1); hold on;
plot([0 max(BG_expT)],[0 0],'k:'); 
plot(BG_expT,abs(BG_Fid1),'r-');
ylim([0 max(abs(BG_Fid1)*1.1)]);
xlabel('(ms)'); ylabel('FID Magnitude (arb)'); xlim([0 max(BG_expT)]); title('FID Decay');

subplot(2,2,2); hold on;
plot([0 max(BG_expT)],[0 0],'k:'); 
plot(BG_expT,BG_PH1,'r-');     
ylim([-max(abs(BG_PH1)*1.2) max(abs(BG_PH1)*1.2)]);
xlabel('(ms)'); ylabel('Phase Evolution (rads)'); xlim([0 max(BG_expT)]); title('Transient Phase');

subplot(2,2,3); hold on;
plot([0 max(BG_expT)],[0 0],'k:'); 
plot(BG_expT,BG_Bloc1*1000,'r');
plot(BG_expT,BG_smthBloc1*1000,'b');
ylim([-max(abs(BG_Bloc1*1000)*1.2) max(abs(BG_Bloc1*1000)*1.2)]);
xlabel('(ms)'); ylabel('Field Evolution (uT)'); xlim([0 max(BG_expT)]); title('Transient Fields');


set(gcf,'units','inches');
set(gcf,'position',[3 1 14 8]);


Status2('done','',2);
Status2('done','',3);