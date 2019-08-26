%=========================================================
% 
%=========================================================

function [default] = GWFM_GSRA_v1e_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    GSRApath = [SCRPTPATHS.pioneerloc,'\Trajectory Implementation\Underlying\zz Underlying\Selectable Functions\GWFM SubFunctions\GSRA Functions\']; 
elseif strcmp(filesep,'/')
end
GSRAfunc = 'GSRA_TPIstandard_v2f'; 

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'GSRAfunc';
default{m,1}.entrystr = GSRAfunc;
default{m,1}.searchpath = GSRApath;
default{m,1}.path = [GSRApath,GSRAfunc];



