%====================================================
% (TPI1)
%       - directly specify extra projections on cones
% (v1j)
%       - search update
%====================================================

function [SCRPTipt,PCD,err] = ProjConeDist_TPI1_v1j(SCRPTipt,PCDipt)

Status2('busy','Get Info For Projection Cone Distribution',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
PCD.method = PCDipt.Func;
PCD.eproj = PCDipt.('ExtraProj');
PCD.phithetafrac0 = str2double(PCDipt.('Ph'));

Status2('done','',2);
Status2('done','',3);