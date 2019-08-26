%==================================================
% 
%==================================================

function [NGH,error,errorflag] = FindNghbrsCUDA_v1b(Kmat,W,AIDrp) 

NGH = {};
W = W/2;                        % W = width from centre to edge of kernel...
npro = AIDrp.npro;
nproj = AIDrp.nproj;

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
MemStart = [40e6 50e6];
AnlsV = max(radsep)*nproj;     
maxkxindlen = AnlsV;                  
dpts0 = floor(MemStart(1)/maxkxindlen);
N = ceil(npro*nproj/dpts0);
dptb = (0:N-1)*(npro*nproj/N);
dptt = (1:N)*(npro*nproj/N)-1;
for a = 1:2
    done = 0;
    for m = 1:8
        maxkxindlen0 = maxkxindlen;
        Dpts = (dptb(1):dptt(1));
        memtst = 1;
        [Kxinds Kxindlens test error0] = FindXNghbrsCUDA_v1b(single(Kx),int32(Radinds),int32(npro),int32(nproj),...
                                                             int32(maxkxindlen0),single(W),int32(Dpts),int32(memtst));
        if (strcmp(error0,'out of memory'))
            error = ['Cuda: ',error0]; errorflag = 1; return;
        end
        mem(1) = test(2)/1e6;
        Dpts = round((dptb(1:N)+dptt(1:N))/2);
        memtst = 0;
        [Kxinds Kxindlens test error0] = FindXNghbrsCUDA_v1b(single(Kx),int32(Radinds),int32(npro),int32(nproj),...
                                                             int32(maxkxindlen0),single(W),int32(Dpts),int32(memtst));
        if not(strcmp(error0,'no error'))
            error = ['Cuda: ',error0]; errorflag = 1; return;
        end   
        test1 = sum(Kxinds(maxkxindlen0,:));
        if test1 == 0 && done == 1
            maxkxindlen = round(1.025*max(single(Kxindlens)));
            break
        end
        if test1 ~= 0 
            N = N+1;
            done = 1;
        else
            maxkxindlen0 = max([1.05*single(Kxindlens) maxkxindlen0]);
            
            over(1) = maxkxindlen0/max(single(Kxindlens));
            
            maxkxindlen = ceil(maxkxindlen*frac); 
            dpts0 = floor(MemStart(a)/maxkxindlen);
            N = ceil(npro*nproj/dpts0);
        end
        dptb = (0:N-1)*(npro*nproj/N);
        dptt = (1:N)*(npro*nproj/N)-1;
    end
    if done == 0
        error = 'X calibration error'; errorflag = 1; return;
    end
    frac = 1;
    maxkyindlen = maxkxindlen;
    for m = 1:3    
        maxkyindlen = ceil(maxkyindlen*frac);
        Dpts = (dptb(1):dptt(1));
        memtst = 1;
        [Kyinds Kyindlens test error0] = FindYZNghbrsCUDA_v1b(single(Ky),int32(Kxinds),int32(Kxindlens),int32(maxkxindlen),...
                                                             int32(npro),int32(nproj),int32(maxkyindlen),single(W),int32(Dpts),int32(memtst));    
        if (strcmp(error0,'out of memory'))
            error = ['Cuda: ',error0]; errorflag = 1; return;
        end
        mem(2) = test(2)/1e6;
        Dpts = round((dptb(1:N)+dptt(1:N))/2);
        memtst = 0;
        [Kyinds Kyindlens test error0] = FindYZNghbrsCUDA_v1b(single(Ky),int32(Kxinds),int32(Kxindlens),int32(maxkxindlen),...
                                                             int32(npro),int32(nproj),int32(maxkyindlen),single(W),int32(Dpts),int32(memtst));

        if not(strcmp(error0,'no error'))
            error = ['Cuda: ',error0]; errorflag = 1; return;
        end   
        test1 = sum(Kyinds(maxkyindlen,:));
        if test1 ~= 0 
            error = 'Cuda: Memory Calibration Coding Problem'; errorflag = 1; return;
        end
        over(2) = maxkyindlen/max(single(Kyindlens));    
        frac = (1/over(2))^0.8;                                                     
    end
    frac = 1;
    maxkzindlen = maxkyindlen;
    for m = 1:3    
        maxkzindlen = ceil(maxkzindlen*frac);
        Dpts = (dptb(1):dptt(1));
        memtst = 1;
        [Kzinds Kzindlens test error0] = FindYZNghbrsCUDA_v1b(single(Kz),int32(Kyinds),int32(Kyindlens),int32(maxkyindlen),...
                                                             int32(npro),int32(nproj),int32(maxkzindlen),single(W),int32(Dpts),int32(memtst));    
        if (strcmp(error0,'out of memory'))
            error = ['Cuda: ',error0]; errorflag = 1; return;
        end
        mem(3) = test(2)/1e6;
        Dpts = round((dptb(1:N)+dptt(1:N))/2);
        memtst = 0;
        [Kzinds Kzindlens test error0] = FindYZNghbrsCUDA_v1b(single(Kz),int32(Kyinds),int32(Kyindlens),int32(maxkyindlen),...
                                                             int32(npro),int32(nproj),int32(maxkzindlen),single(W),int32(Dpts),int32(memtst));

        if not(strcmp(error0,'no error'))
            error = ['Cuda: ',error0]; errorflag = 1; return;
        end   
        test1 = sum(Kzinds(maxkzindlen,:));
        if test1 ~= 0 
            error = 'Cuda: Memory Calibration Coding Problem'; errorflag = 1; return;
        end
        over(3) = maxkzindlen/max(single(Kzindlens));    
        frac = (1/over(3))^0.8;                                                     
    end
end
test = 0;










for n = 1:N
    Dpts = int32(dptb(n):dptt(n));
    tic
    [Kxinds Kxindlens test error0] = FindXNghbrsCUDA_v1b(Kx,Radinds,npro,nproj,maxkxindlen,W,Dpts);
    if not(strcmp(error0,'no error'))
        error = ['Cuda: ',error0]; errorflag = 1; return;
    end
    test1 = sum(Kxinds(maxkxindlen,:));
    if test1 ~= 0 
        error = 'Cuda: Kxindlen too short'; errorflag = 1; return;
    end
    mem(1) = test(2)/1e6;
    over(1) = maxkxindlen/max(Kxindlens);
    
    %maxkyindlen = int32(ceil(AnlsV/18));
    maxkyindlen = int32(ceil(AnlsV/1));
    [Kyinds Kyindlens test error0] = FindYZNghbrsCUDA_v1b(Ky,Kxinds,Kxindlens,maxkxindlen,npro,nproj,maxkyindlen,W,Dpts);
    if not(strcmp(error0,'no error'))
        error = ['Cuda: ',error0]; errorflag = 1; return;
    end
    test1 = sum(Kyinds(maxkyindlen,:));
    if test1 ~= 0 
        error = 'Cuda: Kyindlen too short'; errorflag = 1; return;
    end
    mem(2) = test(4)/1e6;
    over(2) = maxkyindlen/max(Kyindlens);

    %maxkzindlen = single(ceil(AnlsV/20));
    maxkzindlen = single(ceil(AnlsV/1));
    [Kzinds Kzindlens test error] = FindYNghbrsCUDA_v1(Kz,Kyinds,npro,nproj,maxkyindlen,maxkzindlen,Kyindlens,W,dpts);
    if not(strcmp(error0,'no error'))
        error = ['Cuda: ',error0]; errorflag = 1; return;
    end
    test1 = sum(Kzinds(maxkzindlen,:));
    if test1 ~= 0 
        error = 'Cuda: Kzindlen too short'; errorflag = 1; return;
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
end


