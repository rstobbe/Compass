%=========================================================
% 
%=========================================================

function [WRTS,err] = WriteDoublePulseCalV_v2a_Func(WRTS,INPUT)

global CONSOLEGBL

Status2('busy','Write PulseCal',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-------------------------------------------------
% Get input
%-------------------------------------------------
IMG = INPUT.IMG;
value = INPUT.DATCOL.value;
value2 = INPUT.DATCOL.value2;
clear INPUT

%-------------------------------------------------
% Get rfcoil that was used
%-------------------------------------------------
ExpPars = IMG.ExpPars;
rfcoil = ExpPars.rfcoil;
rfcoil2 = [rfcoil,'2'];

%-------------------------------------------------
% Read PulseCal File
%-------------------------------------------------
fid = fopen([CONSOLEGBL.path,ExpPars.operator_,'\vnmrsys\pulsecal'],'r');
A = fread(fid);
fclose(fid);

%-------------------------------------------------
% Update
%-------------------------------------------------
Text0 = char(A');
ind01 = strfind(Text0,[char(10),rfcoil,char(32)]);
Text1 = Text0(ind01+length(rfcoil)+1:end);
indt = strfind(Text0,char(10));
ind02 = indt(find(indt>ind01,1));
if isempty(ind02)
    err.flag = 1;
    err.msg = 'PulseCal File Error (needs carraige-return at end)';
    return
end
remain = Text1;
for n = 1:4
	[token{n},remain] = strtok(remain);
end
if length(token{3}) < 6
    err.flag = 1;
    err.msg = 'PulseCal File Error (original power numbers should have 6 decimal points';
    return
end
newpower = str2double(token{3})-value;

%-------------------------------------------------
% Update
%-------------------------------------------------
ind = strfind(Text0,token{3});
if length(ind)>1
    ind = ind(ind>ind01 & ind<ind02);
end
Text0(ind:ind+length(token{3})-1) = num2str(newpower,'%10.6f');

%-------------------------------------------------
% Update
%-------------------------------------------------
ind01 = strfind(Text0,[char(10),rfcoil2,char(32)]);
if isempty(ind01)
    err.flag = 1;
    err.msg = ['PulseCal File Error (',rfcoil2,' does not exist)'];
    return
end
Text1 = Text0(ind01+length(rfcoil2)+1:end);
indt = strfind(Text0,char(10));
ind02 = indt(find(indt>ind01,1));
if isempty(ind02)
    err.flag = 1;
    err.msg = 'PulseCal File Error (needs carraige-return at end)';
    return
end
remain = Text1;
for n = 1:4
	[token{n},remain] = strtok(remain);
end
if length(token{3}) < 6
    err.flag = 1;
    err.msg = 'PulseCal File Error (original power numbers should have 6 decimal points';
    return
end
newpower2 = str2double(token{3})-value2;

%-------------------------------------------------
% Write
%-------------------------------------------------
ind = strfind(Text0,token{3});
if length(ind)>1
    ind = ind(ind>ind01 & ind<ind02);
end
Text0(ind:ind+length(token{3})-1) = num2str(newpower2,'%10.6f');
fid = fopen([CONSOLEGBL.setuppath,'\vnmrsys\pulsecaltemp'],'w+');
fprintf(fid,Text0);
fclose(fid);

Status2('done','',2);
Status2('done','',3);
