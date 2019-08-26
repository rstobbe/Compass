%================================================
% Read 
% - Return Parameters
%================================================

function [Shims,err] = ReadShimsMRS_v1a(path)

err.flag = 0;
err.msg = '';

file = fopen(path);
if file == -1
    error();
end

A = fread(file);
fclose(file);
Text = char(A');
inds = strfind(Text,char(13));
inds = [inds 0];
tText = Text(1:inds(1)-1);
for n = 1:length(inds)-1
    inds2 = strfind(tText,char(32));
    shimnum = str2double(tText(1:inds2(1)-1));
    shimval = str2double(tText(inds2(1)+1:inds2(2)-1));  
    if length(inds2) == 2
        shimname = tText(inds2(2)+1:end);
    elseif length(inds2) == 3
        shimname = tText(inds2(3)+1:end);
    end
    Shims.(shimname) = shimval;
    tText = Text(inds(n)+1:inds(n+1)-1);
end

