%====================================================
% (v1i)
%       - from TPI1_v1i
%====================================================

function [SCRPTipt,PCD,err] = ProjConeDist_TPI2_v1i(SCRPTipt,PCDipt)

Status2('busy','Get Info For Projection Cone Distribution',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
PCD.method = PCDipt.Func;
eproj = PCDipt.('ExtraProj');
PCD.maxrelconeos = str2double(PCDipt.('MaxRelConeOS'));
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
