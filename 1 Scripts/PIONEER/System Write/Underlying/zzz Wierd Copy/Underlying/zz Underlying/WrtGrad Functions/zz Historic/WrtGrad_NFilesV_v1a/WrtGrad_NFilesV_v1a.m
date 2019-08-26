%=========================================================
%
%=========================================================

function [WRT,SCRPTipt,err] = WrtGrad_NFilesV_v1a(WRT,SCRPTipt,err)

GradDefLoc = SCRPTipt(strcmp('GradDefLoc',{SCRPTipt.labelstr})).runfuncoutput{1};
WRT.sysgmax = str2double(SCRPTipt(strcmp('sysgmax (mT/m)',{SCRPTipt.labelstr})).entrystr);

%-------------------------------------------------
% Select WRT Directory
%-------------------------------------------------
[GradLoc] = uigetdir(GradDefLoc,'Select Directory to Write Gradients');
if GradLoc == 0
    err.flag = 3;
    err.msg = 'User Aborted';
    return
end
%if exist([GradLoc,'\Gx1.GRD'],'file');
%    err.flag = 1;
%    err.msg = 'Gradient Files Already Exist in this Path';
%    return
%end
WRT.GradLoc = GradLoc;

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

    dowrite = 1;
    if dowrite == 1
        loc = [GradLoc,'\Gx',num2str(n),'.GRD'];
        dlmwrite(loc,GxV,'delimiter','\t','newline','unix');
        loc = [GradLoc,'\Gy',num2str(n),'.GRD'];
        dlmwrite(loc,GyV,'delimiter','\t','newline','unix');
        loc = [GradLoc,'\Gz',num2str(n),'.GRD'];
        dlmwrite(loc,GzV,'delimiter','\t','newline','unix');
    end
end

