%=========================================================
% 
%=========================================================

function [default] = AddNoiseT2_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    noisepath = [SCRPTPATHS.pioneerloc,'Analysis\Underlying\Selectable Functions\Simulated Imaging\Add Imaging Effects\Noise Functions\'];    
    t2path = [SCRPTPATHS.pioneerloc,'Analysis\Underlying\Selectable Functions\Simulated Imaging\Add Imaging Effects\Signal Decay Functions\']; 
elseif strcmp(filesep,'/')
end
noisefunc = 'NoiseAdd_v1a';
t2func = 'T2starAdd_v1a';
addpath([noisepath,noisefunc]);
addpath([t2path,t2func]);

ImagingEffect_Name = '';

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'ImagingEffect_Name';
default{m,1}.entrystr = ImagingEffect_Name;

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Imp_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc1 = 'LoadTrajImpCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.(default{m,1}.runfunc1).loadpanel = 'No';
default{m,1}.runfunc2 = 'LoadTrajImpDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;
default{m,1}.(default{m,1}.runfunc2).loadpanel = 'No';
default{m,1}.searchpath = SCRPTPATHS.scrptshareloc;
default{m,1}.path = SCRPTPATHS.scrptshareloc;

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'kSamp_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc1 = 'LoadkSampCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.runfunc2 = 'LoadkSampDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;
default{m,1}.searchpath = SCRPTPATHS.scrptshareloc;
default{m,1}.path = SCRPTPATHS.scrptshareloc;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'T2func';
default{m,1}.entrystr = t2func;
default{m,1}.searchpath = t2path;
default{m,1}.path = [t2path,t2func];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Noisefunc';
default{m,1}.entrystr = noisefunc;
default{m,1}.searchpath = noisepath;
default{m,1}.path = [noisepath,noisefunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'AddImagingEffect';
default{m,1}.labelstr = 'Add_Effects';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Add';

