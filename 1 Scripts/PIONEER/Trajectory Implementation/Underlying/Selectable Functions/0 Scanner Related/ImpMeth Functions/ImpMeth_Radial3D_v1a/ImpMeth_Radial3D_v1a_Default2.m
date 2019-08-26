%=========================================================
% 
%=========================================================

function [default] = ImpMeth_Radial3D_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    imptypepath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\YarnBall\ImpType Functions\'];
    ProjSamppath = [SCRPTPATHS.pioneerloc,'Trajectory Implementation\Underlying\Selectable Functions\0 Scanner Related\ProjSamp Functions\YarnBall\'];
    TrajSamppath = [SCRPTPATHS.pioneerloc,'Trajectory Implementation\Underlying\Selectable Functions\0 Scanner Related\TrajSamp Functions\'];
    TrajEndpath = [SCRPTPATHS.pioneerloc,'\Trajectory Implementation\Underlying\zz Underlying\Selectable Functions\TrajEnd Functions\']; 
    KSMPpath = [SCRPTPATHS.pioneerloc,'\Trajectory Implementation\Underlying\Selectable Functions\1 ImCon Related\kSamp Functions\'];     
elseif strcmp(filesep,'/')
end
imptypefunc = 'ImpType_Radial3D_v1a';
TrajEndfunc = 'TrajEnd_HoldDrop_v11';
TrajSampfunc = 'TrajSamp_SiemensStandard_v3i';
KSMPfunc = 'kSamp_Standard_v1c';
ProjSampfunc = 'ProjSamp_Koosh_v1a';

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ImpTypefunc';
default{m,1}.entrystr = imptypefunc;
default{m,1}.searchpath = imptypepath;
default{m,1}.path = [imptypepath,imptypefunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'TrajEndfunc';
default{m,1}.entrystr = TrajEndfunc;
default{m,1}.searchpath = TrajEndpath;
default{m,1}.path = [TrajEndpath,TrajEndfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'TrajSampfunc';
default{m,1}.entrystr = TrajSampfunc;
default{m,1}.searchpath = TrajSamppath;
default{m,1}.path = [TrajSamppath,TrajSampfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'kSampfunc';
default{m,1}.entrystr = KSMPfunc;
default{m,1}.searchpath = KSMPpath;
default{m,1}.path = [KSMPpath,KSMPfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ProjSampfunc';
default{m,1}.entrystr = ProjSampfunc;
default{m,1}.searchpath = ProjSamppath;
default{m,1}.path = [ProjSamppath,ProjSampfunc];

