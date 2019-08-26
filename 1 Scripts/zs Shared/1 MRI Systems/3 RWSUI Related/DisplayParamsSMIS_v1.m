%=====================================================
% 
%=====================================================

function [errorflag,error] = DisplayParamsSMIS_v1(path)

error = '';
errorflag = 0;

DataSetOffset = 0;
nSets = 0;
[~,Pars] = ReadSMIS_v1(path,DataSetOffset,nSets);
set(findobj('tag','TestBox'),'string',Pars);
