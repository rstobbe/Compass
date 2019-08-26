%====================================================
%
%====================================================

function [default] = CreateImage_v1b_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    importpath = [SCRPTPATHS.voyagerloc,'Image Creation\Underlying\Selectable Functions\Import FID\'];
    imconpath = [SCRPTPATHS.voyagerloc,'Image Creation\Underlying\Selectable Functions\Image Construction\'];
elseif strcmp(filesep,'/')
end
importfunc = 'ImportFIDV_fsemsuf_v2d';
imconfunc = 'ImCon2DCart_v1c';

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
default{m,1}.labelstr = 'ImportFIDfunc';
default{m,1}.entrystr = importfunc;
default{m,1}.searchpath = importpath;
default{m,1}.path = [importpath,importfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ImConstfunc';
default{m,1}.entrystr = imconfunc;
default{m,1}.searchpath = imconpath;
default{m,1}.path = [imconpath,imconfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Image';
default{m,1}.labelstr = 'Create Image';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';

