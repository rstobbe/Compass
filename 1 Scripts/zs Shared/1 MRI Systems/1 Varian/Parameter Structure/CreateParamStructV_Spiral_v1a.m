%=====================================================
% (v1a)
%   
%=====================================================

function [ExpPars,err] = CreateParamStructV_Spiral_v1a(Text)

err.flag = 0;
err.msg = '';

Text0 = Text;
while true
    ind1 = strfind(Text0,':');
    FieldName = Text0(1:ind1(1)-1);
    ind = strfind(FieldName,' ');
    for n = 1:length(ind)
        FieldName(ind(n)) = '_';
    end
    ind = strfind(FieldName,'-');
    for n = 1:length(ind)
        FieldName(ind(n)) = '_';
    end    
    Study.(FieldName) = Parse_ParamsV_v1a(Text0,Text0(1:ind1(1)-1));
    test = str2double(Study.(FieldName));
    if not(isnan(test))
        Study.(FieldName) = test;
    end
    ind2 = strfind(Text0,char(10));
    if ind2(1)+1 == ind2(2)
        Text0 = Text0(ind2(1)+2:end);
        break
    end
    Text0 = Text0(ind2(1)+1:end);
end

while true
    ind1 = strfind(Text0,':');
    FieldName = Text0(1:ind1(1)-1);
    ind = strfind(FieldName,' ');
    for n = 1:length(ind)
        FieldName(ind(n)) = '_';
    end
    ind = strfind(FieldName,'-');
    for n = 1:length(ind)
        FieldName(ind(n)) = '_';
    end    
    Setup.(FieldName) = Parse_ParamsV_v1a(Text0,Text0(1:ind1(1)-1));
    test = str2double(Setup.(FieldName));
    if not(isnan(test))
        Setup.(FieldName) = test;
    end
    ind2 = strfind(Text0,char(10));
    if ind2(1)+1 == ind2(2)
        Text0 = Text0(ind2(1)+2:end);
        break
    end
    Text0 = Text0(ind2(1)+1:end);
end

while true
    ind1 = strfind(Text0,':');
    FieldName = Text0(1:ind1(1)-1);
    ind = strfind(FieldName,' ');
    for n = 1:length(ind)
        FieldName(ind(n)) = '_';
    end
    ind = strfind(FieldName,'-');
    for n = 1:length(ind)
        FieldName(ind(n)) = '_';
    end    
    Sequence.(FieldName) = Parse_ParamsV_v1a(Text0,Text0(1:ind1(1)-1));
    test = str2double(Sequence.(FieldName));
    if not(isnan(test))
        Sequence.(FieldName) = test;
    end
    ind2 = strfind(Text0,char(10));
    if ind2(1)+1 == ind2(2)
        Text0 = Text0(ind2(1)+2:end);
        break
    end
    Text0 = Text0(ind2(1)+1:end);
end

while true
    ind1 = strfind(Text0,':');
    FieldName = Text0(1:ind1(1)-1);
    ind = strfind(FieldName,' ');
    for n = 1:length(ind)
        FieldName(ind(n)) = '_';
    end
    ind = strfind(FieldName,'-');
    for n = 1:length(ind)
        FieldName(ind(n)) = '_';
    end    
    Acq.(FieldName) = Parse_ParamsV_v1a(Text0,Text0(1:ind1(1)-1));
    test = str2double(Acq.(FieldName));
    if not(isnan(test))
        Acq.(FieldName) = test;
    end
    ind2 = strfind(Text0,char(10));
    if length(ind2)==1
        break
    end
    if ind2(1)+1 == ind2(2)
        Text0 = Text0(ind2(1)+2:end);
        break
    end
    Text0 = Text0(ind2(1)+1:end);
end

while true
    ind1 = strfind(Text0,':');
    FieldName = Text0(1:ind1(1)-1);
    ind = strfind(FieldName,' ');
    for n = 1:length(ind)
        FieldName(ind(n)) = '_';
    end
    ind = strfind(FieldName,'-');
    for n = 1:length(ind)
        FieldName(ind(n)) = '_';
    end    
    Acq.(FieldName) = Parse_ParamsV_v1a(Text0,Text0(1:ind1(1)-1));
    test = str2double(Acq.(FieldName));
    if not(isnan(test))
        Acq.(FieldName) = test;
    end
    ind2 = strfind(Text0,char(10));
    if length(ind2)==1
        break
    end
    Text0 = Text0(ind2(1)+1:end);
end

ExpPars.Study = Study;
ExpPars.Setup = Setup;
ExpPars.Sequence = Sequence;
ExpPars.Acq = Acq;
