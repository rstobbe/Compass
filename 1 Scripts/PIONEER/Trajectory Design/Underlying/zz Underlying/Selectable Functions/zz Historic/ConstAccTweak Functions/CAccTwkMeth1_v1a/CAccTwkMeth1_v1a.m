%==================================================
%  (v1a)
%     
%==================================================

function [SCRPTipt,CACCT,err] = CAccTwkMeth1_v1a(SCRPTipt,CACCTipt)

Status2('done','Get Acc Constrain Tweak info',3);

err.flag = 0;
err.msg = '';

CACCT.method = CACCTipt.Func;   
CACCT.twktc1 = str2double(CACCTipt.('Twk_tc1'));
CACCT.twkval1 = str2double(CACCTipt.('Twk_val1')); 
CACCT.twktc2 = str2double(CACCTipt.('Twk_tc2'));
CACCT.twkval2 = str2double(CACCTipt.('Twk_val2')); 

Status2('done','',3);