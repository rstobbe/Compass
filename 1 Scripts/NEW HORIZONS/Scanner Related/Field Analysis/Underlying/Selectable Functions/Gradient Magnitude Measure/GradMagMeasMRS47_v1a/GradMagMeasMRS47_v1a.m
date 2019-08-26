%====================================================
% (v1a) 
%     - as GradMagMeas_v1a (hard code)
%====================================================

function [SCRPTipt,GMAG,err] = GradMagMeasMRS47_v1a(SCRPTipt,GMAGipt)

Status2('busy','Gradient Magnitude Measure',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
GMAG.plstart = 0.2;
GMAG.plstop = 0.6;
GMAG.bgstart = 2;
GMAG.bgstop = 15;
GMAG.sep = str2double(GMAGipt.Separation);

Status2('done','',2);
Status2('done','',3);


