%=========================================================
% 
%=========================================================

function [default] = ImportFIDV_SplitNaPA_v2a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    addpath(genpath([SCRPTPATHS.voyagerloc,'Image Creation\Underlying\zz Common\']));    
elseif strcmp(filesep,'/')
end

m = 1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'FIDpath';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc1 = 'SelectFidDataCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.loc;
default{m,1}.runfunc2 = 'SelectFidDataDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.loc;
default{m,1}.searchpath = SCRPTPATHS.scrptshareloc;
default{m,1}.path = SCRPTPATHS.scrptshareloc;