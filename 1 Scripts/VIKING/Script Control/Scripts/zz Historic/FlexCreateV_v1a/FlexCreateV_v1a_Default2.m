%====================================================
%
%====================================================

function [default] = FlexCreateV_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    createpath = [SCRPTPATHS.vikingloc,'Image Creation\Underlying\Selectable Functions\Folder Creation\'];
elseif strcmp(filesep,'/')
end
createfunc = 'NaCreatePlotV_v1a';

m = 1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Fid';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc1 = 'SelectFidDataCur';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.runfunc2 = 'SelectFidDataDef';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;
default{m,1}.searchpath = SCRPTPATHS.scrptshareloc;
default{m,1}.path = SCRPTPATHS.scrptshareloc;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Createfunc';
default{m,1}.entrystr = createfunc;
default{m,1}.searchpath = createpath;
default{m,1}.path = [createpath,createfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Image';
default{m,1}.labelstr = 'Create Folder';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';

