%=========================================================
% 
%=========================================================

function Status2(state,string,N)

global RWSUIGBL
if isempty(RWSUIGBL)
    return
end

func = str2func(RWSUIGBL.status2func);
func(state,string,N);