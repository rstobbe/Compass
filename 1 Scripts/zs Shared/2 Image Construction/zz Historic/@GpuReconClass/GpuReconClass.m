%================================================================
%  
%================================================================

classdef GpuReconClass < handle

    properties (SetAccess = private)                    
        HSampDatR;
        HSampDatI;
        HCrtDatC;
        HCrtDatCTemp;
        HKx;
        HKy;
        HKz;
        HKern;
        HStatus;
        iKern;
        chW;
        chunklen;
        GpuNum;
    end

%==================================================================
% Init
%==================================================================    
    methods 
        % GpuReconClass
        function GpuRecon = GpuReconClass()
            % empty for now
        end

%==================================================================
% S2G Convolution Functions
%==================================================================                
        % S2GsetupDC
        function bool = S2GsetupDC(GpuRecon,Kx,Ky,Kz,KERN,CrtDatSz,HStatus)
            bool = 1;
            GpuRecon.iKern = KERN.iKern;
            GpuRecon.chW = KERN.chW;
            GpuRecon.HStatus = HStatus;
            
            GpuRecon.chuncklen = 12345;
        
            [GpuRecon.HSampDatR,GpuRecon.HSampDatI,GpuRecon.HCrtDatC,GpuRecon.HCrtDatCTemp,...
             GpuRecon.HKx,GpuRecon.HKy,GpuRecon.HKz,GpuRecon.HKern,GpuRecon.GpuNum,error] = S2GsetupDC_v1a(Kx,Ky,Kz,KERN.Kern,CrtDatSz,HStatus);
        end
        % S2GloadsampDC
        function bool = S2GloadsampDC(GpuRecon,SampDat)
            bool = 1;
            [error] = S2GsetupDC_v1a(SampDat,GpuRecon.HSampDatR,GpuRecon.HSampDatI,GpuRecon.GpuNum,GpuRecon.HStatus);
        end
        % S2GconvDC
        function bool = S2GconvDC(GpuRecon)
            bool = 1;
            [error] = S2GconvDC_v1a(GpuRecon.HSampDatR,GpuRecon.HSampDatI,GpuRecon.HCrtDatC,GpuRecon.HCrtDatCTemp,...
                                    GpuRecon.HKx,GpuRecon.HKy,GpuRecon.HKz,GpuRecon.HKern,...
                                    GpuRecon.iKern,GpuRecon.chW,GpuRecon.chunklen,GpuRecon.HStatus);
        end
        % S2GreturnmatDC
        function CrtDatC = S2GreturnmatDC(GpuRecon)
            [CrtDatC,error] = S2GconvDC_v1a(GpuRecon.HCrtDatC,GpuRecon.HCrtDatCTemp,GpuRecon.HStatus);
        end
        % S2GteardownDC
        function S2GteardownDC(GpuRecon)
            [error] = S2GteardownDC_v1a(GpuRecon.HSampDatR,GpuRecon.HSampDatI,GpuRecon.HCrtDatC,GpuRecon.HCrtDatCTemp,...
                                    GpuRecon.HKx,GpuRecon.HKy,GpuRecon.HKz,GpuRecon.HKern,GpuRecon.HStatus);
        end
        
        
        
%==================================================================
% S2G Convolution Functions
%==================================================================           
    end
end
        