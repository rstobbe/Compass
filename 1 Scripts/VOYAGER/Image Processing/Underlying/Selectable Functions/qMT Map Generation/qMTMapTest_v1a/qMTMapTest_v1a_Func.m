%===========================================
% 
%===========================================

function [IMG,err] = qMTMapTest_v1a_Func(IMG,INPUT)

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
Im = zeros(1,1,1,14);
Im(1,1,1,1) = 0.100;
Im(1,1,1,2) = 0.101;
Im(1,1,1,3) = 0.102;
Im(1,1,1,4) = 0.092;
Im(1,1,1,5) = 0.095;
Im(1,1,1,6) = 0.100;
Im(1,1,1,7) = 0.087;
Im(1,1,1,8) = 0.088;
Im(1,1,1,9) = 0.093;
Im(1,1,1,10) = 0.095;
Im(1,1,1,11) = 0.084;
Im(1,1,1,12) = 0.079;
Im(1,1,1,13) = 0.087;
Im(1,1,1,14) = 0.090;
scale = 10;
Im = Im*scale;

%---------------------------------------------
% Test Sequences
%---------------------------------------------
SeqPrms(1).satrffa = 200;
SeqPrms(2).satrffa = 200;
SeqPrms(3).satrffa = 200;
SeqPrms(4).satrffa = 400;
SeqPrms(5).satrffa = 400;
SeqPrms(6).satrffa = 400;
SeqPrms(7).satrffa = 600;
SeqPrms(8).satrffa = 600;
SeqPrms(9).satrffa = 600;
SeqPrms(10).satrffa = 600;
SeqPrms(11).satrffa = 800;
SeqPrms(12).satrffa = 800;
SeqPrms(13).satrffa = 800;
SeqPrms(14).satrffa = 800;

SeqPrms(1).satrfwoff = 1000;
SeqPrms(2).satrfwoff = 2500;
SeqPrms(3).satrfwoff = 7500;
SeqPrms(4).satrfwoff = 1000;
SeqPrms(5).satrfwoff = 2500;
SeqPrms(6).satrfwoff = 7500;
SeqPrms(7).satrfwoff = 1000;
SeqPrms(8).satrfwoff = 2500;
SeqPrms(9).satrfwoff = 5000;
SeqPrms(10).satrfwoff = 7500;
SeqPrms(11).satrfwoff = 1000;
SeqPrms(12).satrfwoff = 2500;
SeqPrms(13).satrfwoff = 5000;
SeqPrms(14).satrfwoff = 7500;

SeqPrms(1).satrftau = 15;
SeqPrms(2).satrftau = 15;
SeqPrms(3).satrftau = 15;
SeqPrms(4).satrftau = 15;
SeqPrms(5).satrftau = 15;
SeqPrms(6).satrftau = 15;
SeqPrms(7).satrftau = 15;
SeqPrms(8).satrftau = 15;
SeqPrms(9).satrftau = 15;
SeqPrms(10).satrftau = 15;
SeqPrms(11).satrftau = 15;
SeqPrms(12).satrftau = 15;
SeqPrms(13).satrftau = 15;
SeqPrms(14).satrftau = 15;

for n = 1:14
    SeqPrms(n).exrffa = 10;
    SeqPrms(n).exrfwoff = 0;
    SeqPrms(n).exrftau = 0.05;
    SeqPrms(n).TR = 50;
    SeqPrms(n).NSteady = 100;
    SeqPrms(n).TE = 2;
end
    
%---------------------------------------------
% MT Regression
%---------------------------------------------
func = str2func([IMG.calcfunc,'_Func']);  
INPUT.Im = Im;
INPUT.SeqPrms = SeqPrms;
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

