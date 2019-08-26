%====================================================
% (TPI3b)
%       - rate of theta and phi increase capability
% (v1k)
%       - change for undersample so Phi/Theta numbers work out
%====================================================

function [SCRPTipt,PCD,err] = ProjConeDist_TPI3b_v1k(SCRPTipt,PCDipt)

Status2('busy','Get Info For Projection Cone Distribution',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
PCD.method = PCDipt.Func;
thetarateinc = PCDipt.('ThetaRateInc');
phirateinc = PCDipt.('PhiRateInc');
PCD.phithetafrac0 = str2double(PCDipt.('Ph'));

%---------------------------------------------
% Determine Theta Rate Increase
%---------------------------------------------
inds = strfind(thetarateinc,',');
PCD.thetarateincdeg = str2double(thetarateinc(1:inds(1)-1));
PCD.thetarateincnum = str2double(thetarateinc(inds(1)+1:length(thetarateinc))); 

%---------------------------------------------
% Determine Phi Rate Increase
%---------------------------------------------
inds = strfind(phirateinc,',');
PCD.phirateincdeg = str2double(phirateinc(1:inds(1)-1));
PCD.phirateincnum = str2double(phirateinc(inds(1)+1:length(phirateinc))); 

Status2('done','',2);
Status2('done','',3);
