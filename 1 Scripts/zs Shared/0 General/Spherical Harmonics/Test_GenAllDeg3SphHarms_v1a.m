%======================================================
% (v1a)
%
%======================================================

function Test_GenAllDeg3SphHarms_v1a

matsz = 32;
[SPHs] = GenAllDeg3SphHarms_v1a(matsz);

figure(1);
plot(squeeze(SPHs(16,16,:,4)));
