%====================================================
%
%====================================================

function [default] = FidPreload_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    fidloadpath = [SCRPTPATHS.voyagerloc,'Fid PreLoad\Underlying\Selectable Functions\Fid Load\'];
    fidrearpath = [SCRPTPATHS.voyagerloc,'Fid PreLoad\Underlying\Selectable Functions\Fid Rearrange\'];
elseif strcmp(filesep,'/')
end
fidloadfunc = 'FidLoad_SiemensYB_v1a';
fidrearfunc = 'FidRearrange_UserMash_v1a';

m = 1;
default{m,1}.entrytype = 'OutputName';
default{m,1}.labelstr = 'Image_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'ScriptName';
default{m,1}.labelstr = 'Script_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'FidLoadfunc';
default{m,1}.entrystr = fidloadfunc;
default{m,1}.searchpath = fidloadpath;
default{m,1}.path = [fidloadpath,fidloadfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'FidRearrangefunc';
default{m,1}.entrystr = fidrearfunc;
default{m,1}.searchpath = fidrearpath;
default{m,1}.path = [fidrearpath,fidrearfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Image';
default{m,1}.labelstr = 'Create Image';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';

