%===============================================
% 
%===============================================

function [BRK,err] = Break_Iterations_v1c_Func(BRK,INPUT)

Status2('done','Test for Stopping Criteria',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Working Structures / Variables
%---------------------------------------------
ANLZ = INPUT.ANLZ;
j = INPUT.j;

%---------------------------------------------
% Test for Stopping
%---------------------------------------------
if j == BRK.itnum+1
    BRK.stop = 1;
    BRK.stopreason = 'Objective Reached';
else
    BRK.stop = 0;
end

%---------------------------------------------
% Test for Stopping - increasing error
%---------------------------------------------
if j > 1
    if ANLZ.MeanAbsErrTot(j) > ANLZ.MeanAbsErrTot(j-1)
        BRK.stop = 1;
        BRK.stopreason = 'Error Increasing';
    end
end
