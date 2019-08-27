%====================================================
%
%====================================================

function [Struct] = AddToPanelOutput_B9(Struct,label,value,type)

if isfield(Struct,'RWSUI')
    if not(isfield(Struct.RWSUI,'LocalOutput'))
        n = 1;
    else
        n = length(Struct.RWSUI.LocalOutput)+1;
    end
    Struct.RWSUI.LocalOutput(n).label = label;
    Struct.RWSUI.LocalOutput(n).value = value;
    Struct.RWSUI.LocalOutput(n).type = type;
else
    if isempty(Struct)
        n = 1;
    else
        n = length(Struct)+1;
    end
    Struct(n).label = label;
    Struct(n).value = value;
    Struct(n).type = type;
end        
