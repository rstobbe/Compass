%=========================================================
% 
%=========================================================

function [default] = CalcObjPrecAcc_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    cvpath = [SCRPTPATHS.pioneerloc,'Analysis\Underlying\zz Underlying\Selectable Functions\Trajectory Analysis\CV Calculate Functions\'];
    roipath = [SCRPTPATHS.pioneerloc,'Analysis\Underlying\Selectable Functions\Trajectory Analysis\ROI Functions\'];
elseif strcmp(filesep,'/')
end
cvfunc = 'CVcalculate_v1b';
roifunc = 'ManipROI_DropEdges_v1a';

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SdvNoise';
default{m,1}.entrystr = '0';

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'PSF_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc1 = 'LoadScriptFileCur';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.runfunc2 = 'LoadScriptFileDef';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;
default{m,1}.searchpath = SCRPTPATHS.scrptshareloc;
default{m,1}.path = SCRPTPATHS.scrptshareloc;

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'PSD_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc1 = 'LoadScriptFileCur';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.runfunc2 = 'LoadScriptFileDef';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;
default{m,1}.searchpath = SCRPTPATHS.scrptshareloc;
default{m,1}.path = SCRPTPATHS.scrptshareloc;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'RoiManipfunc';
default{m,1}.entrystr = roifunc;
default{m,1}.searchpath = roipath;
default{m,1}.path = [roipath,roifunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'CVcalcfunc';
default{m,1}.entrystr = cvfunc;
default{m,1}.searchpath = cvpath;
default{m,1}.path = [cvpath,cvfunc];
