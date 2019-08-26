%=========================================================
% 
%=========================================================

function [default] = WriteShimV_v1b_Default2(SCRPTPATHS)

global COMPASSINFO

m = 1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'VarianShim_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc1 = 'SelectGenericFileCur';
default{m,1}.(default{m,1}.runfunc1).curloc = COMPASSINFO.USERGBL.varianshimfile;
default{m,1}.runfunc2 = 'SelectGenericFileDef';
default{m,1}.(default{m,1}.runfunc2).defloc = COMPASSINFO.USERGBL.varianshimfile;
default{m,1}.searchpath = SCRPTPATHS.scrptshareloc;
default{m,1}.path = SCRPTPATHS.scrptshareloc;