%=========================================================
% 
%=========================================================

function [default] = ImConst_3DNonCart_v1i_Default2(SCRPTPATHS)

global COMPASSINFO

if strcmp(filesep,'\')
    reconpath = [SCRPTPATHS.voyagerloc,'Image Creation\Underlying\Selectable Functions\Construction Method\'];
    dataorgpath = [SCRPTPATHS.voyagerloc,'Image Creation\Underlying\Selectable Functions\Data Organize\'];   
    returnfovpath = [SCRPTPATHS.voyagerloc,'Image Creation\Underlying\Selectable Functions\ReturnFov\'];
    zerofillpath = [SCRPTPATHS.voyagerloc,'Image Creation\Underlying\Selectable Functions\ZeroFill\'];    
    kernselpath = [SCRPTPATHS.voyagerloc,'Image Creation\Underlying\Selectable Functions\Kernel Select\'];    
    orientpath = [SCRPTPATHS.voyagerloc,'Image Creation\Underlying\Selectable Functions\Orient\'];
elseif strcmp(filesep,'/')
end
reconfunc = 'Recon_3DGriddingSuperDefault_v2n';
dataorgfunc = 'DataOrg_NoOverProj_v1a';
returnfovfunc = 'ReturnFov_Design_v1a';
zerofillfunc = 'ZeroFill_Minimum_v1a';
kernselfunc = 'KernSlct_1p6_v1a';
orientfunc = 'Orient_VarianPA_v1a';

m = 1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Recon_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc1 = 'LoadTrajImpCur';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.runfunc2 = 'LoadTrajImpDef';
default{m,1}.(default{m,1}.runfunc2).defloc = COMPASSINFO.USERGBL.trajreconloc;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'KernSlctfunc';
default{m,1}.entrystr = kernselfunc;
default{m,1}.searchpath = kernselpath;
default{m,1}.path = [kernselpath,kernselfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ZeroFillfunc';
default{m,1}.entrystr = zerofillfunc;
default{m,1}.searchpath = zerofillpath;
default{m,1}.path = [zerofillpath,zerofillfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'DataOrgfunc';
default{m,1}.entrystr = dataorgfunc;
default{m,1}.searchpath = dataorgpath;
default{m,1}.path = [dataorgpath,dataorgfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ReturnFovfunc';
default{m,1}.entrystr = returnfovfunc;
default{m,1}.searchpath = returnfovpath;
default{m,1}.path = [returnfovpath,returnfovfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Reconfunc';
default{m,1}.entrystr = reconfunc;
default{m,1}.searchpath = reconpath;
default{m,1}.path = [reconpath,reconfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Orientfunc';
default{m,1}.entrystr = orientfunc;
default{m,1}.searchpath = orientpath;
default{m,1}.path = [orientpath,orientfunc];
