%=========================================================
% (v1a) 
%   
%=========================================================

function [SCRPTipt,RSZ,err] = IncreaseFoV_v1a(SCRPTipt,RSZipt)

Status2('done','Adjust FoV',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
RSZ.method = RSZipt.Func;
RSZ.newfov = RSZipt.('NewFoV');
RSZ.matoffset = RSZipt.('MatOffset');

Status2('done','',2);
Status2('done','',3);