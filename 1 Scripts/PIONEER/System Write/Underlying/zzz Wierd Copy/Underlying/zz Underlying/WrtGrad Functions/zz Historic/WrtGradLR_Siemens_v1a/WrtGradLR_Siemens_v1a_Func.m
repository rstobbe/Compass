%=========================================================
%
%=========================================================

function [WRTG,err] = WrtGradLR_Siemens_v1a_Func(WRTG,INPUT)

Status2('busy','Write Gradient File for Siemens',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-------------------------------------------------
% Get input
%-------------------------------------------------
G = INPUT.G;
file = INPUT.file;
clear INPUT

%-------------------------------------------------
% Relative Gradient Values for Siemens
%-------------------------------------------------
G = G/max(G(:));

%-------------------------------------------------
% Write Gradients to File
%-------------------------------------------------
fid = fopen(file,'a');
fclose(fid);
for n = 1:length(G(:,1,1))
    dlmwrite(file,squeeze(G(n,:,1)),'-append','newline','pc');
    Status2('busy',['Projection Number ',num2str(n)],3);
end
fid = fopen(file,'a');
fclose(fid);
for n = 1:length(G(:,1,1))
    dlmwrite(file,squeeze(G(n,:,2)),'-append','newline','pc');
    Status2('busy',['Projection Number ',num2str(n)],3);
end
fid = fopen(file,'a');
fclose(fid);
for n = 1:length(G(:,1,1))
    dlmwrite(file,squeeze(G(n,:,3)),'-append','newline','pc');
    Status2('busy',['Projection Number ',num2str(n)],3);
end

Status2('done','',2);
Status2('done','',3);
