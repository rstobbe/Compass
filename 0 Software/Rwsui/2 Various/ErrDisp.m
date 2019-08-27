%=========================================================
% 
%=========================================================

function ErrDisp(err)

global RWSUIGBL

func = str2func(RWSUIGBL.errfunc);
func(err);
