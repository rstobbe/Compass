%=========================================================
% 
%=========================================================

function [default] = ImpMeth_QuantizedCATPI_v1b_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    QVecSlvpath = [SCRPTPATHS.pioneerloc,'Trajectory Implementation\Underlying\Selectable Functions\0 Scanner Related\QVecSlv Functions\'];
    TrajComppath = [SCRPTPATHS.pioneerloc,'Trajectory Implementation\Underlying\Selectable Functions\0 Scanner Related\TrajComplete Functions\'];
    ORNTpath = [SCRPTPATHS.pioneerloc,'\Trajectory Implementation\Underlying\Selectable Functions\0 Scanner Related\Orient Functions\'];  
    KSMPpath = [SCRPTPATHS.pioneerloc,'\Trajectory Implementation\Underlying\Selectable Functions\1 ImCon Related\kSamp Functions\'];
    STEPRESPpath = [SCRPTPATHS.pioneerloc,'\Trajectory Implementation\Underlying\zz Underlying\Selectable Functions\StepResp SubFunctions\']; 
elseif strcmp(filesep,'/')
end
QVecSlvfunc = 'QVecSlv_BasicQuantizedTPI_v1a';
TrajCompfunc = 'TrajComp_StepRespQuantizedTPI_v1a';
ORNTfunc = 'OrientStandard_v1a'; 
KSMPfunc = 'kSamp_Standard_v1c'; 
STEPRESPfunc = 'StepResp_FromFileWithComp_v1f';

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Orientfunc';
default{m,1}.entrystr = ORNTfunc;
default{m,1}.searchpath = ORNTpath;
default{m,1}.path = [ORNTpath,ORNTfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'QVecSlvfunc';
default{m,1}.entrystr = QVecSlvfunc;
default{m,1}.searchpath = QVecSlvpath;
default{m,1}.path = [QVecSlvpath,QVecSlvfunc];

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'iGseg (ms)';
default{m,1}.entrystr = '0.300';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'TrajCompletefunc';
default{m,1}.entrystr = TrajCompfunc;
default{m,1}.searchpath = TrajComppath;
default{m,1}.path = [TrajComppath,TrajCompfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'StepRespfunc';
default{m,1}.entrystr = STEPRESPfunc;
default{m,1}.searchpath = STEPRESPpath;
default{m,1}.path = [STEPRESPpath,STEPRESPfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'kSampfunc';
default{m,1}.entrystr = KSMPfunc;
default{m,1}.searchpath = KSMPpath;
default{m,1}.path = [KSMPpath,KSMPfunc];

