%==================================================
% 
%==================================================

function [NGH] = mFindNghbrsCUDA_v1(Kmat,W,AIDrp) 

%----
W = W/2;                        % W = width from centre to edge of kernel...
%----

Kx = Kmat(:,:,1)/AIDrp.kstep;                 
Ky = Kmat(:,:,2)/AIDrp.kstep;  
Kz = Kmat(:,:,3)/AIDrp.kstep;
	
rad = mean(sqrt(Kx.^2 + Ky.^2 + Kz.^2));

Radinds = zeros(2,AIDrp.npro);
radsep = zeros(1,AIDrp.npro);
for i = 1:AIDrp.npro
    ind1 = find((rad(i)-(W*1.8) <= rad) & (rad <= rad(i)+(W*1.8)),1,'first');
    Radinds(1,i) = ind1;                                   
    ind2 = find((rad(i)-(W*1.8) <= rad) & (rad <= rad(i)+(W*1.8)),1,'last');
    Radinds(2,i) = ind2;
    radsep(i) = ind2 - ind1;
end
AnlsV = max(radsep)*AIDrp.nproj;
%maxkxindlen = ceil(AnlsV/10);                        % perhaps a lookup table here...?  10 for 'normal'...      
maxkxindlen = ceil(AnlsV/1); 

dpts = floor(50e6/maxkxindlen);                     % and here?? -- maybe split into equal groups...?
if dpts > AIDrp.npro*AIDrp.nproj;
    dpts = AIDrp.npro*AIDrp.nproj;
end

%----------------------
Kx = single(Kx);
Ky = single(Ky);
Kz = single(Kz);
Radinds = single(Radinds - 1);      % for C
npro = single(AIDrp.npro);
nproj = single(AIDrp.nproj);
maxkxindlen = single(maxkxindlen);
dpts = single(dpts);
W = single(W);
%-----------------------

tic
[Kxinds Kxindlens test error] = FindXNghbrsCUDA_v1(Kx,Radinds,npro,nproj,maxkxindlen,W,dpts);
if not(strcmp(error,'no error'))
    error
    hello('theres a problem');
end
test1 = sum(Kxinds(maxkxindlen,:));
if test1 ~= 0 
    hello('theres a problem');
end
mem(1) = test(4)/1e6;
over(1) = maxkxindlen/max(Kxindlens);
%maxkyindlen = single(ceil(AnlsV/18));
maxkyindlen = single(ceil(AnlsV/1));

[Kyinds Kyindlens test error] = FindYNghbrsCUDA_v1(Ky,Kxinds,npro,nproj,maxkxindlen,maxkyindlen,Kxindlens,W,dpts);
if not(strcmp(error,'no error'))
    error
    hello('theres a problem');
end
test2 = sum(Kyinds(maxkyindlen,:));
if test2 ~= 0 
    hello('theres a problem');
end
mem(2) = test(4)/1e6;
over(2) = maxkyindlen/max(Kyindlens);
%maxkzindlen = single(ceil(AnlsV/20));
maxkzindlen = single(ceil(AnlsV/1));

[Kzinds Kzindlens test error] = FindYNghbrsCUDA_v1(Kz,Kyinds,npro,nproj,maxkyindlen,maxkzindlen,Kyindlens,W,dpts);
if not(strcmp(error,'no error'))
    error
    hello('theres a problem');
end
test3 = sum(Kzinds(maxkzindlen,:));
if test3 ~= 0 
    hello('theres a problem');
end
toc
mem(3) = test(4)/1e6;
over(3) = maxkzindlen/max(Kzindlens);
mem
over

NGH = cell(1,length(dpts));
for i = 1:dpts
    NGH{i} = uint32(Kzinds(1:Kzindlens(i),i)+1);
end



