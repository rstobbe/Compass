function [User] = CompassUserInfo(doFull)


User.defloc = 'D:\CompassRelated\2 Defaults\';
User.defrootloc = 'D:\CompassRelated\2 Defaults\';
User.lastdefloc = 'D:\CompassRelated\2 Defaults\23NaHippoStudy\Analysis\';
User.siemensdefaultloc = 'D:\CompassRelated\2 Defaults\Protocols\PRISMA';

User.trajreconloc = 'D:\CompassRelated\3 ReconFiles';  
User.invfiltloc = 'D:\CompassRelated\4 OtherFiles\Gridding\Inverse Filters\';
User.imkernloc = 'D:\CompassRelated\4 OtherFiles\Gridding\Kernels\';
User.sysresploc = 'D:\CompassRelated\4 OtherFiles\Scanner\GradSysResp';
User.varianshimcalfile = 'D:\CompassRelated\4 OtherFiles\Scanner\Shimming\NaHBC_ShimCal_Jan2015';

User.tempdataloc = 'E:\';
User.lastscriptloc = 'E:\Trajectories\TPI\23NaSiemens\Stroke Study\F280_V1162_E100_T200_N3000_B30\Analysis\';
User.experimentsloc = 'E:\Studies\23NaAlzheimers\DataPrelim\200121 (23NaAlz_200121KD)\VolBrain\';
User.trajdevloc = 'Y:\2 Trajectories\0 TempHolding\MSYB\ConesComp'; 
User.varianloc = 'V:\sodium\';
User.variandataloc = 'V:\sodium\vnmrsys\data\studies';
User.varianshimfile = 'V:\sodium\vnmrsys\shims\shimRWS';

if doFull
    User.setup = 'Full';
else
    User.setup = 'ImageAnalysis';
end
User.epssave = 'Yes';
User.userinfofile = [pwd,'\CompassUserInfo.m']; 