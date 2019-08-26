%==================================================
% 
%==================================================

function [CALC,err] = CalcSDC01_v1a_Func(CALC,INPUT)

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
% Calculate Constraint
%---------------------------------------------
[SDCmat] = SDCArr2Mat(SDC,PROJimp.nproj,PROJimp.npro);
CenVal = mean(SDCmat(:,1));
[SDC0mat] = SDCArr2Mat(SDC0,PROJimp.nproj,PROJimp.npro);
CenVal0 = mean(SDC0mat(:,1));
if CenVal >= CenVal0
    CenValdir = 1;
else
    CenValdir = 0; 
end
%if j == 1
%    maxrelchange = 1.1; 
%elseif xor(logical(CenValdir),logical(CALC.CenValdir))
%    maxrelchange = 1+((CALC.maxrelchange-1)/10);
%else
%    maxrelchange = CALC.maxrelchange;
%end
maxrelchange = 1.1;

%---------------------------------------------
% Constrain
%---------------------------------------------
SDC(SDC > maxrelchange*SDC0) = maxrelchange*SDC0(SDC > maxrelchange*SDC0);
%SDC(SDC < (1/maxrelchange)*SDC0) = (1/maxrelchange)*SDC0(SDC < (1/maxrelchange)*SDC0);
SDC(SDC < (2-maxrelchange)*SDC0) = (2-maxrelchange)*SDC0(SDC < (2-maxrelchange)*SDC0);

figure(56);
rSDCchg = SDC./SDC0;
[rSDCchgmat] = SDCArr2Mat(rSDCchg,PROJimp.nproj,PROJimp.npro);
plot(mean(rSDCchgmat,1),'r*');
title('relative SDC change');

%---------------------------------------------
% Return
%---------------------------------------------
CALC.CenValdir = CenValdir;
CALC.maxrelchange = maxrelchange;
CALC.SDC = SDC;

