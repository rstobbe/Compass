%=========================================================
%
%=========================================================

function [WRTG,err] = WrtGrad_N2DFilesV_v1c_Func(WRTG,INPUT)

Status2('busy','Write Gradient Files',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-------------------------------------------------
% Get input
%-------------------------------------------------
G = INPUT.G;
rdur = INPUT.rdur;
sym = INPUT.sym;
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
[GradLoc] = uigetdir(GradDefLoc,'Select/Create Folder for Gradient Waveforms');
if GradLoc == 0
    err.flag = 3;
    err.msg = 'User Aborted';
    return
end
WRTG.GradLoc = GradLoc;
if strcmp(dowrite,'No')
    return
end
if exist([GradLoc,'\Gx1.GRD'],'file');
    err.flag = 1;
    err.msg = 'Gradient Files Already Exist in this Path';
    return
end

%-------------------------------------------------
% Calculate Varian Gradient Value
%-------------------------------------------------
rel = (1/sysgmax) * 32767; 
G = round(rel*G);

%-------------------------------------------------
% Write Gradients to File
%-------------------------------------------------
L = length(G(:,1,1));
if strcmp(sym,'PosNeg')
    L = L/2;
end
W = length(G(1,:,1));

for n = 1:L
    GxV = zeros(W,2);
    GyV = zeros(W,2);
    GxV(:,1) = G(n,:,1);
    GyV(:,1) = G(n,:,2);    
    GxV(:,2) = rdur;
    GyV(:,2) = rdur;    
   
    loc = [GradLoc,'\Gx',num2str(n),'.GRD'];
    dlmwrite(loc,GxV,'delimiter','\t','newline','unix');
    loc = [GradLoc,'\Gy',num2str(n),'.GRD'];
    dlmwrite(loc,GyV,'delimiter','\t','newline','unix');
    Status2('busy',['File Number: ',num2str(n)],3);
end

Status2('done','',2);
Status2('done','',3);
