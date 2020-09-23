%================================================================
%  
%================================================================

classdef RoiCircleClass < handle

    properties (SetAccess = private)
        circleval;
    end
    
    methods
        function DAT = RoiCircleClass
            DAT.circleval = 0;
        end
        function DAT = SetCircleVal(DAT,circleval)
            DAT.circleval = circleval;
        end
    end  
end
        