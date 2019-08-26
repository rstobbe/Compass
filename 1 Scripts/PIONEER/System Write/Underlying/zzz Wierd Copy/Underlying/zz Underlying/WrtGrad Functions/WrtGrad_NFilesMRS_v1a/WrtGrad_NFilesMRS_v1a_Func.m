%=========================================================
%
%=========================================================

function [WRTG,err] = WrtGrad_NFilesMRS_v1a_Func(WRTG,INPUT)

Status2('busy','Write Gradient Files to MRS',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-------------------------------------------------
% Get input
%-------------------------------------------------
IMP = INPUT.IMP;
G = IMP.G;
clear INPUT

%-------------------------------------------------
% Common Variables
%-------------------------------------------------
GradDefLoc = WRTG.GradDefLoc;
dowrite = WRTG.dowrite;

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
if exist([GradLoc,'\Gx1.txt'],'file');
    err.flag = 1;
    err.msg = 'Gradient Files Already Exist in this Path';
    return
end

%-------------------------------------------------
% Calculate Varian Gradient Value
%-------------------------------------------------
relX = (1/WRTG.sysgmaxX) * 32767; 
relY = (1/WRTG.sysgmaxY) * 32767; 
relZ = (1/WRTG.sysgmaxZ) * 32767; 
G(:,:,1) = round(relX*G(:,:,1));
G(:,:,2) = round(relY*G(:,:,2));
G(:,:,3) = round(relZ*G(:,:,3));

%-------------------------------------------------
% Write Gradients to File
%-------------------------------------------------
L = length(G(:,1,1));
M = length(G(1,:,1));
for n = 1:L
    Status2('busy',['File Number: ',num2str(n)],3);    
    locx = [GradLoc,'\Gx',num2str(n),'.txt'];
    locy = [GradLoc,'\Gy',num2str(n),'.txt'];
    locz = [GradLoc,'\Gz',num2str(n),'.txt'];
    
    %-------------------------------------------------
    % Write Header Line
    %-------------------------------------------------
    dlmwrite(locx,[M,3,0],'delimiter',char(32),'newline','pc');
    dlmwrite(locy,[M,3,0],'delimiter',char(32),'newline','pc');
    dlmwrite(locz,[M,3,0],'delimiter',char(32),'newline','pc');
    
    %-------------------------------------------------
    % Write Data
    %-------------------------------------------------   
    dlmwrite(locx,squeeze(G(n,:,1)).','-append','newline','pc');
    dlmwrite(locy,squeeze(G(n,:,2)).','-append','newline','pc');
    dlmwrite(locz,squeeze(G(n,:,3)).','-append','newline','pc');
end

Status2('done','',2);
Status2('done','',3);
