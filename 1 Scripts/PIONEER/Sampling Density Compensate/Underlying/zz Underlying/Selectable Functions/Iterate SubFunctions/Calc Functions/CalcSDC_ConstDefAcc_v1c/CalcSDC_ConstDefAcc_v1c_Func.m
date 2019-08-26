%==================================================
% 
%==================================================

function [CALC,err] = CalcSDC_ConstDefAcc_v1c_Func(CALC,INPUT)

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
acc = CALC.acc;

%---------------------------------------------
% Calculate SDC
%---------------------------------------------
SDC = ((double(DOV) ./ W).^acc) .* SDC0;                                      

%---------------------------------------------
% Disregard Negative
%---------------------------------------------
maxrelchange = CALC.maxrelchange;
SDC(SDC < 0) = SDC0(SDC < 0);

if not(isempty(find(SDC < 0,1)))
    error
end

%---------------------------------------------
% Constrain
%---------------------------------------------
SDC(SDC > maxrelchange*SDC0) = maxrelchange*SDC0(SDC > maxrelchange*SDC0);
SDC(SDC < (1/maxrelchange)*SDC0) = (1/maxrelchange)*SDC0(SDC < (1/maxrelchange)*SDC0);

%---------------------------------------------
% Return
%---------------------------------------------
CALC.maxrelchange = maxrelchange;
CALC.SDC = SDC;

