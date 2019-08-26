%================================================================
%  
%================================================================

classdef (Abstract) VolunteerClass < handle
    
    properties (SetAccess = private)
        Name = '';
        DateScanned = '';
        Gender = '';
        Age = [];
        Rois = RoiClass;
        Lidx = 0;
    end
    
    methods

        %--------------------------------------------        
        % AddVolunteerName
        %--------------------------------------------
        function DAT = AddVolunteerName(DAT,Name)
            DAT.Name = Name;
        end

        %--------------------------------------------        
        % AddVolunteerInfo
        %--------------------------------------------
        function DAT = AddVolunteerInfo(DAT,DateScanned,Gender,Age)
            DAT.DateScanned = DateScanned;
            DAT.Gender = Gender;
            DAT.Age = Age;
        end
 
        %--------------------------------------------        
        % AddRoi
        %--------------------------------------------       
        function [DAT,err] = AddRoi(DAT,RoiName)
            err.flag = 0;
            for n = 1:DAT.Lidx
                if strcmp(DAT.Rois(n).Name,RoiName)
                    err.flag = 1;
                    err.msg = ['Attempt to add ',RoiName,' multiple times to same volunteer'];
                    return                                     
                end
            end          
            DAT.Lidx = DAT.Lidx + 1;
            L = RoiClass;
            L.AddRoiName(RoiName);
            DAT.Rois(DAT.Lidx) = L;
        end        

        %--------------------------------------------        
        % FindRoi
        %-------------------------------------------- 
        function [Rois,err] = FindRoi(DAT,RoiName)
            Rois = [];
            err.flag = 0;
            found = 0;
            for n = 1:DAT.Lidx
                if strcmp(DAT.Rois(n).Name,RoiName)
                    if found == 1
                        err.flag = 1;
                        err.msg = [RoiName,' exists multiple times in database'];
                        return
                    end
                    Rois = DAT.Rois(n);
                    found = 1;
                end
            end
            if found == 0
                err.flag = 1;
                err.msg = ['''',RoiName,''' does not exist in database'];
                return
            end
        end 

        %--------------------------------------------        
        % ReturnAllRoiValues
        %--------------------------------------------          
        function Value = ReturnAllRoiValues(DAT,MeasName)
            Value = [];
            for n = 1:DAT.Lidx
                for m = 1:DAT.Rois(n).Midx
                    if strcmp(DAT.Rois(n).Meas(m).Name,MeasName)
                        Value(n) = DAT.Rois(n).Meas(m).Value;
                    end
                end
            end
        end 

        %--------------------------------------------        
        % ReturnAllRoiNames
        %--------------------------------------------          
        function Names = ReturnAllRoiNames(DAT)
            Names = cell(0);
            for n = 1:DAT.Lidx
                Names{n} = DAT.Rois(n).Name;
            end
        end 

        %--------------------------------------------        
        % ReturnAllRoiVolumes
        %--------------------------------------------  
        function Value = ReturnAllRoiVolumes(DAT)
            Value = [];
            for n = 1:DAT.Lidx
                Value(n,:) = DAT.Rois(n).Volume;
            end
        end           
    end
               
end
        