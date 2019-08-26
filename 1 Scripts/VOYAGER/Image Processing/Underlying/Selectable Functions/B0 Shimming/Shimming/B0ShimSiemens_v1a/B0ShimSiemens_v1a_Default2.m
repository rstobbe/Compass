%=========================================================
% 
%=========================================================

function [default] = B0ShimSiemens_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    maskpath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\zz Underlying\Selectable Functions\Image Masking\'];
elseif strcmp(filesep,'/')
end
maskfunc = 'NoMask_v1a';

m = 1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Cal_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc1 = 'LoadMatFileCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = 'Y:\I NMR Centre\3.0T Prisma\Shimming\Calibration Files\';
default{m,1}.runfunc2 = 'LoadMatFileDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = 'Y:\I NMR Centre\3.0T Prisma\Shimming\Calibration Files\';
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

