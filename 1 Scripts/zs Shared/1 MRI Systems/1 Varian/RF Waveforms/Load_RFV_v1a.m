%================================================
% Load Varian RF_File
% 
%================================================

function [Vals,Pars,err] = Load_RFV_v1a(path)

ind = strfind(path,'\');
Pars.Name = path(ind(end)+1:end-3);

[Text,err] = Load_TextFile_v1a(path);

ind = strfind(Text,'EXCITEWIDTH');
if not(isempty(ind));
    TempText = Text(ind:end);
    Tempcr = strfind(TempText,10);
    Pars.excitewidth = str2double(TempText(13:Tempcr(1)));
end
ind = strfind(Text,'INTEGRAL');
if not(isempty(ind));
    TempText = Text(ind:end);
    Tempcr = strfind(TempText,10);
    Pars.integral = str2double(TempText(13:Tempcr(1)));
end
ind = strfind(Text,'AREF');
if not(isempty(ind));
    TempText = Text(ind:end);
    Tempcr = strfind(TempText,10);
    Pars.aref = str2double(TempText(13:Tempcr(1)));
end

cr = strfind(Text,10);
m = 1;
for n = 1:length(cr)-1
    if strcmp(Text(cr(n)+1),'#')
        continue
    end
    [val1,rest] = strtok(Text(cr(n)+1:end));
    pol(m) = str2double(val1);
    [val2,rest] = strtok(rest);
    val(m) = str2double(val2);
    m = m+1;
end

Vals = val.*exp(1i*pi*pol/180);