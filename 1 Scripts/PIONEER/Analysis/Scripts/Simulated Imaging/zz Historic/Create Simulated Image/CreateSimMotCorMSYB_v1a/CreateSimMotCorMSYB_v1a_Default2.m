%=========================================================
% 
%=========================================================

function [default] = CreateSimMotCorMSYB_v1a_Default2(SCRPTPATHS)

SCRPTPATHS.Vrootloc = 'D:\1 Scripts\VOYAGER\Set 1.1\';
if strcmp(filesep,'\')
    imagepath = [SCRPTPATHS.Vrootloc,'Image Creation\Underlying\Selectable Functions\Image Creation Via Gridding\'];    
    motcorpath = [SCRPTPATHS.Vrootloc,'Image Creation\Underlying\Selectable Functions\Motion Correction\']; 
elseif strcmp(filesep,'/')
end
imagefunc = 'ImageViaGriddingStandard_v1a';
motcorfunc = 'MotCorTotMSYB_v1a';
addpath([imagepath,imagefunc]);
addpath([motcorpath,motcorfunc]);

Image_Name = '';

m = 1;
default{m,1}.entrytype = 'StatInput';
default{m,1}.labelstr = 'Image_Name';
default{m,1}.entrystr = Image_Name;

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Imp_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc1 = 'LoadTrajImpCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.(default{m,1}.runfunc1).loadpanel = 'Yes';
default{m,1}.runfunc2 = 'LoadTrajImpDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;
default{m,1}.(default{m,1}.runfunc2).loadpanel = 'Yes';
default{m,1}.searchpath = SCRPTPATHS.rootloc;
default{m,1}.path = SCRPTPATHS.rootloc;

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'SDC_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc1 = 'LoadSDCCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.(default{m,1}.runfunc1).loadpanel = 'Yes';
default{m,1}.runfunc2 = 'LoadSDCDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;
default{m,1}.(default{m,1}.runfunc2).loadpanel = 'Yes';
default{m,1}.searchpath = SCRPTPATHS.rootloc;
default{m,1}.path = SCRPTPATHS.rootloc;

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'kSamp_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc1 = 'LoadkSampCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.runfunc2 = 'LoadkSampDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;
default{m,1}.searchpath = SCRPTPATHS.rootloc;
default{m,1}.path = SCRPTPATHS.rootloc;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'MotCorfunc';
default{m,1}.entrystr = motcorfunc;
default{m,1}.searchpath = motcorpath;
default{m,1}.path = [motcorpath,motcorfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ImageCreatefunc';
default{m,1}.entrystr = imagefunc;
default{m,1}.searchpath = imagepath;
default{m,1}.path = [imagepath,imagefunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'CreateImage';
default{m,1}.labelstr = 'CreateImage';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';

