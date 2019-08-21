%=========================================================
% 
%=========================================================

function Status(state,string)

global RWSUIGBL

func = str2func(RWSUIGBL.statusfunc);
func(state,string);
