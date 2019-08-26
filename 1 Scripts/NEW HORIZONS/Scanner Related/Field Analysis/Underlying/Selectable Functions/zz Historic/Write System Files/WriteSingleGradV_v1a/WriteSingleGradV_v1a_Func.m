%=========================================================
%
%=========================================================

function [WRTG,err] = WriteSingleGradV_v1a_Func(WRTG,INPUT)

Status2('busy','Write Single Gradient Files',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-------------------------------------------------
% Get input
%-------------------------------------------------
G = INPUT.G;
rdur = INPUT.rdur;
clear INPUT

%-------------------------------------------------
% Common Variables
%-------------------------------------------------
GradDefLoc = WRTG.GradDefLoc;
dowrite = WRTG.dowrite;
sysgmax = WRTG.sysgmax;

%-------------------------------------------------
% Select WRTG Directory
%-------------------------------------------------
[file,path] = uiputfile('*.GRD','Save Gradient Waveform File',GradDefLoc);
if file == 0
    err.flag = 3;
    err.msg = 'User Aborted';
    return
end
WRTG.GradLoc = [path,file];
if strcmp(dowrite,'No')
    return
end

%-------------------------------------------------
% Calculate Varian Gradient Value
%-------------------------------------------------
rel = (1/sysgmax) * 32767; 
G = round(rel*G);

%-------------------------------------------------
% Write Gradient File
%-------------------------------------------------
fopen([path,file],'w+');
Gw = zeros(length(G),2);
Gw(:,1) = G;
Gw(:,2) = rdur*ones(length(G),1);

dlmwrite(WRTG.GradLoc,Gw,'delimiter','\t','newline','unix');

fclose('all');

Status2('done','',2);
Status2('done','',3);
