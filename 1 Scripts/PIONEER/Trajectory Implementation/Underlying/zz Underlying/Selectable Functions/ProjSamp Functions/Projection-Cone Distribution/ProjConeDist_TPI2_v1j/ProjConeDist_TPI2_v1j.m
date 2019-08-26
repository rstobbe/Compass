%====================================================
% (TPI2)
%       - relative increase on cones within degrees
%       - add additional on first and second cones
% (v1j)
%       - search update
%====================================================

function [SCRPTipt,PCD,err] = ProjConeDist_TPI2_v1j(SCRPTipt,PCDipt)

Status2('busy','Get Info For Projection Cone Distribution',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
PCD.method = PCDipt.Func;
eproj = PCDipt.('ExtraProj');
PCD.phithetafrac0 = str2double(PCDipt.('Ph'));

Status2('done','',2);
Status2('done','',3);

%---------------------------------------------
% Determine Extra Projections
%---------------------------------------------
inds = strfind(eproj,',');
if length(inds) == 1
    PCD.eprojdeg = str2double(eproj(1:inds(1)-1));
    PCD.eprojrel = str2double(eproj(inds(1)+1:length(eproj))); 
else
    error();
end
