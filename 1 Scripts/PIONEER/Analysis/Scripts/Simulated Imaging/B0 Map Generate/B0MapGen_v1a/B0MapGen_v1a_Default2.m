%=========================================================
% 
%=========================================================

function [default] = B0MapGen_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    b0mappath = [SCRPTPATHS.pioneerloc,'Analysis\Underlying\zz Underlying\Selectable Functions\Simulated Imaging\Imaging Effects\Off Resonance Functions\'];    
elseif strcmp(filesep,'/')
end
b0mapfunc = 'B0MapOffResSphere_v1d';

m = 1;
default{m,1}.entrytype = 'OutputName';
default{m,1}.labelstr = 'Map_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'ScriptName';
default{m,1}.labelstr = 'Script_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'ObMatSz';
default{m,1}.entrystr = '160';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SampFoV';
default{m,1}.entrystr = '280';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'B0Mapfunc';
default{m,1}.entrystr = b0mapfunc;
default{m,1}.searchpath = b0mappath;
default{m,1}.path = [b0mappath,b0mapfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Map';
default{m,1}.labelstr = 'Create_Map';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Create';

