%=========================================================
% 
%=========================================================

function E = FitShimCoilsLin2z_v1a_Reg(V,INPUT)

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
SphWgts0 = zeros(17,length(V));
m = 1;
for n = 1:length(CalData)
    if strcmp(CalData(n).Shim,'tof') || ...
        strcmp(CalData(n).Shim,'z1c') || ...
       strcmp(CalData(n).Shim,'x1') || ...
       strcmp(CalData(n).Shim,'y1') || ...
       strcmp(CalData(n).Shim,'z2c')
            SphWgts0(:,m) = (V(m)/CalData(n).CalVal)*CalData(n).SphWgts;
            m = m+1;
    end
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
