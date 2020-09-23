%====================================================
%
%====================================================

function [ExtRunInfo,err] = ExtRunScrptDefault(tab,panelnum,scrptnum,ExtRunInfo)

global DEFFILEGBL

%----------------------------------------------------
% Return Run Func
%----------------------------------------------------
runfunc = DEFFILEGBL.(tab)(panelnum,scrptnum).runfunc;
if isempty(runfunc)
    err.flag = 1;
    err.msg = 'No Script';
    return
end
if isequal(runfunc.func,@RunScrptFunc_B9);
    runfunc.func = @ExtRunScrptFunc_B9;
end
[ExtRunInfo,err] = runfunc.func(runfunc.input{1},runfunc.input{2},runfunc.input{3},...
             runfunc.input{4},runfunc.input{5},ExtRunInfo);

