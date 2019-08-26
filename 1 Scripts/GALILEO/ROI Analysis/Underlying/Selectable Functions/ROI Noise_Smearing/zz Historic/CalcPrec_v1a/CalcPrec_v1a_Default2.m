%=========================================================
% 
%=========================================================

function [default] = CalcPrec_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    sivpath = [SCRPTPATHS.pioneerloc,'Analysis\Underlying\Selectable Functions\Trajectory Analysis\SIV in ROI Functions\'];
elseif strcmp(filesep,'/')
end
sivfunc = 'SIVinROI_v1a';
addpath([sivpath,sivfunc]);

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SdvNoise';
default{m,1}.entrystr = '0';

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'PSD_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc1 = 'LoadMatFileCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.runfunc2 = 'LoadMatFileDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;
default{m,1}.searchpath = SCRPTPATHS.scrptshareloc;
default{m,1}.path = SCRPTPATHS.scrptshareloc;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'SIVinROIfunc';
default{m,1}.entrystr = sivfunc;
default{m,1}.searchpath = sivpath;
default{m,1}.path = [sivpath,sivfunc];
