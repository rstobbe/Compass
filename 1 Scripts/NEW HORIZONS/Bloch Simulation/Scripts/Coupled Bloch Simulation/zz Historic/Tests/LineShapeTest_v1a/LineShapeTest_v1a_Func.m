%=========================================================
% 
%=========================================================

function [SIMDES,err] = LineShapeTest_v1a_Func(SIMDES,INPUT)

Status('busy','Line Shape Test');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
LINEVAL = INPUT.LINEVAL;
clear INPUT

%----------------------------------------------------
% Create Line Shape Setup
%----------------------------------------------------
func = str2func([SIMDES.linevalfunc,'_Func']);  

%----------------------------------------------------
% Create Line Shape
%----------------------------------------------------
woff = (-500:1:500);
lineshape = zeros(size(woff));
for n = 1:length(woff)
    INPUT.T2 = SIMDES.T2;
    INPUT.woff = woff(n);
    [LINEVAL,err] = func(LINEVAL,INPUT);
    if err.flag
        return
    end
    clear INPUT;
    lineshape(n) = LINEVAL.lineshapeval;
end

test = sum(lineshape)

%---------------------------------------------
% Plot
%---------------------------------------------
figure(1); hold on;
plot(woff,lineshape,'b');
xlabel('w (Hz)');
ylabel('relative intensity');

