%==================================================
%
%==================================================

function [acc,SDCS,SCRPTipt,err] = Acc_Const_v1a(j,SDCS,SCRPTipt,err)

acc = str2double(SCRPTipt(strcmp('AccVal',{SCRPTipt.labelstr})).entrystr);
SDCS.Acc.AccVal = acc;
