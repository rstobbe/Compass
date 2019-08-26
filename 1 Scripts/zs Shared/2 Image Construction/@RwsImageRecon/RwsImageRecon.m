%================================================================
%  
%================================================================

classdef RwsImageRecon < handle

    properties (SetAccess = private)                    
        NumGpuUsed;        
        HSampDat; SampDatMemDims;
        HReconInfo; ReconInfoMemDims;
        HKernel; iKern; KernHw; KernelMemDims;
        HImageMatrix; ImageMatrixMemDims;
        HInvFilt; InvFiltMemDims;
    end
    methods 

%==================================================================
% Init
%==================================================================   
        function RECON = RwsImageRecon(NumGpuUsed)
            RECON.NumGpuUsed = uint64(NumGpuUsed);
        end

%==================================================================
% LoadKernelGpuMem
%   - suggested to clear 'Kernel' above - not needed in RAM
%   - function writes Kernel to all GPUs
%================================================================== 
        function LoadKernelGpuMem(RECON,Kernel,iKern,KernHw)
            if ~isa(Kernel,'single')
                error('Kernel must be in single format');
            end 
            RECON.iKern = uint64(iKern);
            RECON.KernHw = uint64(KernHw);
            sz = size(Kernel);
            RECON.KernelMemDims = uint64(sz);
            [RECON.HKernel,Error] = LoadKernelGpuMem(RECON.NumGpuUsed,Kernel);
            if not(strcmp(Error,'no error'))
                error(Error);
            end
        end          

%==================================================================
% AllocateReconInfoGpuMem
%   - ReconInfoMemDims: array of 3 (read x proj x 4 [x,y,z,sdc])
%   - function allocates ReconInfo space on all GPUs
%================================================================== 
        function AllocateReconInfoGpuMem(RECON,ReconInfoMemDims)    
            if ReconInfoMemDims(3) ~= 4
                error('ReconInfo dimensionality problem');  
            end
            RECON.ReconInfoMemDims = uint64(ReconInfoMemDims);
            [RECON.HReconInfo,Error] = AllocateReconInfoGpuMem(RECON.NumGpuUsed,RECON.ReconInfoMemDims);
            if not(strcmp(Error,'no error'))
                error(Error);
            end
        end         
        
%==================================================================
% LoadReconInfoGpuMem
%   - kMat -> already normalized
%   - ReconInfo: read x proj x 4 [x,y,z,sdc]
%   - function loads ReconInfo on all GPUs
%================================================================== 
        function LoadReconInfoGpuMem(RECON,ReconInfo)
            if ~isa(ReconInfo,'single')
                error('ReconInfo must be in single format');
            end       
            sz = size(ReconInfo);
            for n = 1:length(sz)
                if sz(n) ~= RECON.ReconInfoMemDims(n)
                    error('ReconInfo dimensionality problem');  
                end
            end
            [Error] = LoadReconInfoGpuMem(RECON.NumGpuUsed,RECON.HReconInfo,ReconInfo);
            if not(strcmp(Error,'no error'))
                error(Error);
            end
        end   

%==================================================================
% LoadReconInfoGpuMemAsync
%   - kMat -> already normalized
%   - ReconInfo: read x proj x 4 [x,y,z,sdc]
%   - function loads ReconInfo on all GPUs
%================================================================== 
        function LoadReconInfoGpuMemAsync(RECON,ReconInfo)
            if ~isa(ReconInfo,'single')
                error('ReconInfo must be in single format');
            end       
            sz = size(ReconInfo);
            for n = 1:length(sz)
                if sz(n) ~= RECON.ReconInfoMemDims(n)
                    error('ReconInfo dimensionality problem');  
                end
            end
            [Error] = LoadReconInfoGpuMemAsync(RECON.NumGpuUsed,RECON.HReconInfo,ReconInfo);
            if not(strcmp(Error,'no error'))
                error(Error);
            end
        end         
        
%==================================================================
% AllocateSampDatGpuMem
%   - SampDatMemDims: array of 2 (read x proj)
%   - function allocates SampDat space on all GPUs
%================================================================== 
        function AllocateSampDatGpuMem(RECON,SampDatMemDims)    
            for n = 1:length(SampDatMemDims)
                if isempty(RECON.ReconInfoMemDims)
                    error('AllocateReconInfoGpuMem first');
                end
                if SampDatMemDims(n) ~= RECON.ReconInfoMemDims(n)
                    error('SampDat dimensionality problem');  
                end
            end
            RECON.SampDatMemDims = uint64(SampDatMemDims);
            [RECON.HSampDat,Error] = AllocateSampDatGpuMem(RECON.NumGpuUsed,RECON.SampDatMemDims);
            if not(strcmp(Error,'no error'))
                error(Error);
            end
        end  

%==================================================================
% LoadSampDatGpuMemAsync
%   - SampDat: read x proj
%   - function loads SampDat on one GPU asynchronously
%================================================================== 
        function LoadSampDatGpuMemAsync(RECON,LoadGpuNum,SampDat)
            if LoadGpuNum > RECON.NumGpuUsed-1
                error('Specified ''LoadGpuNum'' beyond number of GPUs used');
            end
            LoadGpuNum = uint64(LoadGpuNum);
            if ~isa(SampDat,'single')
                error('SampDat must be in single format');
            end       
            sz = size(SampDat);
            for n = 1:length(sz)
                if sz(n) ~= RECON.SampDatMemDims(n)
                    error('SampDat dimensionality problem');  
                end
            end
            if isreal(SampDat)
                error('SampDat must be complex');
            end
            [Error] = LoadSampDatGpuMemAsync(LoadGpuNum,RECON.HSampDat,SampDat);
            if not(strcmp(Error,'no error'))
                error(Error);
            end
        end       
        
%==================================================================
% AllocateImageMatrixGpuMem
%   - inpute = array of 3 dimension sizes
%==================================================================                      
        function AllocateImageMatrixGpuMem(RECON,ImageMatrixMemDims)
            RECON.ImageMatrixMemDims = uint64(ImageMatrixMemDims);
            [RECON.HImageMatrix,Error] = AllocateImageMatrixGpuMem(RECON.NumGpuUsed,RECON.ImageMatrixMemDims);
            if not(strcmp(Error,'no error'))
                error(Error);
            end
        end          

%==================================================================
% GridSampDat
%==================================================================                      
        function GridSampDat(RECON,GpuNum)
            if GpuNum > RECON.NumGpuUsed-1
                error('Specified ''LoadGpuNum'' beyond number of GPUs used');
            end
            GpuNum = uint64(GpuNum);
            [Error] = GridSampDat(GpuNum,RECON.HSampDat,RECON.HReconInfo,RECON.HKernel,RECON.HImageMatrix,...
                                    RECON.SampDatMemDims,RECON.KernelMemDims,RECON.ImageMatrixMemDims,RECON.iKern,RECON.KernHw);
            if not(strcmp(Error,'no error'))
                error(Error);
            end
        end            
                
%==================================================================
% TestKernelInGpuMem
%   - Remember first GPU = 0
%================================================================== 
        function Kernel = TestKernelInGpuMem(RECON,TestGpuNum)
            if TestGpuNum > RECON.NumGpuUsed-1
                error('Specified ''TestGpuNum'' beyond number of GPUs used');
            end
            TestGpuNum = uint64(TestGpuNum);
            [Kernel,Error] = TestKernelInGpuMem(TestGpuNum,RECON.HKernel,RECON.KernelMemDims);
            if not(strcmp(Error,'no error'))
                error(Error);
            end
        end       
        
%==================================================================
% TestReconInfoInGpuMem
%   - Remember first GPU = 0
%================================================================== 
        function ReconInfo = TestReconInfoInGpuMem(RECON,TestGpuNum)
            if TestGpuNum > RECON.NumGpuUsed-1
                error('Specified ''TestGpuNum'' beyond number of GPUs used');
            end
            TestGpuNum = uint64(TestGpuNum);
            [ReconInfo,Error] = TestReconInfoInGpuMem(TestGpuNum,RECON.HReconInfo,RECON.ReconInfoMemDims);
            if not(strcmp(Error,'no error'))
                error(Error);
            end
        end        

%==================================================================
% TestSampDatInGpuMem
%   - Remember first GPU = 0
%================================================================== 
        function SampDat = TestSampDatInGpuMem(RECON,TestGpuNum)
            if TestGpuNum > RECON.NumGpuUsed-1
                error('Specified ''TestGpuNum'' beyond number of GPUs used');
            end
            TestGpuNum = uint64(TestGpuNum);
            [SampDat,Error] = TestSampDatInGpuMem(TestGpuNum,RECON.HSampDat,RECON.SampDatMemDims);
            if not(strcmp(Error,'no error'))
                error(Error);
            end
        end        
        
        
%==================================================================
% ReturnOneImageMatrixGpuMem
%================================================================== 
        function ImageMatrix = ReturnImageMatrixGpuMem(RECON,TestGpuNum)
            if TestGpuNum > RECON.NumGpuUsed-1
                error('Specified ''TestGpuNum'' beyond number of GPUs used');
            end
            TestGpuNum = uint64(TestGpuNum);
            [ImageMatrix,Error] = ReturnOneImageMatrixGpuMem(TestGpuNum,RECON.HImageMatrix,RECON.ImageMatrixMemDims);
            if not(strcmp(Error,'no error'))
                error(Error);
            end
        end 
        
%==================================================================
% CudaDeviceWait
%================================================================== 
        function CudaDeviceWait(RECON,GpuNum)
            if GpuNum > RECON.NumGpuUsed-1
                error('Specified ''GpuNum'' beyond number of GPUs used');
            end
            GpuNum = uint64(GpuNum);
            [Error] = CudaDeviceWait(GpuNum);
            if not(strcmp(Error,'no error'))
                error(Error);
            end
        end
                
    end
end
        