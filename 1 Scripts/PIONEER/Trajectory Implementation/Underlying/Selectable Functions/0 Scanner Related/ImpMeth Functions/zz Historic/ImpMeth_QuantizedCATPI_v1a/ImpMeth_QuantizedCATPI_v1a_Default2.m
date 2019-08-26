%=========================================================
% 
%=========================================================

function [default] = ImpMeth_QuantizedCATPI_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    QVecSlvpath = [SCRPTPATHS.pioneerloc,'Trajectory Implementation\Underlying\Selectable Functions\0 Scanner Related\QVecSlv Functions\'];
    GSRApath = [SCRPTPATHS.pioneerloc,'Trajectory Implementation\Underlying\zz Underlying\Selectable Functions\GWFM SubFunctions\GSRA Functions\'];
    TrajComppath = [SCRPTPATHS.pioneerloc,'Trajectory Implementation\Underlying\Selectable Functions\0 Scanner Related\TrajComplete Functions\'];
    GSRIpath = [SCRPTPATHS.pioneerloc,'Trajectory Implementation\Underlying\zz Underlying\Selectable Functions\kSamp SubFunctions\GSRI Functions\'];  
    ORNTpath = [SCRPTPATHS.pioneerloc,'\Trajectory Implementation\Underlying\Selectable Functions\0 Scanner Related\Orient Functions\'];  
    KSMPpath = [SCRPTPATHS.pioneerloc,'\Trajectory Implementation\Underlying\Selectable Functions\1 ImCon Related\kSamp Functions\'];  
elseif strcmp(filesep,'/')
end
QVecSlvfunc = 'QVecSlv_BasicQuantizedTPI_v1a';
GSRAfunc = 'GSRA_TPIstandard_v2g';
GSRIfunc = 'GSRI_TPIstandard_v2i';
TrajCompfunc = 'TrajComp_BasicQuantizedTPI_v1a';
ORNTfunc = 'OrientSiemensDefault_v1b'; 
KSMPfunc = 'kSamp_Inova_v1a'; 

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Orientfunc';
default{m,1}.entrystr = ORNTfunc;
default{m,1}.searchpath = ORNTpath;
default{m,1}.path = [ORNTpath,ORNTfunc];

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'iSeg (ms)';
default{m,1}.entrystr = '0.300';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'QVecSlvfunc';
default{m,1}.entrystr = QVecSlvfunc;
default{m,1}.searchpath = QVecSlvpath;
default{m,1}.path = [QVecSlvpath,QVecSlvfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'TrajCompletefunc';
default{m,1}.entrystr = TrajCompfunc;
default{m,1}.searchpath = TrajComppath;
default{m,1}.path = [TrajComppath,TrajCompfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'GSRAfunc';
default{m,1}.entrystr = GSRAfunc;
default{m,1}.searchpath = GSRApath;
default{m,1}.path = [GSRApath,GSRAfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'GSRIfunc';
default{m,1}.entrystr = GSRIfunc;
default{m,1}.searchpath = GSRIpath;
default{m,1}.path = [GSRIpath,GSRIfunc];

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'StepResp_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc1 = 'LoadMatFileCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = 'Y:\I NMR Centre\4.7T\Gradient Step Response\Measured Step Responses\2013';
default{m,1}.runfunc2 = 'LoadMatFileDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = 'Y:\I NMR Centre\4.7T\Gradient Step Response\Measured Step Responses\2013';
default{m,1}.searchpath = SCRPTPATHS.rootloc;
default{m,1}.path = SCRPTPATHS.rootloc;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'kSampfunc';
default{m,1}.entrystr = KSMPfunc;
default{m,1}.searchpath = KSMPpath;
default{m,1}.path = [KSMPpath,KSMPfunc];

