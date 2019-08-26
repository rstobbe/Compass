%=========================================================
% 
%=========================================================

function [default] = AddB0_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    B0path = [SCRPTPATHS.pioneerloc,'Analysis\Underlying\Selectable Functions\Simulated Imaging\Add Imaging Effects\B0 Functions\'];    
elseif strcmp(filesep,'/')
end
B0func = 'B0Add_v1a';
addpath([B0path,B0func]);

ImagingEffect_Name = '';

m = 1;
default{m,1}.entrytype = 'StatInput';
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
default{m,1}.labelstr = 'B0func';
default{m,1}.entrystr = B0func;
default{m,1}.searchpath = B0path;
default{m,1}.path = [B0path,B0func];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'AddImagingEffect';
default{m,1}.labelstr = 'Add_Effects';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Add';

