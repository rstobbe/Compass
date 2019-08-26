%===========================================
% 
%===========================================

function [B0SHIM,err] = CalB0SphHComp_v1a_Func(B0SHIM,INPUT)

Status2('busy','Compare Shim Calibration',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%--------------------------------------------- 
CalData1 = B0SHIM.CalData1;
CalData2 = B0SHIM.CalData2;

for n = 1:length(B0SHIM.CalData1)
    CalShims1{n} = CalData1(n).Shim;
    CalVals1(n) = CalData1(n).CalVal;
    CalShims2{n} = CalData1(n).Shim;
    CalVals2(n) = CalData2(n).CalVal;
    if n > 1
        resnorm1(n) = CalData1(n).resnorm;
        resnorm2(n) = CalData2(n).resnorm;
    end
    %z5(n) = CalData1(n).SphWgts(6);
end
CalShims1
CalVals1
CalShims2
CalVals2
resnorm1
resnorm2
%z5

for n = 1:length(CalData1)
    figure(100+n); hold on;
    plot(CalData1(n).SphWgts,'b*') 
    plot(CalData2(n).SphWgts,'r*') 
    title(CalData2(n).Shim);
end

Status2('done','',2);
Status2('done','',3);

