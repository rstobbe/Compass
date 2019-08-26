%====================================================
% 
%====================================================

function [ELIP,err] = ElipSiemensDefault_v1a_Func(ELIP,INPUT)

Status2('busy','Define Spinning Functions',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
ELIP.elip = 1/1.2;                  % should be placed along 'z';



Status2('done','',2);
Status2('done','',3);