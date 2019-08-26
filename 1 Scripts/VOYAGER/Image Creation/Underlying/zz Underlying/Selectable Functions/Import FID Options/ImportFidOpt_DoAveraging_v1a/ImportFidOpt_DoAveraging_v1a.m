%====================================================
% (v1a)
%       
%====================================================

function [SCRPTipt,OPT,err] = ImportFidOpt_DoAveraging_v1a(SCRPTipt,OPTipt)

Status2('done','Import FID Options',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
OPT.method = OPTipt.Func;
OPT.visuals = 'Yes';
OPT.fovadjust = 'Yes';
OPT.doaveraging = 'Yes';
OPT.rcvrtest = 'All';


Status2('done','',2);
Status2('done','',3);