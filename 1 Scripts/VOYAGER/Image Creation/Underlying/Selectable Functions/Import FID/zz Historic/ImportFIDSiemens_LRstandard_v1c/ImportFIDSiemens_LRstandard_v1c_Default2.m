%=========================================================
% 
%=========================================================

function [default] = ImportFIDSiemens_LRstandard_v1c_Default2(SCRPTPATHS)

global COMPASSINFO

if strcmp(filesep,'\')
    addpath(genpath([SCRPTPATHS.voyagerloc,'Image Creation\Underlying\zz Common\'])); 
    dccorpath = [SCRPTPATHS.voyagerloc,'Image Creation\Underlying\Selectable Functions\DC Correction\'];
elseif strcmp(filesep,'/')
end
dccorfunc = 'DCcor_None_v1a';

m = 1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Visuals';
default{m,1}.entrystr = 'Yes';
default{m,1}.options = {'Yes','No'};

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'FovAdjust';
default{m,1}.entrystr = 'Yes';
default{m,1}.options = {'Yes','No'};

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Data_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc1 = 'LoadSiemensDataCur';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.loc;
default{m,1}.(default{m,1}.runfunc1).defloc = COMPASSINFO.USERGBL.tempdataloc;
default{m,1}.runfunc2 = 'LoadSiemensDataDisp';
default{m,1}.searchpath = SCRPTPATHS.scrptshareloc;
default{m,1}.path = SCRPTPATHS.scrptshareloc;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'DCcorfunc';
default{m,1}.entrystr = dccorfunc;
default{m,1}.searchpath = dccorpath;
default{m,1}.path = [dccorpath,dccorfunc];

