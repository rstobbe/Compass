%=========================================================
% 
%=========================================================

function [default] = B0ShimNaOldVarian_v1b_Default2(SCRPTPATHS)

global COMPASSINFO

if strcmp(filesep,'\')
    maskpath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\zz Underlying\Selectable Functions\Image Masking\'];
elseif strcmp(filesep,'/')
end
maskfunc = 'NoMask_v1a';

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

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Cal_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc1 = 'LoadScriptFileCur';
default{m,1}.(default{m,1}.runfunc1).curloc = COMPASSINFO.USERGBL.varianshimcalfile;
default{m,1}.runfunc2 = 'LoadScriptFileDef';
default{m,1}.(default{m,1}.runfunc2).defloc = COMPASSINFO.USERGBL.varianshimcalfile;
default{m,1}.searchpath = SCRPTPATHS.scrptshareloc;
default{m,1}.path = SCRPTPATHS.scrptshareloc;

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'AbsThresh (rel)';
default{m,1}.entrystr = '0.2';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'FreqThresh (Hz)';
default{m,1}.entrystr = '100';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Maskfunc';
default{m,1}.entrystr = maskfunc;
default{m,1}.searchpath = maskpath;
default{m,1}.path = [maskpath,maskfunc];

