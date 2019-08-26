classdef MSVolunteerClass < VolunteerClass
    
    properties (SetAccess = private)
        MStype = '';
    end
    
    methods
        function DAT = AddMSInfo(DAT,MStype)
            DAT.MStype = MStype;
        end
    end
               
end
        