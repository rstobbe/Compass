%=========================================================
% 
%=========================================================

function [WRTS,err] = WritePulseCalV_v1a_Func(WRTS,INPUT)

global USERGBL

Status2('busy','Write PulseCal',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-------------------------------------------------
% Get input
%-------------------------------------------------
IMG = INPUT.IMG;
value = INPUT.value;
clear INPUT

%-------------------------------------------------
% Get rfcoil that was used
%-------------------------------------------------
ExpPars = IMG.ExpPars;
rfcoil = ExpPars.rfcoil;
%twpr1 = ExpPars.tpwr1;
%tpwrf1 = ExpPars.tpwrf1;

%-------------------------------------------------
% Check to Write
%-------------------------------------------------
button = questdlg(['Power Change = ',num2str(-value),' dB. Adjust PulseCal?'],'PulseCal');
if strcmp(button,'No') || strcmp(button,'Cancel')
    err.flag = 1;
    err.msg = 'PulseCal Not Written';
    return
end

%-------------------------------------------------
% Read PulseCal File
%-------------------------------------------------
fid = fopen([USERGBL.varianloc,'\vnmrsys\pulsecal'],'r');
A = fread(fid);
Text0 = char(A');
fclose(fid);

%-------------------------------------------------
% Write Backup
%-------------------------------------------------
fid = fopen([USERGBL.varianloc,'\vnmrsys\pulsecal_previous'],'w+');
fprintf(fid,Text0);
fclose(fid);

%-------------------------------------------------
% Update
%-------------------------------------------------
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
newpower = str2double(token{3})-value;

%-------------------------------------------------
% Write
%-------------------------------------------------
ind = strfind(Text0,token{3});
if length(ind)>1
    ind = ind(ind>ind01 & ind<ind02);
end
Text0(ind:ind+length(token{3})-1) = num2str(newpower,'%10.6f');
fid = fopen([USERGBL.varianloc,'\vnmrsys\pulsecal'],'w+');
fprintf(fid,Text0);
fclose(fid);


Status2('done','',2);
Status2('done','',3);
