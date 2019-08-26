%=========================================================
% (v1a)
%      
%=========================================================

function [SCRPTipt,SCRPTGBL,MOF,err] = GenMapFigure_v1a(SCRPTipt,SCRPTGBL,MOFipt)

Status2('busy','Generic Map Figure',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
MOF.method = MOFipt.Func; 
MOF.scale = MOFipt.('Scale');
MOF.colour = MOFipt.('Colour');

Status2('done','',2);
Status2('done','',3);

