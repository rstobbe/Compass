%=========================================================
% 
%=========================================================

function Status2(state,string,N)

global RWSUIGBL

func = str2func(RWSUIGBL.status2func);
func(state,string,N);