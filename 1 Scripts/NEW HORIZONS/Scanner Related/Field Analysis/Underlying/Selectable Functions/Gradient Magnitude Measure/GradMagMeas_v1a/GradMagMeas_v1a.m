%====================================================
% (v1a) 
%     
%====================================================

function [SCRPTipt,GMAG,err] = GradMagMeas_v1a(SCRPTipt,GMAGipt)

Status2('busy','Gradient Magnitude Measure',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
GMAG.plstart = str2double(GMAGipt.PLstart);
GMAG.plstop = str2double(GMAGipt.PLstop);
GMAG.bgstart = str2double(GMAGipt.BGstart);
GMAG.bgstop = str2double(GMAGipt.BGstop);
GMAG.sep = str2double(GMAGipt.Separation);

Status2('done','',2);
Status2('done','',3);


