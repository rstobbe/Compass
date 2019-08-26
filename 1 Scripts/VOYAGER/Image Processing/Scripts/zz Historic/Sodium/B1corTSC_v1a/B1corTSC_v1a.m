%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = B1corTSC_v1a(SCRPTipt,SCRPTGBL)

global IM

SCRPTGBL.TextBox = '';
SCRPTGBL.Figs = [];
SCRPTGBL.Data = [];
err.flag = 0;
err.msg = '';

%-------------------------------------
% Load Script Info
%-------------------------------------
B1mapImNum = str2double(SCRPTipt(strcmp('B1mapImNum',{SCRPTipt.labelstr})).entrystr); 
TSCImNum = str2double(SCRPTipt(strcmp('TSCImNum',{SCRPTipt.labelstr})).entrystr); 

%-------------------------------------
% Average
%-------------------------------------
TSCin = abs(IM{TSCImNum});
B1map = abs(IM{B1mapImNum});

TSCin(TSCin < 12) = 0; 
B1map(B1map == 0) = 1e9;
TSCout = 100*TSCin./(30*B1map/60);

TSCout = 50*TSCout/201.7;
TSCout = 150*TSCout/141.1;

figno = 1;
LoadImageGalileo(TSCin,figno);
figno = 2;
LoadImageGalileo(TSCout,figno);
