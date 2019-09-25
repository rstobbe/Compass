%=========================================================
% 
%=========================================================

function NMI = CoregisterImages_v1a_Reg(V,REGFNC,INPUT)

%---------------------------------------------
% Get Input
%---------------------------------------------
StatIm = INPUT.StatIm;
JiggleIm = INPUT.JiggleIm;
clear INPUT

%---------------------------------------------
% Scale 'V's
%---------------------------------------------
V(1:3) = V(1:3)/10;
V(4:6) = V(4:6)*10;

%---------------------------------------------
% Transform Image
%---------------------------------------------
tic
JiggleIm2 = Transform3DMatrix_v1b(JiggleIm,V(1),V(2),V(3),V(4),V(5),V(6));
toc

%---------------------------------------------
% Calculate Normalized Mutual Info
%---------------------------------------------
bins = 50;
NMI = -NormalizedMutualInfo(StatIm(:),JiggleIm2(:),bins)

%StatIm = StatIm/max(StatIm(:));
%JiggleIm = JiggleIm/max(JiggleIm(:));
%NMItest1 = NormalizedMutualInfo(round(bins*StatIm(:)),round(bins*JiggleIm(:)),bins)
%NMItest0 = nmi(round(bins*StatIm(:)),round(bins*JiggleIm(:)))


  