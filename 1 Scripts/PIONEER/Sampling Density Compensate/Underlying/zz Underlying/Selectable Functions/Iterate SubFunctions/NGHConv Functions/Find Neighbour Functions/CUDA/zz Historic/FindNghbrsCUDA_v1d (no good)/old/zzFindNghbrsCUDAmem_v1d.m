%==================================================
% 
%==================================================

function [Radinds,maxkxindlen,maxkyindlen,maxkzindlen,N,dpts,error,errorflag] = FindNghbrsCUDAmem_v1d(Kmat,W,AIDrp) 

error = '';
errorflag = 0;
W = W/2;                        % W = width from centre to edge of kernel...
npro = AIDrp.npro;
nproj = AIDrp.nproj;
tdp = npro*nproj;

Kx = Kmat(:,:,1)/AIDrp.kstep;                 
Ky = Kmat(:,:,2)/AIDrp.kstep;  
Kz = Kmat(:,:,3)/AIDrp.kstep;

%-----------------------------------------
% Calculate Search Annuli
%-----------------------------------------
rad = mean(sqrt(Kx.^2 + Ky.^2 + Kz.^2));

Radinds = zeros(2,AIDrp.npro);
radsep = zeros(1,npro);
for i = 1:npro
    ind1 = find((rad(i)-(W*1.8) <= rad) & (rad <= rad(i)+(W*1.8)),1,'first');
    Radinds(1,i) = ind1;                                   
    ind2 = find((rad(i)-(W*1.8) <= rad) & (rad <= rad(i)+(W*1.8)),1,'last');
    Radinds(2,i) = ind2;
    radsep(i) = ind2 - ind1;
end
Radinds = Radinds - 1;               % for C

%-----------------------------------------
% Calibrate for GPU Memory
%-----------------------------------------
Mem = 150e6;  
AnlsV = max(radsep)*nproj;     
maxkxindlen = AnlsV;
Dpts = (round(tdp/200):round(tdp/100):tdp);
memtst = 0;
[Kxinds,Kxindlens,test,CUDA,error0] = FindXNghbrsCUDA_v1d(single(Kx),int32(Radinds),int32(npro),int32(nproj),...
                                                     int32(maxkxindlen),single(W),int32(Dpts),int32(memtst));
if not(strcmp(error0,'no error'))
    error = ['Cuda: ',error0]; errorflag = 1; return;
end 
test1 = sum(Kxinds(maxkxindlen,:));
if test1 == 0
    maxkxindlen = round(1.025*max(single(Kxindlens)));
end
[Kxinds,Kxindlens,test,CUDA,error0] = FindXNghbrsCUDA_v1d(single(Kx),int32(Radinds),int32(npro),int32(nproj),...
                                                     int32(maxkxindlen),single(W),int32(Dpts),int32(memtst));
if not(strcmp(error0,'no error'))
    error = ['Cuda: ',error0]; errorflag = 1; return;
end 
                                                 
N = ceil(tdp/(Mem/maxkxindlen));
dpts = 256*round((tdp/N)/256);
N = ceil(tdp/dpts);

Dpts = (1:dpts);
memtst = 1;
[~,~,test,CUDA,error0] = FindXNghbrsCUDA_v1d(single(Kx),int32(Radinds),int32(npro),int32(nproj),...
                                                     int32(maxkxindlen),single(W),int32(Dpts),int32(memtst));
if (strcmp(error0,'out of memory'))
    error = ['Cuda: ',error0]; errorflag = 1; return;
end
mem(1) = test(2)/1e6;

% Y
Dpts = (round(tdp/200):round(tdp/100):tdp);
maxkyindlen = maxkxindlen;
memtst = 0;        
[Kyinds,Kyindlens,~,error0] = FindYZNghbrsCUDA_v1d(single(Ky),int32(Kxinds),int32(Kxindlens),int32(maxkxindlen),...
                                                     int32(npro),int32(nproj),int32(maxkyindlen),single(W),int32(Dpts),int32(memtst));        
if not(strcmp(error0,'no error'))
    error = ['Cuda: ',error0]; errorflag = 1; return;
end 
test1 = sum(Kyinds(maxkyindlen,:));
if test1 == 0
    maxkyindlen = round(1.25*max(single(Kyindlens)));
end
[Kyinds,Kyindlens,~,error0] = FindYZNghbrsCUDA_v1d(single(Ky),int32(Kxinds),int32(Kxindlens),int32(maxkxindlen),...
                                                     int32(npro),int32(nproj),int32(maxkyindlen),single(W),int32(Dpts),int32(memtst));        
if not(strcmp(error0,'no error'))
    error = ['Cuda: ',error0]; errorflag = 1; return;
end 

Dpts = (1:dpts);
memtst = 1;
[~,~,test,error0] = FindYZNghbrsCUDA_v1d(single(Ky),int32(Kxinds),int32(Kxindlens),int32(maxkxindlen),...
                                                     int32(npro),int32(nproj),int32(maxkyindlen),single(W),int32(Dpts),int32(memtst)); 
if (strcmp(error0,'out of memory'))
    error = ['Cuda: ',error0]; errorflag = 1; return;
end
mem(2) = test(2)/1e6;

% - Z
Dpts = (round(tdp/200):round(tdp/100):tdp);
maxkzindlen = maxkyindlen;
memtst = 0;        
[Kzinds,Kzindlens,~,error0] = FindYZNghbrsCUDA_v1d(single(Kz),int32(Kyinds),int32(Kyindlens),int32(maxkyindlen),...
                                                     int32(npro),int32(nproj),int32(maxkzindlen),single(W),int32(Dpts),int32(memtst));        
if not(strcmp(error0,'no error'))
    error = ['Cuda: ',error0]; errorflag = 1; return;
end 
test1 = sum(Kzinds(maxkzindlen,:));
if test1 == 0
    maxkzindlen = round(1.025*max(single(Kzindlens)));
end
[Kzinds,Kzindlens,~,error0] = FindYZNghbrsCUDA_v1d(single(Kz),int32(Kyinds),int32(Kyindlens),int32(maxkyindlen),...
                                                     int32(npro),int32(nproj),int32(maxkzindlen),single(W),int32(Dpts),int32(memtst));        
if not(strcmp(error0,'no error'))
    error = ['Cuda: ',error0]; errorflag = 1; return;
end 

Dpts = (1:dpts);
memtst = 1;
[~,~,test,error0] = FindYZNghbrsCUDA_v1d(single(Kz),int32(Kyinds),int32(Kyindlens),int32(maxkyindlen),...
                                                     int32(npro),int32(nproj),int32(maxkzindlen),single(W),int32(Dpts),int32(memtst)); 
if (strcmp(error0,'out of memory'))
    error = ['Cuda: ',error0]; errorflag = 1; return;
end
mem(3) = test(2)/1e6


Status2('done','',2);




