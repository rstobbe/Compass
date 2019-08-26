%=========================================================
% 
%=========================================================

function [default] = CreateKurtImDicom_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    AnlzPath = [SCRPTPATHS.rootloc,''];
elseif strcmp(filesep,'/')
end
addpath(genpath(AnlzPath));

m = 1;
default{m,1}.entrytype = 'RunFunc';
default{m,1}.labelstr = 'FirstDicomFile';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc = 'SelectDicomFile_v2';
default{m,1}.runfuncinput = {SCRPTPATHS.outrootloc};
default{m,1}.runfuncoutput = {''};

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'b-values';
default{m,1}.entrystr = '0 500 1000 1500 2000 2500';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'b0 images';
default{m,1}.entrystr = '5';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Tot_Slices';
default{m,1}.entrystr = '6';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Tot_Directions';
default{m,1}.entrystr = '30';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Slice';
default{m,1}.entrystr = '1';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Direction';
default{m,1}.entrystr = '1';