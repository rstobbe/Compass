%=========================================================
% 
%=========================================================

function [WRTS,err] = WriteShimV_v1a_Func(WRTS,INPUT)

Status2('busy','Write Shim Files',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-------------------------------------------------
% Get input
%-------------------------------------------------
CalData = INPUT.CalData;
Wgts = INPUT.Wgts;
clear INPUT

%-------------------------------------------------
% Write Parameter File
%-------------------------------------------------
fid = fopen('V:\sodium\vnmrsys\shims\shimRWS','w+');
for n = 1:length(Wgts)
    if strcmp(CalData(n).Shim,'x')
        CalData(n).Shim = 'x1';
    elseif strcmp(CalData(n).Shim,'y')
        CalData(n).Shim = 'y1';
    end
    fprintf(fid,[CalData(n).Shim,' 7 1 19 19 19 2 1 8192 1 64\n']);
    fprintf(fid,['1 ',num2str(Wgts(n)),'\n']);
    fprintf(fid,'0\n');
end
fclose(fid);

Status2('done','',2);
Status2('done','',3);
