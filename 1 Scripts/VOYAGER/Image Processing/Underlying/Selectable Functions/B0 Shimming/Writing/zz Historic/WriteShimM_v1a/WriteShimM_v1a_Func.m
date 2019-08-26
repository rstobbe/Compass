%=========================================================
% 
%=========================================================

function [WRTS,err] = WriteShimM_v1a_Func(WRTS,INPUT)

Status2('busy','Write Shim Files',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-------------------------------------------------
% Get input
%-------------------------------------------------
CalData = INPUT.CalData;
Wgts = INPUT.Wgts;
NewShims = INPUT.NewShims;
ShimName = INPUT.ShimName;
clear INPUT

%-------------------------------------------------
% Write Parameter File
%-------------------------------------------------
PrevShimName = ShimName(1:end-4);
answer = inputdlg(['Enter new shim name (prev = ',PrevShimName,')'],'Name Shim');
if isempty(answer)
    err.flag = 1;
    err.msg = 'File Not Written';
    return
end

%-------------------------------------------------
% Write Parameter File
%-------------------------------------------------
fid = fopen([WRTS.path,answer{1},'.SHM'],'w');

totshims = fieldnames(NewShims);
for n = 1:length(totshims);
    if strcmp(totshims{n},'tof')
        continue
    end
    if n < 5
        fprintf(fid,[num2str(n),char(32),num2str(NewShims.(totshims{n})),char(32),totshims{n},char(13),char(10)]);
    else
        fprintf(fid,[num2str(n),char(32),num2str(NewShims.(totshims{n})),char(32),'0',char(32),totshims{n},char(13),char(10)]);
    end
end


fclose(fid);

Status2('done','',2);
Status2('done','',3);
