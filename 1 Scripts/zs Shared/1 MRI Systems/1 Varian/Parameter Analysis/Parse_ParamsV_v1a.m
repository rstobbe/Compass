%=====================================================
% Parse Parameters
%=====================================================

function [value] = Parse_ParamsV_v1a(Text,param)

Text = [Text,'____________________________________________'];
t = strfind(Text,strcat(param,':'));
delimiters = [char(32),char(9),char(13),char(10)];
[value x] = strtok(Text(t+length(param)+2:t+50),delimiters);


