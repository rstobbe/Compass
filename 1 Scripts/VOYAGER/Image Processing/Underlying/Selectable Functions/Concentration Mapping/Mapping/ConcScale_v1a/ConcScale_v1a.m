%===========================================
% (v1b)
%       - 
%===========================================

function [SCRPTipt,CMAP,err] = ConcScale_v1a(SCRPTipt,CMAPipt)

Status2('done','Concentration Mapping',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
CMAP.method = CMAPipt.Func;
CMAP.current = str2double(CMAPipt.('CurrentValue'));
CMAP.assign = str2double(CMAPipt.('AssignValue'));

Status2('done','',2);
Status2('done','',3);

