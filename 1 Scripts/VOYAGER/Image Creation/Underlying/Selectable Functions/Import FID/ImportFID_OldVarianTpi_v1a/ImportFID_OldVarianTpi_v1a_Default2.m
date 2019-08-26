%=========================================================
% 
%=========================================================

function [default] = ImportFID_OldVarianTpi_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    addpath(genpath([SCRPTPATHS.voyagerloc,'Image Creation\Underlying\zz Common\'])); 
    dccorpath = [SCRPTPATHS.voyagerloc,'Image Creation\Underlying\Selectable Functions\DC Correction\'];
elseif strcmp(filesep,'/')
end
dccorfunc = 'DCcorPA_TrlFid_v1g';

m = 1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'FIDpath';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc1 = 'SelectFidDataCur_v4b';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.loc;
default{m,1}.runfunc2 = 'SelectFidDataDef_v4b';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.loc;
default{m,1}.searchpath = SCRPTPATHS.scrptshareloc;
default{m,1}.path = SCRPTPATHS.scrptshareloc;

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Visuals';
default{m,1}.entrystr = 'Yes';
default{m,1}.options = {'Yes','No'};

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'DCcorfunc';
default{m,1}.entrystr = dccorfunc;
default{m,1}.searchpath = dccorpath;
default{m,1}.path = [dccorpath,dccorfunc];

