%====================================================
%
%====================================================

function [default] = Imaging_NaPA_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    importpath = [SCRPTPATHS.rootloc,'Image Creation\Underlying\Selectable Functions\Import FID\'];
    dccorpath = [SCRPTPATHS.rootloc,'Image Creation\Underlying\Selectable Functions\PreProcess\DCcor Functions\'];
    createpath = [SCRPTPATHS.scrptshareloc,'3 Image Related\Scripts\Create Image\Projection Acquisition\'];
elseif strcmp(filesep,'/')
end
importfunc = 'ImportFIDV_NaPA_v1a';
dccorfunc = 'DCcor_trfid_v1a';
createfunc = 'CreateImagePA_v1a';
addpath([importpath,importfunc]);
addpath([dccorpath,dccorfunc]);
addpath([createpath,createfunc]);

m = 1;
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
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Imaging_NaPA';
default{m,1}.labelstr = 'Create Image';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';

