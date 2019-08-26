%====================================================
% (v1a)
%      
%====================================================

function [SCRPTipt,RADEV,err] = RSESpiral_manual_v1a(SCRPTipt,RADEVipt)

Status2('done','Get Radial evolution function info',3);

err.flag = 0;
err.msg = '';

RADEV.method = RADEVipt.Func;   
RADEV.pval = RADEVipt.('RadPwr');
RADEV.intol = str2double(RADEVipt.('PLenInTol'));
RADEV.outtol = str2double(RADEVipt.('PLenOutTol'));
RADEV.solintol = str2double(RADEVipt.('SolInTol'));
RADEV.solouttol = str2double(RADEVipt.('SolOutTol'));
RADEV.D = str2double(RADEVipt.('D'));
RADEV.solinlenfact = str2double(RADEVipt.('SolInLenFact'));

Status2('done','',3);