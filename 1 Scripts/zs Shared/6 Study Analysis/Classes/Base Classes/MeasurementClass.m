classdef MeasurementClass < handle

    properties (SetAccess = private)
        Name = '';
        Value = [];
    end
    
    methods
        function DAT = AddMeas(DAT,Name,Value)
            DAT.Name = Name;
            DAT.Value = Value;
        end     
    end              
end
        