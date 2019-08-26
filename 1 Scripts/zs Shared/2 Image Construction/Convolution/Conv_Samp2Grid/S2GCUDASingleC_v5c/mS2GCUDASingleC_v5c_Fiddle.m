%==================================================
% (v5c)
%   - Mex now with Matlab's new complex API
%==================================================

function [CONV,err] = mS2GCUDASingleC_v5c(CONV,INPUT)

global FIGOBJS
global RWSUIGBL

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Setup 
%---------------------------------------------
if strcmp(INPUT.func,'Setup')
    
    %------------------------------------
    % CUDA Specifics
    %------------------------------------
    NumberGpus = CUDA.Index;
    ComputeCapability = str2double(CUDA.ComputeCapability);
    if ComputeCapability == 6.1 || ComputeCapability == 6.2
        CoresPerMultiProcessor = 128;
    end
    MultiprocessorCount = CUDA.MultiprocessorCount;
    TotalCoresInPlay = CoresPerMultiProcessor*MultiprocessorCount*NumberGpus;

    %------------------------------------
    % CUDA chunklen optimization (emperical testing)
    %------------------------------------
    if CONV.chW == 1
        chunklen = TotalCoresInPlay*100;                 
    else
        error;  % finish                    
    end

    %------------------------------------
    % Conv Kernel
    %------------------------------------
    CONV.iKern = int32(round(1e9*(1/(INPUT.GRD.KRNprms.res*INPUT.GRD.KRNprms.DesforSS)))/1e9);
    CONV.Kern = single(INPUT.GRD.KRNprms.Kern);
    CONV.chW = int32(ceil(((INPUT.KRNprms.W*INPUT.KRNprms.DesforSS)-2)/2));  
    CONV.Ksz = int32(INPUT.Ksz);
    CONV.chunklen = int32(chunklen);   

%---------------------------------------------
% ZeroFill k-Array
%---------------------------------------------
elseif strcmp(INPUT.func,'ZfKarr')


    KArr = ZFIL.subsamp*(KArr/ZFIL.kstep) + ZFIL.centre;                   
    shift = (ZF/2+1)-((ZFIL.Ksz+1)/2);
    KArr = KArr+shift;


    %------------------------------------
    % Zerofill to chunklen multiple
    %------------------------------------
    Len0 = length(INPUT.Kx0);
    CONV.Len = CONV.chunklen*ceil(Len0/double(CONV.chunklen));
    CONV.Kx = INPUT.Kx0(1)*ones(CONV.Len,1,'single');
    CONV.Ky = INPUT.Ky0(1)*ones(CONV.Len,1,'single');
    CONV.Kz = INPUT.Kz0(1)*ones(CONV.Len,1,'single');
    CONV.SampDat = complex(zeros(1,CONV.Len,'single'),zeros(1,CONV.Len,'single'));
    CONV.Kx(1:Len0) = single(INPUT.Kx0);
    CONV.Ky(1:Len0) = single(INPUT.Ky0);
    CONV.Kz(1:Len0) = single(INPUT.Kz0);

%---------------------------------------------
% Grid
%---------------------------------------------
elseif strcmp(INPUT.func,'Grid')

    %------------------------------------
    % CUDA Specifics
    %------------------------------------ 
    arr = (1:10);
    tab = strcmp(FIGOBJS.TABGP.SelectedTab.Title,RWSUIGBL.AllTabs);
    tab = arr(tab);
    if StatLev == 0
        Stathands = 0;
    elseif StatLev == 2
        Stathands = FIGOBJS.Status(tab,2);
    elseif StatLev == 3
        Stathands = FIGOBJS.Status(tab,3);
    end
    Status2('busy','CUDA',StatLev);

    %------------------------------------
    % Zerofill SampDat
    %------------------------------------
    CONV.SampDat = complex(zeros(1,CONV.Len,'single'),zeros(1,CONV.Len,'single'));    
    CONV.SampDat(1:length(INPUT.SampDat)) = INPUT.SampDat;

    %------------------------------------
    % Convolve
    %------------------------------------
    tic
    [CDat,Test,Error] = S2GCUDASingleC_v5c(SampDat,Kx,Ky,Kz,Kern,iKern,chW,Ksz,chunklen,Stathands);
    toc
    %Test
    %DataSumTest = sum(CDat(:))/1e6
    if not(strcmp(Error,'no error'))
        CUDAerror = Error
        error();
    end
    %error

end




Status2('done','',StatLev);
