%=====================================================
% (v1b)
%   - facilitate arrayed values
%=====================================================

function [Output] = Parse_ProcparV_v1b(Text,params)

Text = [Text,'____________________________________________'];

for n = 1:length(params)
    param = params{n};
    ind = strfind(Text,[char(10),param,' ']);
    if isempty(ind)
        Output{n} = [];
        continue
    end
    tText = Text(ind+1:ind+150);
    ind = strfind(tText,char(10));
    tText = tText(ind(1):ind(2));
    ind = strfind(tText,char(32));
    numels = str2double(tText(1:ind(1)-1));
    m = 1;
    for p = 2:numels
        cellval{m} = tText(ind(p-1)+1:ind(p)-1);
        m = m+1;
    end
    if isempty(p)
        p = 1;
    end
    cellval{m} = tText(ind(p)+1:end-1);
    value = [];
    for p = 1:m
        strval = cellval{p};
        if strcmp(strval(1),'"')
            value{p} = strval(2:end-1);
        else
            value(p) = str2double(strval);
        end
    end
    if isempty(value)
        Output{n} = [];
    else
        Output{n} = value;
    end
end
    
