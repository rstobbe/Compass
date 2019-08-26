%=========================================================
% 
%=========================================================

function [default] = DiffImConsolD2M_v1b_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    loadpath = [SCRPTPATHS.voyagerloc,'Image Conversion\Underlying\Selectable Functions\'];
elseif strcmp(filesep,'/')
end
loadfunc = 'LoadDiffImDicom_v1c';
addpath([loadpath,loadfunc]);

m = 1;
default{m,1}.entrytype = 'StatInput';
default{m,1}.labelstr = 'Image_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Average_Aves';
default{m,1}.entrystr = 'Yes';
default{m,1}.options = {'No','Yes'};

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Average_Dirs';
default{m,1}.entrystr = 'Yes';
default{m,1}.options = {'No','Yes'};

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'LoadDWIDicom';
default{m,1}.entrystr = loadfunc;
default{m,1}.searchpath = loadpath;
default{m,1}.path = [loadpath,loadfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'LoadIm';
default{m,1}.labelstr = 'Consolidate';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';