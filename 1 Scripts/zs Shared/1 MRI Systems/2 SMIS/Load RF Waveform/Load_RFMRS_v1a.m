%================================================
% Load Varian RF_File
% 
%================================================

function [Vals,err] = Load_RFMRS_v1a(path)

[Text,err] = Load_TextFile_v1a(path);
start = strfind(Text,10);
start = start(1)+1;
Textsub = Text(start:length(Text));
cr = strfind(Textsub,10);
for n = 1:length(cr) 
    Vals(n) = str2double(Textsub(1:7));
    cr = strfind(Textsub,10);
    Textsub = Textsub(cr(1)+1:length(Textsub));
end
