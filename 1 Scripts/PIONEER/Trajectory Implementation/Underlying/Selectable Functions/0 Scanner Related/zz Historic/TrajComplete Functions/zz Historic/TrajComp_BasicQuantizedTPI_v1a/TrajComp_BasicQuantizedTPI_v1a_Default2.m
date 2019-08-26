%=========================================================
% 
%=========================================================

function [default] = TrajComp_BasicQuantizedTPI_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    TENDpath = [SCRPTPATHS.pioneerloc,'\Trajectory Implementation\Underlying\zz Underlying\Selectable Functions\GWFM SubFunctions\TrajEnd Functions\']; 
elseif strcmp(filesep,'/')
end
TENDfunc = 'TrajEnd_LRrephase_v1d'; 

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'GSlew (mT/m/ms)';
default{m,1}.entrystr = '160';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'TEndfunc';
default{m,1}.entrystr = TENDfunc;
default{m,1}.searchpath = TENDpath;
default{m,1}.path = [TENDpath,TENDfunc];

