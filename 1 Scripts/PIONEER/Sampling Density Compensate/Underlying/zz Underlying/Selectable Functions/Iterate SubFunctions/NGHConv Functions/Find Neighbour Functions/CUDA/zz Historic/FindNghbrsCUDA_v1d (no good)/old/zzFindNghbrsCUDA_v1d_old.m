%==================================================
% 
%==================================================

function [NGH,error,errorflag] = FindNghbrsCUDA_v1d(Kmat,W,AIDrp,Radinds,maxkxindlen,maxkyindlen,maxkzindlen,n,dpts) 

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
% Find Neighbors
%-----------------------------------------
NGH = cell(1,dpts);
dptb = (0:dpts:tdp-1);
dptt = [(dpts-1:dpts:tdp) tdp-1];
Dpts = int32(dptb(n):dptt(n));
memtst = 0;

tic
[Kxinds,Kxindlens,test,CUDA,error0] = FindXNghbrsCUDA_v1d(single(Kx),int32(Radinds),int32(npro),int32(nproj),...
                                                     int32(maxkxindlen),single(W),int32(Dpts),int32(memtst));
toc
if not(strcmp(error0,'no error'))
    error = ['Cuda: ',error0]; errorflag = 1; return;
end
test1 = sum(Kxinds(maxkxindlen,:));
if test1 ~= 0 
    error = 'Cuda: Kxindlen too short'; errorflag = 1; return;
end

tic
[Kyinds,Kyindlens,test,error0] = FindYZNghbrsCUDA_v1d(single(Ky),int32(Kxinds),int32(Kxindlens),int32(maxkxindlen),...
                                                     int32(npro),int32(nproj),int32(maxkyindlen),single(W),int32(Dpts),int32(memtst));
toc
if not(strcmp(error0,'no error'))
    error = ['Cuda: ',error0]; errorflag = 1; return;
end
test1 = sum(Kyinds(maxkyindlen,:));
if test1 ~= 0 
    error = 'Cuda: Kyindlen too short'; errorflag = 1; return;
end

tic
[Kzinds,Kzindlens,test,error0] = FindYZNghbrsCUDA_v1d(single(Kz),int32(Kyinds),int32(Kyindlens),int32(maxkyindlen),...
                                                     int32(npro),int32(nproj),int32(maxkzindlen),single(W),int32(Dpts),int32(memtst)); 
toc
if not(strcmp(error0,'no error'))
    error = ['Cuda: ',error0]; errorflag = 1; return;
end
test1 = sum(Kzinds(maxkzindlen,:));
if test1 ~= 0 
    error = 'Cuda: Kzindlen too short'; errorflag = 1; return;
end

tic
for i = 1:dpts
    NGH{i} = uint32(Kzinds(1:Kzindlens(i),i)+1);
end
toc
%whos


Status2('done','',2);




