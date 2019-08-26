%==================================================
% 
%==================================================

function [CACCT,err] = CAccTwkMeth1_v1a_Func(CACCT,INPUT)

Status2('busy','Calculate Tweak',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
r = INPUT.r;
AccProf = INPUT.AccProf;
clear INPUT;

%---------------------------------------------
% Tweak
%---------------------------------------------
V1 = CACCT.twkval1;
tc1 = CACCT.twktc1;
V2 = CACCT.twkval2;
tc2 = CACCT.twktc2;

AccAdj = ones(1,length(r)) - V1*exp(-r/tc1) - V2*exp(-r/tc2);
TwkAccProf = AccProf.*AccAdj;

%---------------------------------------------
% Return
%---------------------------------------------
CACCT.TwkAccProf = TwkAccProf;

Status2('done','',3);