%=========================================================
% 
%=========================================================

function [default] = TrajComp_StepRespQuantizedTPI_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    TENDpath = [SCRPTPATHS.pioneerloc,'\Trajectory Implementation\Underlying\zz Underlying\Selectable Functions\GWFM SubFunctions\TrajEnd Functions\']; 
elseif strcmp(filesep,'/')
end
TENDfunc = 'TrajEnd_StandardSpoil_v1b'; 

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'TEndfunc';
default{m,1}.entrystr = TENDfunc;
default{m,1}.searchpath = TENDpath;
default{m,1}.path = [TENDpath,TENDfunc];

