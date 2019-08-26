
%Plot of transverse biexponential relaxation for Agar
%compared to that of Saline.

set(0,'RecursionLimit',500);
options = odeset('RelTol',1e-4,'AbsTol',[1e-4 1e-4]);

T2S = 25;                                                                       % Relaxation components of Agar.
T2F = 3;
T2W = 45                                                                        % Relaxation of Saline.
T2P = 1000;

TM = 100;                                                                        % Starting Value
 

[T,M] = ode45('bloch_biex_relax',[0 10],[0.4*TM 0.6*TM],options,T2S,T2F);      % Biexponential solved over 10 ms
M1 = M(:,1) + M(:,2);                                                          
M2 = TM*exp(-T/T2W);
M3 = TM*exp(-T/T2P);

figure(3);                                                                      % Biexponential relaxation of agar comared to saline                                                                  
plot(T,M1,'r',T,M2,'b',T,M3,'k','linewidth',3);

set(gca,'xticklabel',1,'fontsize',16);
set(gca,'xticklabelmode','auto');
xlabel('ms','fontsize',18);
ylabel('Mxy','fontsize',18);







