%=====================================================
% Parse Parameters
%=====================================================

function [value] = ParseParsSMIS_v1(Params,token)

Params = [Params,'____________________________________________'];
t = strfind(Params,[token,',']);
if not(isempty(t))
    [value x] = strtok(Params(t+length(token)+2:t+50));
else
    t = strfind(Params,[':',token]);
    [value x] = strtok(Params(t+length(token)+2:t+50));
end
test = 0;


