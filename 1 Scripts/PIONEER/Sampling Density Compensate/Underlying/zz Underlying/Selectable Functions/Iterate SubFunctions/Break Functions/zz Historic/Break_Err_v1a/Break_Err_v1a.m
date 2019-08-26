%===========================================================================================

%===========================================================================================

function [stop,SDCS] = Break_Err_v1a(SDCipt,SDCS,E,PROJdgn,PROJimp,SDC,j)

maxerr = str2double(SDCipt(strcmp('MaxErr(%)',{SDCipt.labelstr})).entrystr);
maxit = str2double(SDCipt(strcmp('MaxIt',{SDCipt.labelstr})).entrystr);

stop = 1;
for n = 1:10
    if abs(SDCS.TrajErrArr(n)) > maxerr
        stop = 0;
    end
end

if stop == 1
    SDCS.stopping = 'Objective Reached';
    return
end

if j == maxit
    stop = 1;
    SDCS.stopping = 'Max Iterations Reached';
end


