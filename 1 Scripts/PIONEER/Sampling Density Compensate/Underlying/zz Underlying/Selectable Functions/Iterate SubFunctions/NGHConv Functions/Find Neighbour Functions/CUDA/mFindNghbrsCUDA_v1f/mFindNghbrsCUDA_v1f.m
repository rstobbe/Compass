%==================================================
% 
%==================================================

function [NGH,error,errorflag] = mFindNghbrsCUDA_v1f(Kmat,W,AIDrp) 

error = '';
errorflag = 0;
NGH = {};
Status2('busy','',2);
Status2('busy','',3);

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
if AIDrp.nproj == 1
    rad = (sqrt(Kx.^2 + Ky.^2 + Kz.^2));
else
    rad = mean(sqrt(Kx.^2 + Ky.^2 + Kz.^2));
end

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
% Testing
%-----------------------------------------
[CUDA,error] = QueryReset_v1f();
Status2('busy',['Find Neighbours (',CUDA.Name,')'],2);
if not(isempty(error))
    Status2('error',error,3);
    errorflag = 1;
    return;
end

go = 1;
start0 = 0;
stop0 = -1;
start = 0;
Mem = CUDA.Gblmem - 250e6;
MemScl = 1;
MemOut = 20e6;
NGH = cell(1,tdp);
%brk = 1;
%first = 1;
%step = 50;
step = 25;
while go == 1
    if start > stop0    
        %[CUDA,error] = QueryReset_v1f();
        MaxXNghbrs = max(radsep)*nproj; MaxYNghbrs = MaxXNghbrs; MaxZNghbrs = MaxXNghbrs;
        stop0 = start0 + step*254;                % maybe should set based on radius size...
        if stop0 >= tdp
            stop0 = tdp-1;
        end
        Dpts = (start0:step:stop0);
        Dptlen = length(Dpts);
        start0 = stop0+step;
        TstIn = 1;
        slmults = [1.2,2.0,1.4];
        [~,~,test,error] = FindNghbrsCUDA_v1f(single(Kx),single(Ky),single(Kz),int32(Radinds),int32(npro),int32(nproj),...
                                                        single(W),int32(MaxXNghbrs),int32(MaxYNghbrs),int32(MaxZNghbrs),...
                                                        int32(Dpts),int32(Dptlen),int32(TstIn),single(slmults));
        if not(isempty(error))
            Status2('error',error,3);
            errorflag = 1;
            return;
        end
        MaxXNghbrs = test(3); MaxYNghbrs = test(6); MaxZNghbrs = test(9);
        if not(stop0 == (tdp-1))
            Mem = test(8);
        end
        if MemOut < 10e6
            MemScl = MemScl*0.95;            
        elseif MemOut < 15e6 && MemOut > 10e6
            MemScl = MemScl*0.98;
        elseif MemOut < 20e6 && MemOut > 15e6
            MemScl = MemScl*0.99;
        elseif MemOut > 30e6 && MemOut < 60e6
            MemScl = MemScl*1.01;
        elseif MemOut > 60e6 && MemOut < 120e6
            MemScl = MemScl*1.03;
        elseif MemOut > 120e6
            MemScl = MemScl*1.1;
        end
        Dptlen = MemScl*(Mem/4)/(MaxXNghbrs + MaxYNghbrs);
    end
    stop = (start+Dptlen-1);
    if stop >= tdp
        stop = tdp-1;
        go = 0;
    end
    Status2('busy',['Data Points: ',num2str(stop+1)],3);
    Dpts = (start:1:stop);
    Dptlen = length(Dpts);
    TstIn = 0;
    slmults = [1.2,2.0,1.4];
    [NGH0,NGH0lens,test2,error] = FindNghbrsCUDA_v1f(single(Kx),single(Ky),single(Kz),int32(Radinds),int32(npro),int32(nproj),...
                                                   single(W),int32(MaxXNghbrs),int32(MaxYNghbrs),int32(MaxZNghbrs),...
                                                   int32(Dpts),int32(Dptlen),int32(TstIn),single(slmults));
    MemOut = test2(5)
    if not(isempty(error))
        Status2('error',error,3);
        errorflag = 1;
        return;
    end
    if (test2(3) >= MaxXNghbrs) || (test2(6) >= MaxYNghbrs) || (test2(9) >= MaxZNghbrs)
        errorflag = 1;
        Status2('error','CUDA: max neighbour search length too short',3);  % could be a bit smarter about this...
        return;
    end
    for i = 1:Dptlen
        NGH{start+i} = (NGH0(1:NGH0lens(i),i)+1);
    end
    NGHsize = whos('NGH');
    NGHmem = NGHsize.bytes
    %if NGHsize.bytes > 1e9
    %    last = stop;
    %    save(['NGH',num2str(brk)],'NGH','first','last');
    %    brk = brk + 1;
    %    clear NGH;
    %    NGH = cell(1,tdp);
    %    first = stop+1;
    %elseif (stop == tdp-1)
    %    last = stop;
    %    save(['NGH',num2str(brk)],'NGH','first','last');
    %end
    start = stop+1;
end
                                            
                                            
                                            
                                            
