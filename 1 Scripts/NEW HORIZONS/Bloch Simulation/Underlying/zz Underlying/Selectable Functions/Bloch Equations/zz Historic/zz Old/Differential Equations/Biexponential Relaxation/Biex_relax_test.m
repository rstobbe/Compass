
%Plot of transverse biexponential relaxation for
%Agar.

set(0,'RecursionLimit',500);
options = odeset('RelTol',1e-4,'AbsTol',[1e-4 1e-4]);

T2S = 25;                                                                       % Relaxation components of Agar.
T2F = 3;

TM = 100;                                                                       % Starting Value

[T,M] = ode45('bloch_biex_relax',[0 30],[0.6*TM 0.4*TM],options,T2S,T2F);       % Biexponential solved over 10 ms
M1 = M(:,1) + M(:,2);                                                           

M2 = 60*exp(-T/T2F) + 40*exp(-T/T2S);                                           % Comparison to equation
M3 = 100*exp(-T*(0.6/T2F + 0.4/T2S));                                           % Geometric Mean

M4 = 100*exp(-T/T2S);                                                           % Slow component
M5 = 100*exp(-T/T2F);                                                           % Fast component


figure(1);                                                                      % Biexponential relaxation compared to its fast and slow components.                                                                   
plot(T,M1,'-',T,M4,'.',T,M5,'+');
















