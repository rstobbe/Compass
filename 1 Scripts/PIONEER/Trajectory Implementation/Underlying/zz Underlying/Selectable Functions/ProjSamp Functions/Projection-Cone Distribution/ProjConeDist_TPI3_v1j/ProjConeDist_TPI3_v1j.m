%====================================================
% (TPI1)
%       - rate of phi increase capability
% (v1j)
%       - search update
%====================================================

function [SCRPTipt,PCD,err] = ProjConeDist_TPI3_v1j(SCRPTipt,PCDipt)

Status2('busy','Get Info For Projection Cone Distribution',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
PCD.method = PCDipt.Func;
eproj = PCDipt.('ExtraProj');
phirateinc = PCDipt.('PhiRateInc');
PCD.maxrelconeos = str2double(PCDipt.('MaxRelConeEP'));
PCD.phithetafrac0 = str2double(PCDipt.('Ph'));

Status2('done','',2);
Status2('done','',3);

%---------------------------------------------
% Determine Extra Projections
%---------------------------------------------
inds = strfind(eproj,',');
if length(inds) == 1
    PCD.eprojdeg(1) = str2double(eproj(1:inds(1)-1));
    PCD.eprojnum(1) = str2double(eproj(inds(1)+1:length(eproj))); 
    PCD.eprojdeg(2) = 0; 
    PCD.eprojnum(2) = 0;
elseif length(inds) == 3
    PCD.eprojdeg(1) = str2double(eproj(1:inds(1)-1));
    PCD.eprojnum(1) = str2double(eproj(inds(1)+1:inds(2)-1));  
    PCD.eprojdeg(2) = str2double(eproj(inds(2)+1:inds(3)-1)); 
    PCD.eprojnum(2) = str2double(eproj(inds(3)+1:length(eproj)));
end

%---------------------------------------------
% Determine Phi Rate Increase
%---------------------------------------------
inds = strfind(phirateinc,',');
PCD.phirateincdeg = str2double(phirateinc(1:inds(1)-1));
PCD.phirateincnum = str2double(phirateinc(inds(1)+1:length(phirateinc))); 
