%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = Export4DTI_v1a(SCRPTipt,SCRPTGBL)

global IM

SCRPTGBL.TextBox = '';
SCRPTGBL.Figs = [];
SCRPTGBL.Data = [];
err.flag = 0;
err.msg = '';

%-------------------------------------
% Load Script
%-------------------------------------
exportnum = str2double(SCRPTipt(strcmp('ExportImNum',{SCRPTipt.labelstr})).entrystr); 


%-------------------------------------
% Save
%-------------------------------------
kIMs = IM{exportnum};
test = size(kIMs)
save('kIMs','kIMs');


