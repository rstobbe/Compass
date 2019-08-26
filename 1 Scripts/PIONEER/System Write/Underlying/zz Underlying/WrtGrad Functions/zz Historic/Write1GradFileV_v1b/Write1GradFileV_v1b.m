%=========================================================
%
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = Write1GradFileV_v1b(SCRPTipt,SCRPTGBL)

err.flag = 0;

%-------------------------------------------------
% Select Output Directory
%-------------------------------------------------
GradDefLoc = SCRPTipt(strcmp('GradDefLoc',{SCRPTipt.labelstr})).runfuncoutput{1};
[GradLoc] = uigetdir(GradDefLoc,'Select Directory to Write Gradients');
if GradLoc == 0
    err.flag = 1;
    err.msg = 'User Aborted';
    return
end
if exist([GradLoc,'\Gx1.GRD'],'file');
    err.flag = 1;
    err.msg = 'Gradient Files Already Exist in this Path';
    return
end
SCRPTGBL.GradFile.loc = GradLoc;

%-------------------------------------------------
% Calculate Varian Gradient Value
%-------------------------------------------------
gmax = str2double(SCRPTipt(strcmp('sysgmax (mT/m)',{SCRPTipt.labelstr})).entrystr);
rel = (1/gmax) * 32767; 
G = round(rel*SCRPTGBL.GradFile.G);

%-------------------------------------------------
% Write Gradients to File
%-------------------------------------------------
L = length(G(:,1));

GxV = zeros(L,2);
GyV = zeros(L,2);
GzV = zeros(L,2);

GxV(:,1) = G(:,1);
GyV(:,1) = G(:,2);    
GzV(:,1) = G(:,3);
GxV(:,2) = SCRPTGBL.GradFile.rdur;
GyV(:,2) = SCRPTGBL.GradFile.rdur;    
GzV(:,2) = SCRPTGBL.GradFile.rdur;   
      
loc = [GradLoc,'\Gx1.GRD'];
dlmwrite(loc,GxV,'delimiter','\t','newline','unix','-append');
loc = [GradLoc,'\Gy1.GRD'];
dlmwrite(loc,GyV,'delimiter','\t','newline','unix','-append');
loc = [GradLoc,'\Gz1.GRD'];
dlmwrite(loc,GzV,'delimiter','\t','newline','unix','-append');


