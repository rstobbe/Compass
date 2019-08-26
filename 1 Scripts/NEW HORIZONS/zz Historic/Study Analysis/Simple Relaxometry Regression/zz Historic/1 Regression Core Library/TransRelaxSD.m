function Y = TransRelaxSD(J,t)

J1 = 0.048;
J2 = 0.032;

Y = J(2)*(0.6*exp(-t*(J(1)+J1)) + 0.4*exp(-t*(J1+J2))); 

%Y = J(2)*(J(3)*(0.6*exp(-t*(J(1)+J1)) + 0.4*exp(-t*(J1+J2))) + (1-J(3))*exp(-t*J(4))); 




