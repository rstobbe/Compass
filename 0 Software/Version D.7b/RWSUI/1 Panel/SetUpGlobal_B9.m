%=========================================================
% 
%=========================================================

function SetUpGlobal_B9(style,ob,str,val,callback1,callback2)

global RWSUIGBL

func = str2func(RWSUIGBL.outputfunc);
func(style,ob,str,val,callback1,callback2);
