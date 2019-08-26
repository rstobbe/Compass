%================================================================
%  
%================================================================

classdef RoiClass < handle

    properties (SetAccess = private)
        Name = '';
        Volume = [];
        Location = '';
        Meas = MeasurementClass;
        Midx = 0;
    end
    
    methods
        %--------------------------------------------        
        % AddRoiName
        %--------------------------------------------  
        function DAT = AddRoiName(DAT,Name)
            DAT.Name = Name;
        end

        %--------------------------------------------        
        % AddRoiInfo
        %--------------------------------------------  
        function DAT = AddRoiInfo(DAT,Volume,Location)
            DAT.Volume = Volume;
            DAT.Location = Location;
        end

        %--------------------------------------------        
        % AddMeas
        %-------------------------------------------- 
        function [DAT,err] = AddMeas(DAT,MeasName,Value)
            err.flag = 0;
            for n = 1:DAT.Midx
                if strcmp(DAT.Meas(n).Name,MeasName)
                    err.flag = 1;
                    err.msg = ['Attempt to add ',MeasName,' multiple times to same ROI'];
                    return    
                end
            end
            DAT.Midx = DAT.Midx+1;
            C = MeasurementClass;
            C.AddMeas(MeasName,Value);
            DAT.Meas(DAT.Midx) = C;
        end           

        %--------------------------------------------        
        % FindMeas
        %-------------------------------------------- 
        function [Meas,err] = FindMeas(DAT,MeasName)
            Meas = [];
            err.flag = 0;
            found = 0;
            for n = 1:DAT.Midx
                if strcmp(DAT.Meas(n).Name,MeasName)
                    if found == 1
                        err.flag = 1;
                        err.msg = [MeasName,' exists multiple times in database for this ROI'];
                        return
                    end
                    Meas = DAT.Meas(n);
                    found = 1;
                end
            end
            if found == 0
                err.flag = 1;
                err.msg = ['''',MeasName,''' does not exist in database for this ROI'];
                return
            end
        end 

end             
end
        