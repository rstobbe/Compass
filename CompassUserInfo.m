function [User] = CompassUserInfo(doFull)


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
User.lastscriptloc = 'E:\Studies\MSYB Paper\Trajectories\F230_V0004_E100_T100_N6272_SW82_SEO\';
User.experimentsloc = 'E:\Studies\MSYB Paper\Trajectories\F100_V0010_E100_T020_N3528_SU100_SEO\Testing\';
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