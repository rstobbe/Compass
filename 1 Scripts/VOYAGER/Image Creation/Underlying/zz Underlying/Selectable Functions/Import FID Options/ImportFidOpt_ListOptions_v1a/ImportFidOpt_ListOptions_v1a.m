%====================================================
% (v1a)
%       
%====================================================

function [SCRPTipt,OPT,err] = ImportFidOpt_ListOptions_v1a(SCRPTipt,OPTipt)

Status2('done','Import FID Options',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
OPT.method = OPTipt.Func;
OPT.visuals = OPTipt.('Visuals');
OPT.fovadjust = OPTipt.('FovAdjust')';
OPT.doaveraging = OPTipt.('DoAveraging');
OPT.rcvrtest = OPTipt.('Receivers');


Status2('done','',2);
Status2('done','',3);