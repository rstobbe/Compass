function NMI = NormalizedMutualInfo(x,y,bins)

Pxy = nonzeros(histcounts2(x,y,bins));
Pxy = Pxy/sum(Pxy(:));
Hxy = -sum(Pxy(:).*log2(Pxy(:)));

Px = nonzeros(histcounts(x,bins));
Px = Px/sum(Px(:));
Hx = -sum(Px(:).*log2(Px(:)));

Py = nonzeros(histcounts(y,bins));
Py = Py/sum(Py(:));
Hy = -sum(Py(:).*log2(Py(:)));

MI = Hx + Hy - Hxy;

NMI = MI/sqrt(Hx*Hy);



