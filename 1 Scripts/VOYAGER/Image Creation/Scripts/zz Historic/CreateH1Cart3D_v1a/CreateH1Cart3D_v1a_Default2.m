%====================================================
%
%====================================================

function [default] = CreateH1Cart3D_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    importpath = [SCRPTPATHS.voyagerloc,'Image Creation\Underlying\Selectable Functions\Import FID\'];
    dccorpath = [SCRPTPATHS.voyagerloc,'Image Creation\Underlying\Selectable Functions\PreProcess\DCcor Functions\'];
    createpath = [SCRPTPATHS.voyagerloc,'Image Creation\Underlying\Selectable Functions\Image Creation\'];
elseif strcmp(filesep,'/')
end
importfunc = 'ImportFIDV_H1Cart3D_v1a';
dccorfunc = 'DCcor_trfid_v1b';
createfunc = 'Image3DCartStandard_v1a';
addpath([importpath,importfunc]);
addpath([dccorpath,dccorfunc]);
addpath([createpath,createfunc]);

Image_Name = '';

m = 1;
default{m,1}.entrytype = 'StatInput';
default{m,1}.labelstr = 'Image_Name';
default{m,1}.entrystr = Image_Name;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ImportFIDfunc';
default{m,1}.entrystr = importfunc;
default{m,1}.searchpath = importpath;
default{m,1}.path = [importpath,importfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'DCcorfunc';
default{m,1}.entrystr = dccorfunc;
default{m,1}.searchpath = dccorpath;
default{m,1}.path = [dccorpath,dccorfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'CreateImagefunc';
default{m,1}.entrystr = createfunc;
default{m,1}.searchpath = createpath;
default{m,1}.path = [createpath,createfunc];

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Orient';
default{m,1}.entrystr = '47T_Adj';
default{m,1}.options = {'47T_Adj',''};

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'TestPlots';
default{m,1}.entrystr = 'Off';
default{m,1}.options = {'On','Off'};

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Imaging';
default{m,1}.labelstr = 'Create Image';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';