%======================================================
% 
%======================================================

function [PLOT,err] = PLOT_MEOVatIrsNeiSnrArr_v1a_Func(PLOT,INPUT)

Status('busy','Plot MEOV');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
ANLZ = INPUT.ANLZ;
clear INPUT

%---------------------------------------------
% Plot
%---------------------------------------------
fh = figure(1234); hold on; box on;
plot(ANLZ.snr,ANLZ.meov/1000,'-');
ylabel('MEOV (cm3)');
xlabel('SNR');
ylim([0 20]);
fh.Units = 'inches';
fh.Position = [5 5 3 2.5];


%---------------------------------------------
% Return
%---------------------------------------------  
PLOT.ExpDisp = '';

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);