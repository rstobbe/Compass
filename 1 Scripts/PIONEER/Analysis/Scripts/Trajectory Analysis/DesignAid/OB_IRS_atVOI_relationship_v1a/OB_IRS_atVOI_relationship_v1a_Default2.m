%=========================================================
% 
%=========================================================

function [default] = OB_IRS_atVOI_relationship_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    roipath = [SCRPTPATHS.pioneerloc,'Analysis\Underlying\Selectable Functions\Trajectory Analysis\Object Functions\'];
    obpath = [SCRPTPATHS.pioneerloc,'Analysis\Underlying\Selectable Functions\Trajectory Analysis\Object Functions\'];
elseif strcmp(filesep,'/')
end
roifunc = 'Object_Sphere_v1b';
obfunc = 'Object_Sphere_v1b';

m = 1;
default{m,1}.entrytype = 'OutputName';
default{m,1}.labelstr = 'Analysis_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'ScriptName';
default{m,1}.labelstr = 'Script_Name';
default{m,1}.entrystr = '';

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
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'ZeroFill';
default{m,1}.entrystr = '384';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ROIfunc';
default{m,1}.entrystr = roifunc;
default{m,1}.searchpath = roipath;
default{m,1}.path = [roipath,roifunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'OBfunc';
default{m,1}.entrystr = obfunc;
default{m,1}.searchpath = obpath;
default{m,1}.path = [obpath,obfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'analysis';
default{m,1}.labelstr = 'Run_Analysis';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';
