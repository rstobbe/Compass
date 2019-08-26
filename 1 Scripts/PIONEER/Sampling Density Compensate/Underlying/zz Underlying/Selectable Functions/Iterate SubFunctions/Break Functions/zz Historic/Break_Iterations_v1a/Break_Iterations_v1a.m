%===========================================================================================

%===========================================================================================

function [stop,SDCS] = Iterations_v1(SDCipt,SDCS,E,PROJdgn,PROJimp,SDC,j)

itnum = str2double(SDCipt(strcmp('ItNum',{SDCipt.labelstr})).entrystr);
if j == itnum
    stop = 1;
    SDCS.stopping = 'Objective Reached';
else
    stop = 0;
end


