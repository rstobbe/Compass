%=========================================================
% 
%=========================================================

function [default] = ImportFID_SiemensYB_v2h_Default2(SCRPTPATHS)

global COMPASSINFO

if strcmp(filesep,'\')
    optpath = [SCRPTPATHS.voyagerloc,'Image Creation\Underlying\Selectable Functions\Construction Method\'];
elseif strcmp(filesep,'/')
end
optfunc = 'ImportFidOpt_DoAveraging_v1a';

m = 1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Data_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc1 = 'LoadSiemensDataCur';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.experimentsloc;
default{m,1}.(default{m,1}.runfunc1).defloc = COMPASSINFO.USERGBL.tempdataloc;
default{m,1}.runfunc2 = 'LoadSiemensDataDisp';
default{m,1}.searchpath = SCRPTPATHS.scrptshareloc;
default{m,1}.path = SCRPTPATHS.scrptshareloc;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ImportFidOptfunc';
default{m,1}.entrystr = optfunc;
default{m,1}.searchpath = optpath;
default{m,1}.path = [optpath,optfunc];
