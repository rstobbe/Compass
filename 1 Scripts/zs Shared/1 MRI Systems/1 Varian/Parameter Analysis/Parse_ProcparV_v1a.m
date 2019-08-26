%=====================================================
% Load Parse ProcPar
%=====================================================

function [Output] = Parse_ProcparV_v1a(Text,params)

Text = [Text,'____________________________________________'];

for n = 1:length(params)
    param = params{n};
    ind = strfind(Text,[char(10),param,' ']);
    if isempty(ind)
        Output{n} = [];
        continue
    end
    tText = Text(ind+1:ind+100);
    ind = strfind(tText,char(10));
    tText = tText(ind(1):ind(2));
    ind = strfind(tText,char(32));
    value = tText(ind(1)+1:end-1);
    if strcmp(value(1),'"')
        value = value(2:end-1);
    else
        value = str2double(value);
    end
    if isempty(value)
        Output{n} = [];
    else
        Output{n} = value;
    end
end
    
