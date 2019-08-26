%====================================================
%
%====================================================

function [SCRPTipt] = TrajAnlzBasic_v1(SCRPTipt,SCRPTGBL)

addpath(genpath('D:\0 Programs\A0 AID_TRICS\1 Underlying\3 System\1 Varian\'));
addpath(genpath('D:\0 Programs\A0 AID_TRICS\1 Underlying\0 General'));

Sys = SCRPTipt(strcmp('System',{SCRPTipt.labelstr})).entrystr;
if iscell(Sys)
    Sys = SCRPTipt(strcmp('System',{SCRPTipt.labelstr})).entrystr{SCRPTipt(strcmp('System',{SCRPTipt.labelstr})).entryvalue};
end
loc1 = str2double(SCRPTipt(strcmp('loc1',{SCRPTipt.labelstr})).entrystr);
loc2 = str2double(SCRPTipt(strcmp('loc2',{SCRPTipt.labelstr})).entrystr);


%-------------------------------------
% Load Experiment
%-------------------------------------
if strcmp(Sys,'Varian')
    [FID1] = ImportFIDmat_v1([SCRPTGBL.outpath2,'\fid']);
    [FID2] = ImportFIDmat_v1([SCRPTGBL.outpath3,'\fid']);
    [dwell1,np1] = GetRelParsVarian([SCRPTGBL.outpath2,'\Params']);
    [dwell2,np2] = GetRelParsVarian([SCRPTGBL.outpath3,'\Params']);
end
if np1~=np2 || dwell1~=dwell2
    Status('error','files do not match');
    return
else 
    np = np1;
    dwell = dwell1;
end
%------
nproj = 6;
FID1 = FID1(nproj,:);       % in future just pick one gradient magnitude (ditch this)...
FID2 = FID2(nproj,:);       
%------

expT = dwell*(0:1:np-1);
%expT = expT-0.5*dwell;                             % Difference value at centre of interval

%-------------------------------------
% Plot FID Magnitude and Phase
%-------------------------------------
PH1 = unwrap(angle(FID1));
PH2 = unwrap(angle(FID2));    
PH = PH2 - PH1;
figure(10); hold on; plot(expT,PH1,'k'); plot(expT,PH2,'k:'); plot(expT,PH,'r'); title('Phase Evolution')
figure(11); hold on; plot(expT,abs(FID1)/10000,'k'); plot(expT,abs(FID2)/10000,'k:'); title('Magnitude Evolution');
                                                             
%-------------------------------------
% Determine Phantom Locations
%-------------------------------------
PHloc1 = zeros(np,1);
PHloc2 = zeros(np,1);
for m = 2:np
    PHloc1(m) = PH1(m) - PH1(m-1);
    PHloc2(m) = PH2(m) - PH2(m-1);
end
Bloc1 = PHloc1/(2*pi*dwell*42.577);     % should be in mT
Bloc2 = PHloc2/(2*pi*dwell*42.577);
figure(12); hold on; plot([0 dwell*np],[0 0],'k:'); plot(expT,Bloc1,'g'); plot(expT,Bloc2,'g'); 
xlabel('ms'); ylabel('mT'); title('Field Evolution');  

sep = loc2 - loc1;

%-------------------------------------
% Determine B0eddy
%-------------------------------------
Geddy = (Bloc2 - Bloc1)/sep;
figure(20); hold on; plot([0 dwell*np],[0 0],'k:'); plot(expT,Geddy,'r');        
xlabel('ms'); ylabel('mT/m'); title('Measured Gradient Field');

B0eddy1 = Bloc1 - Geddy*loc1;
%B0eddy2 = Bloc2 - Geddy*loc2;      % same as B0eddy1
B0eddy = B0eddy1;
figure(30); hold on; plot([0 dwell*np],[0 0],'k:'); plot(expT,B0eddy,'b');
xlabel('ms'); ylabel('mT'); title('Measured B0 Field');


