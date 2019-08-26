%=========================================================
% 
%=========================================================

function [default] = MEOVatIrsNeiSnr_v1b_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    obpath = [SCRPTPATHS.pioneerloc,'Analysis\Underlying\Selectable Functions\Trajectory Analysis\MEOV Shapes\'];
elseif strcmp(filesep,'/')
end
obfunc = 'MEOV_Sphere_v1a';

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
default{m,1}.labelstr = 'TF_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc1 = 'LoadScriptFileCur';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.runfunc2 = 'LoadScriptFileDef';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'PSD_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc1 = 'LoadScriptFileCur';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.runfunc2 = 'LoadScriptFileDisp';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'IRS';
default{m,1}.entrystr = '0.8';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'rNEI';
default{m,1}.entrystr = '0.05';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SNR';
default{m,1}.entrystr = '18';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'ZeroFill';
default{m,1}.entrystr = '768';

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