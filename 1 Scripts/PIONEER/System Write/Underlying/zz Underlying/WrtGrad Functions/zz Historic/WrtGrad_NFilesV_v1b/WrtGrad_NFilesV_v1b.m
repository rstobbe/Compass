%=========================================================
%
%=========================================================

function [SCRPTipt,WRT,err] = WrtGrad_NFilesV_v1b(SCRPTipt,WRT)

Status('busy','Write Gradient Files');

err.flag = 0;
err.msg = '';

GradDefLoc = WRT.wrtgradfunc.Struct.('GradDefLoc');
WRT.sysgmax = str2double(WRT.wrtgradfunc.('sysgmax_mT_m'));
dowrite = WRT.wrtgradfunc.('WriteGrads');

%-------------------------------------------------
% Select WRT Directory
%-------------------------------------------------
[GradLoc] = uigetdir(GradDefLoc,'Select/Create Folder for Gradient Waveforms');
if GradLoc == 0
    err.flag = 3;
    err.msg = 'User Aborted';
    return
end
WRT.GradLoc = GradLoc;
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
rel = (1/WRT.sysgmax) * 32767; 
G = round(rel*WRT.G);

%-------------------------------------------------
% Write Gradients to File
%-------------------------------------------------
L = length(G(:,1,1));
if strcmp(WRT.sym,'PosNeg')
    L = L/2;
end
W = length(G(1,:,1));

for n = 1:L
    GxV = zeros(W,2);
    GyV = zeros(W,2);
    GzV = zeros(W,2);
    GxV(:,1) = G(n,:,1);
    GyV(:,1) = G(n,:,2);    
    GzV(:,1) = G(n,:,3);
    GxV(:,2) = WRT.rdur;
    GyV(:,2) = WRT.rdur;    
    GzV(:,2) = WRT.rdur;   
   
    loc = [GradLoc,'\Gx',num2str(n),'.GRD'];
    dlmwrite(loc,GxV,'delimiter','\t','newline','unix');
    loc = [GradLoc,'\Gy',num2str(n),'.GRD'];
    dlmwrite(loc,GyV,'delimiter','\t','newline','unix');
    loc = [GradLoc,'\Gz',num2str(n),'.GRD'];
    dlmwrite(loc,GzV,'delimiter','\t','newline','unix');
    Status2('busy',['File Number: ',num2str(n)],2);
end
Status2('done','',2);
