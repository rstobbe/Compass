%=========================================================
% 
%=========================================================

function [default] = DesMeth_TpiBasicOptions_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    tpitypepath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\TPI\TpiType Functions\']; 
    desoltimpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\TPI\DeSoltim Functions\']; 
    elippath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\TPI\Elip Functions\']; 
    testpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\TPI\DesTest Functions\'];    
elseif strcmp(filesep,'/')
end
elipfunc = 'Elip_Selection_v1a';
tpitypefunc = 'TpiType_SampDensDesign_v1b';
desoltimfunc = 'DeSolTim_TpiLookup_v1b';
testfunc = 'DesTest_TpiBasic_v1a';

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'TpiTypefunc';
default{m,1}.entrystr = tpitypefunc;
default{m,1}.searchpath = tpitypepath;
default{m,1}.path = [tpitypepath,tpitypefunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Elipfunc';
default{m,1}.entrystr = elipfunc;
default{m,1}.searchpath = elippath;
default{m,1}.path = [elippath,elipfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'DeSolTimfunc';
default{m,1}.entrystr = desoltimfunc;
default{m,1}.searchpath = desoltimpath;
default{m,1}.path = [desoltimpath,desoltimfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'DesTestfunc';
default{m,1}.entrystr = testfunc;
default{m,1}.searchpath = testpath;
default{m,1}.path = [testpath,testfunc];

