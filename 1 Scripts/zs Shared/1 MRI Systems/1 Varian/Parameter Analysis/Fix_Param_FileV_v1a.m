function Fix_Param_File(path,Text)

% add carraige return character
t = strfind(Text,sprintf('\n'));
[x,g] = size(t);

for i = 1:g-2
    a = t(i);
    [x,f] = size(Text);
    if i == 1
        Text = sprintf(strcat(Text(1:a-1),'\r\n',Text(a+1:f)));
    else
        if t(i)-1 == t(i-1);
            Text = sprintf(strcat(Text(1:a-1),'\r\n\r\n',Text(a+1:f)));
        else
            Text = sprintf(strcat(Text(1:a-1),'\r\n',Text(a+1:f)));
        end
    end
    t = strfind(Text,sprintf('\n'));
end  

file = strcat(path,'\params.txt');
params = fopen(file,'w+');
fwrite(params,Text);
fclose(params);

