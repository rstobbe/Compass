function Y = LongRelax(J,t)

J2 = 0.032;
J1 = 0.048;

Mo = J(1);

Y = Mo + (-0.85*Mo - Mo) * (0.2*exp(-t*2*J(2)) + 0.8*exp(-t*2*0.032));    % J(1) compensate for signal lost during RF pulse (i.e. quality of inversion)