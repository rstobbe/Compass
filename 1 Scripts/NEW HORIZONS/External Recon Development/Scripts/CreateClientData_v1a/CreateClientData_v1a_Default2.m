%=========================================================
% 
%=========================================================

function [default] = CreateClientData_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    wrtdatpath = [SCRPTPATHS.newhorizonsloc,'External Recon Development\Underlying\Selectable Functions\BuildClientData Functions\'];
    loadrawpath = [SCRPTPATHS.newhorizonsloc,'External Recon Development\Underlying\Selectable Functions\LoadRawData Functions\'];
    loadkernpath = [SCRPTPATHS.newhorizonsloc,'External Recon Development\Underlying\Selectable Functions\LoadConvKern Functions\'];  
elseif strcmp(filesep,'/')
end
wrtdatfunc = 'BuildClientData_PreNormalized_v1a';
loadrawfunc = 'LoadRawData_Simulation_v1a';
loadkernfunc = 'LoadConvKern_Standard_v1a';

m = 1;
default{m,1}.entrytype = 'OutputName';
default{m,1}.labelstr = 'ClientDat_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'ScriptName';
default{m,1}.labelstr = 'Script_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Wrt_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc1 = 'LoadTrajImpCur';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.runfunc2 = 'LoadTrajImpDef';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'LoadRawDatafunc';
default{m,1}.entrystr = loadrawfunc;
default{m,1}.searchpath = loadrawpath;
default{m,1}.path = [loadrawpath,loadrawfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'LoadConvKernfunc';
default{m,1}.entrystr = loadkernfunc;
default{m,1}.searchpath = loadkernpath;
default{m,1}.path = [loadkernpath,loadkernfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'BuildClientDatafunc';
default{m,1}.entrystr = wrtdatfunc;
default{m,1}.searchpath = wrtdatpath;
default{m,1}.path = [wrtdatpath,wrtdatfunc];


m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'ClientData';
default{m,1}.labelstr = 'ClientData';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Create';

