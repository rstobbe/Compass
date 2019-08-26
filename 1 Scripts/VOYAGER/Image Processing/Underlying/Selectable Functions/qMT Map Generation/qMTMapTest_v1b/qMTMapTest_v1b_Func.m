%===========================================
% 
%===========================================

function [IMG,err] = qMTMapTest_v1b_Func(IMG,INPUT)

Status2('busy','Test MT Regression',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Input
%---------------------------------------------
CALC = INPUT.CALC;
clear INPUT;

%---------------------------------------------
% Test 'Images'
%---------------------------------------------
Im = zeros(1,1,1,9);
Im(1,1,1,1) = 0.0808;
Im(1,1,1,2) = 0.0677;
Im(1,1,1,3) = 0.0559;
Im(1,1,1,4) = 0.1087;
Im(1,1,1,5) = 0.1093;
Im(1,1,1,6) = 0.0963;
Im(1,1,1,7) = 0.1339;
Im(1,1,1,8) = 0.1650;
Im(1,1,1,9) = 0.1602;
scale = 10;
Im = Im*scale;

%---------------------------------------------
% Test Sequences
%---------------------------------------------
SeqPrms(1).exrffa = 10;
SeqPrms(2).exrffa = 20;
SeqPrms(3).exrffa = 30;
SeqPrms(4).exrffa = 10;
SeqPrms(5).exrffa = 20;
SeqPrms(6).exrffa = 30;
SeqPrms(7).exrffa = 10;
SeqPrms(8).exrffa = 20;
SeqPrms(9).exrffa = 30;

SeqPrms(1).TR = 25;
SeqPrms(2).TR = 25;
SeqPrms(3).TR = 25;
SeqPrms(4).TR = 50;
SeqPrms(5).TR = 50;
SeqPrms(6).TR = 50;
SeqPrms(7).TR = 100;
SeqPrms(8).TR = 100;
SeqPrms(9).TR = 100;

for n = 1:9
    SeqPrms(n).exrfwoff = 0;
    SeqPrms(n).exrftau = 0.05;
    SeqPrms(n).NSteady = 100;
    SeqPrms(n).TE = 0.03;
end

%---------------------------------------------
% Sim Parameters
%---------------------------------------------
SimPrms.ExPulseN = 3;
SimPrms.RecN = 3;
SimPrms.RecordSS = 'No';

%---------------------------------------------
% MT Regression
%---------------------------------------------
func = str2func([IMG.calcfunc,'_Func']);  
INPUT.Im = Im;
INPUT.SeqPrms = SeqPrms;
INPUT.SimPrms = SimPrms;
INPUT.Mask = 1;
[CALC,err] = func(CALC,INPUT);
if err.flag
    return
end
clear INPUT;

%---------------------------------------------
% Return
%---------------------------------------------
IMG.Im = CALC.Im;


Status2('done','',2);
Status2('done','',3);

