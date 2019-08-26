%=========================================================
% 
%=========================================================

function E = Fit3DegShimCoils4z_v1a_Reg(V,INPUT)

%---------------------------------------------
% Get Input
%---------------------------------------------
Im0 = INPUT.Im;
SPHs = INPUT.SPHs;
CalData = INPUT.CalData;
clear INPUT

%--------------------------------------------
% CalData
%--------------------------------------------
for n = 1:length(CalData)
    SphWgts0(:,n) = (V(n)/CalData(n).CalVal)*CalData(n).SphWgts;
end
SphWgts = sum(SphWgts0,2);

%--------------------------------------------
% Profile
%--------------------------------------------
for n = 1:17
    SPHs(:,:,:,n) = SPHs(:,:,:,n)*SphWgts(n);
end
Im = sum(SPHs,4);

%--------------------------------------------
% Error Vector
%--------------------------------------------
tE = Im(:) - Im0(:);

%--------------------------------------------
% Remove NaNs
%--------------------------------------------
E = tE(not(isnan(tE)));
%test = 0;
