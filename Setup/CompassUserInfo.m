function [User] = CompassUserInfo(softwarefolder,Setup)


User.defloc = 'D:\CompassRelated\2 Defaults\';
User.defrootloc = 'D:\CompassRelated\2 Defaults\';
User.lastdefloc = 'D:\CompassRelated\2 Defaults\CompassRecon\';
User.siemensdefaultloc = 'D:\CompassRelated\2 Defaults\Protocols\PRISMA';

User.trajreconloc = 'D:\CompassRelated\3 ReconFiles';  
User.invfiltloc = 'D:\CompassRelated\4 OtherFiles\Gridding\Inverse Filters\';
User.imkernloc = 'D:\CompassRelated\4 OtherFiles\Gridding\Kernels\';
User.sysresploc = 'D:\CompassRelated\4 OtherFiles\Scanner\GradSysResp';
User.varianshimcalfile = 'D:\CompassRelated\4 OtherFiles\Scanner\Shimming\NaHBC_ShimCal_Jan2015';

User.tempdataloc = 'E:\';
User.lastscriptloc = 'E:\Trajectories\TPI\23NaSiemens\For Catpi Paper\F280_V0823_E100_T200_N2500_B30\';
User.experimentsloc = 'E:\zz Annie\MS Sodium ReReCoreg_FSL\68\';
User.trajdevloc = 'Y:\2 Trajectories\0 TempHolding\MSYB\ConesComp'; 
User.varianloc = 'V:\sodium\';
User.variandataloc = 'V:\sodium\vnmrsys\data\studies';
User.varianshimfile = 'V:\sodium\vnmrsys\shims\shimRWS';

User.setup = Setup;
User.doCuda = 0;
if strcmp(Setup,'Full') || strcmp(Setup,'Dev') || strcmp(Setup,'Scripts')
    User.doCuda = 1;
end

User.epssave = 'Yes';
User.userinfofile = [softwarefolder,'\Setup\CompassUserInfo.m']; 