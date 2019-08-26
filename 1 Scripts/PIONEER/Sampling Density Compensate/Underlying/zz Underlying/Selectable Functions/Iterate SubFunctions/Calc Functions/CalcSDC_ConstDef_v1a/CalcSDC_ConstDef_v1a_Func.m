%==================================================
% 
%==================================================

function [CALC,err] = CalcSDC_ConstDef_v1a_Func(CALC,INPUT)

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get INPUT
%---------------------------------------------
PROJimp = INPUT.IMP.PROJimp;
DOV = INPUT.DOV;
W = INPUT.W;
SDC0 = INPUT.SDC0;
j = INPUT.j;
clear INPUT

%---------------------------------------------
% Acceleration
%---------------------------------------------
acc = 1;

%---------------------------------------------
% Calculate SDC
%---------------------------------------------
SDC = ((double(DOV) ./ W).^acc) .* SDC0;                                      

%---------------------------------------------
% Positive Normalize
%---------------------------------------------
if not(isempty(find(SDC < 0,1)))
    error();
end 
SDC(SDC < 0) = 0.001;    

%---------------------------------------------
% Constrain
%---------------------------------------------
maxrelchange = CALC.maxrelchange;
SDC(SDC > maxrelchange*SDC0) = maxrelchange*SDC0(SDC > maxrelchange*SDC0);
SDC(SDC < (1/maxrelchange)*SDC0) = (1/maxrelchange)*SDC0(SDC < (1/maxrelchange)*SDC0);
%SDC(SDC < (2-maxrelchange)*SDC0) = (2-maxrelchange)*SDC0(SDC < (2-maxrelchange)*SDC0);

%---------------------------------------------
% Plot
%---------------------------------------------
%rSDCchg = SDC./SDC0;
%figure(55);
%plot(rSDCchg,'r*');
%title('relative SDC change');

%figure(56);
%[rSDCchgmat] = SDCArr2Mat(rSDCchg,PROJimp.nproj,PROJimp.npro);
%plot(mean(rSDCchgmat,1),'r*');
%title('mean relative SDC change');

%---------------------------------------------
% Return
%---------------------------------------------
CALC.maxrelchange = maxrelchange;
CALC.SDC = SDC;

