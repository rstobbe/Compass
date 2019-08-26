%=========================================================
% 
%=========================================================

function [default] = ImCon3DNonCart_v1b_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    imppath = [SCRPTPATHS.voyagerloc,'Image Creation\Underlying\Selectable Functions\Implementation Load\'];    
    reconpath = [SCRPTPATHS.voyagerloc,'Image Creation\Underlying\Selectable Functions\Construction Method\'];
    dataorgpath = [SCRPTPATHS.voyagerloc,'Image Creation\Underlying\Selectable Functions\Data Organize\'];   
    gridpath = [SCRPTPATHS.voyagerloc,'Image Creation\Underlying\zz Underlying\Selectable Functions\kSpace Gridding\'];    
    orientpath = [SCRPTPATHS.voyagerloc,'Image Creation\Underlying\Selectable Functions\Orient\'];
    returnfovpath = [SCRPTPATHS.voyagerloc,'Image Creation\Underlying\Selectable Functions\ReturnFov\'];
elseif strcmp(filesep,'/')
end
impfunc = 'ImpLoadCombined_v1a';
reconfunc = 'Recon3DGriddingReturnAll_v1k';
dataorgfunc = 'DataOrg_AsIs_v1a';
gridfunc = 'GridkSpace_LclKern_v1j';
orientfunc = 'Orient_Standard_v1b';
returnfovfunc = 'ReturnFov_Head_v1a';

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ImpLoadfunc';
default{m,1}.entrystr = impfunc;
default{m,1}.searchpath = imppath;
default{m,1}.path = [imppath,impfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'DataOrgfunc';
default{m,1}.entrystr = dataorgfunc;
default{m,1}.searchpath = dataorgpath;
default{m,1}.path = [dataorgpath,dataorgfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Gridfunc';
default{m,1}.entrystr = gridfunc;
default{m,1}.searchpath = gridpath;
default{m,1}.path = [gridpath,gridfunc];

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'InvFilt_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc1 = 'LoadInvFiltCur_v4b';
default{m,1}.(default{m,1}.runfunc1).curloc = 'D:\1 Scripts\zs Shared\zx Inverse Filters';
default{m,1}.runfunc2 = 'LoadInvFiltDef_v4b';
default{m,1}.(default{m,1}.runfunc2).defloc = 'D:\1 Scripts\zs Shared\zx Inverse Filters';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Orientfunc';
default{m,1}.entrystr = orientfunc;
default{m,1}.searchpath = orientpath;
default{m,1}.path = [orientpath,orientfunc];

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
