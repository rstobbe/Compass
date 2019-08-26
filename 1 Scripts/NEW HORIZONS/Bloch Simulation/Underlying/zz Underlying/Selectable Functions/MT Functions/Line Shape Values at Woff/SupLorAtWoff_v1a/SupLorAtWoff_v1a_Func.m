%====================================================
% - 
%
%====================================================

function [LINEFUNC,err] = SupLorAtWoff_v1a_Func(LINEFUNC,INPUT)

Status2('busy','Define Line Function',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
woff = INPUT.woff*2*pi/1000;            % w1 & woff = rad/msec
T2 = INPUT.T2;
N = LINEFUNC.intN;

%---------------------------------------------
% Define Function (Formalism from Li (1997))
%---------------------------------------------
theta = linspace(0,pi/2,N);
func = sin(theta).*sqrt(2/pi).*(T2./abs(3*cos(theta).^2 - 1)).*exp(-2*(woff*T2./abs(3*cos(theta).^2 - 1)).^2);   % Li (1997)
%func = sin(theta).*sqrt(2/pi).*(T2./(3*cos(theta).^2 - 1)).*exp(-2*(woff*T2./(3*cos(theta).^2 - 1)).^2);   % Morrison (1995) - obvious error
lineshapeval = sum(func)*(pi/(2*N));

%---------------------------------------------
% Define Function (Formalism from Cercignani (2008))
%---------------------------------------------
%u = linspace(0,1,N);
%func = sqrt(2/pi).*(T2./abs(3*u.^2 - 1)).*exp(-2*(woff*T2./abs(3*u.^2 - 1)).^2);
%lineshapeval = sum(func)*(1/N);

LINEFUNC.lineshapeval = lineshapeval;

%Status2('done','',2);
%Status2('done','',3);



