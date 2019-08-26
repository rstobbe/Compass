%=========================================================
% (v1b)
%       - shim plot x direction change
%=========================================================

function [SCRPTipt,SCRPTGBL,MOF,err] = ShimFiguresMaskOnly_v1b(SCRPTipt,SCRPTGBL,MOFipt)

Status2('busy','Montage Overlay Figure',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
MOF.method = MOFipt.Func; 
MOF.dispmaskwid = MOFipt.('DispMask');
MOF.histstepmask = str2double(MOFipt.('HistStepMask'));


Status2('done','',2);
Status2('done','',3);
