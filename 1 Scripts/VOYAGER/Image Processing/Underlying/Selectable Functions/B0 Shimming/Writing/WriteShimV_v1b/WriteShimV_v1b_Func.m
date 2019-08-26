%=========================================================
% 
%=========================================================

function [WRTS,err] = WriteShimV_v1b_Func(WRTS,INPUT)

Status2('busy','Write Shim Files',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-------------------------------------------------
% Get input
%-------------------------------------------------
if length(INPUT.IMG) > 1
    err.flag = 1;
    err.msg = 'Do not load more than 1 image';
    return
end
IMG = INPUT.IMG{1};
if not(isfield(IMG,'Processing'))
    err.flag = 1;
    err.msg = 'There is no processing on this image';
    return
end
if length(IMG.Processing) > 1
    err.flag = 1;
    err.msg = 'This image has been processed more than once';
    return
end    
Processing = IMG.Processing{1};
if not(isfield(Processing,'CAL'))
    err.flag = 1;
    err.msg = 'This is not a SHIM image';
    return
end
CAL = Processing.CAL;
NewShims = Processing.NewShims;
CalData = CAL.CalData;
clear INPUT

%-------------------------------------------------
% Write Parameter File
%-------------------------------------------------
fid = fopen(WRTS.VarianShimFile,'w+');
for n = 1:length(NewShims)
    if strcmp(CalData(n).Shim,'x')
        CalData(n).Shim = 'x1';
    elseif strcmp(CalData(n).Shim,'y')
        CalData(n).Shim = 'y1';
    end
    fprintf(fid,[CalData(n).Shim,' 7 1 19 19 19 2 1 8192 1 64\n']);
    fprintf(fid,['1 ',num2str(NewShims(n)),'\n']);
    fprintf(fid,'0\n');
end

fclose(fid);
IMG.name = '';              % probably don't need to save (function really only for testing)
WRTS.IMG = IMG;

Status2('done','',2);
Status2('done','',3);
