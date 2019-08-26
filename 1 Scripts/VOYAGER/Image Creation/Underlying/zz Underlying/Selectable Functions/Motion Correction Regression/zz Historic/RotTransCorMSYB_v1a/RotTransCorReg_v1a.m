%=========================================================
% 
%=========================================================

function E = RotTransCorReg_v1a(V,Im0,Im)

rIm2 = Rotate3DMatrix_v1c(Im2,rotx(n),roty(m),rotz(p));
rIm2(rIm2 < imthresh) = 0;
%L1err(n,m,p) = sum(rIm2(:) - Im1(:));
L2err(n,m,p) = sum((rIm2(:) - Im1(:)).^2);

    
  