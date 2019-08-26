%==================================
% 
%==================================

function [CGC,err] = ConcomitantGradCalc_v1a_Func(CGC,INPUT)

Status2('busy','Calculate Concomitant Gradients',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
G = INPUT.G;
B0 = INPUT.B0;
z = INPUT.z;
y = INPUT.y;
x = INPUT.x;
clear INPUT;
   
%---------------------------------------------
% Calculate Bc
%---------------------------------------------
Gx = G(:,:,1);
Gy = G(:,:,2);
Gz = G(:,:,3);

Bc = ((Gx.^2 + Gy.^2)*z^2)/(2*B0) - (Gy*Gz*y*z)/(2*B0) - (Gx*Gz*x*z)/(2*B0) + (Gz^2*x^2)/(8*B0) + (Gz^2*y^2)/(8*B0);

%---------------------------------------------
% Return 
%---------------------------------------------
CGC.Bc;

Status2('done','',2);
Status2('done','',3);
