%====================================================
%
%====================================================

function [SCRPTipt] = TA_Bipolar_v1(SCRPTipt,SCRPTGBL)

addpath(genpath('D:\0 Programs\A0 AID_TRICS\1 Underlying\3 System\1 Varian\'));
addpath(genpath('D:\0 Programs\A0 AID_TRICS\1 Underlying\0 General'));

Sys = SCRPTipt(strcmp('System',{SCRPTipt.labelstr})).entrystr;
if iscell(Sys)
    Sys = SCRPTipt(strcmp('System',{SCRPTipt.labelstr})).entrystr{SCRPTipt(strcmp('System',{SCRPTipt.labelstr})).entryvalue};
end
nproj = str2double(SCRPTipt(strcmp('nproj',{SCRPTipt.labelstr})).entrystr);
DesGradSet = SCRPTipt(strcmp('Design_File',{SCRPTipt.labelstr})).entrystr;

%-------------------------------------
% Load Experiment
%-------------------------------------
[FID1,FID2,expT,GradSet,np,dwell,errorflag] = Load_2LocExperiment_v1(SCRPTGBL,Sys);
if errorflag == 1
    return
end
if not(strcmp(DesGradSet,GradSet))
    Status('error','experiment does not match design');
end

%-------------------------------------
% Load Design
%-------------------------------------
load(SCRPTGBL.outpath4);        
whos
if not(strcmp(Exp.gradient,'Bipolar'))
    Status('error','This script is only appropriate for short-eddy Bipolar gradient analysis');
end

G = dG(nproj,:);                  
Gmax = dGmax(nproj);

gmaxloc1 = find(expT > Exp.testlocs.max1,1,'first');             
gmaxloc2 = find(expT > Exp.testlocs.max2,1,'first');
gzeroloc1 = find(expT > Exp.testlocs.zero1,1,'first');             
gzeroloc2 = find(expT > Exp.testlocs.zero2,1,'first');

oGsl = '';
oGmax = '';
for k = 1:length(dGsl)
    oGsl = [oGsl,' ',num2str(dGsl(k))];
    oGmax = [oGmax,' ',num2str(dGmax(k))];
end
n = length(SCRPTipt)+1;
SCRPTipt(n).number = n;
SCRPTipt(n).labelstyle = '0smalloutput';
SCRPTipt(n).labelstr = 'Gslp (mT/m*ms)';
SCRPTipt(n).entrystyle = '0text';
SCRPTipt(n).entrystr = oGsl;
SCRPTipt(n).unitstyle = '0text';
SCRPTipt(n).unitstr = '';

n = n+1;
SCRPTipt(n).number = n;
SCRPTipt(n).labelstyle = '0smalloutput';
SCRPTipt(n).labelstr = 'Gmax (mT/m*)';
SCRPTipt(n).entrystyle = '0text';
SCRPTipt(n).entrystr = oGmax;
SCRPTipt(n).unitstyle = '0text';
SCRPTipt(n).unitstr = '';

%-------------------------------------
% Select Gradient
%-------------------------------------
[nprojs,~] = size(FID1);
if nproj > nprojs
    errorflag = 1;
    Status('error','nproj too great');
    return    
end 
FID1 = FID1(nproj,:);       
FID2 = FID2(nproj,:);

%-------------------------------------
% Plot FID Magnitude and Phase
%-------------------------------------
PH1 = unwrap(angle(FID1));
PH2 = unwrap(angle(FID2));    
PH = PH2 - PH1;
figure(10); hold on; plot(expT,PH1,'k'); plot(expT,PH2,'k:'); title('Phase Evolution')
figure(11); hold on; plot(expT,abs(FID1)/10000,'k'); plot(expT,abs(FID2)/10000,'k:'); title('Magnitude Evolution');
                                                             
%-------------------------------------
% Field Evolulution 
%-------------------------------------
PHloc1 = zeros(np,1);
PHloc2 = zeros(np,1);
for m = 2:np
    PHloc1(m) = PH1(m) - PH1(m-1);
    PHloc2(m) = PH2(m) - PH2(m-1);
end
Bloc1 = PHloc1/(2*pi*dwell*42.577);     % should be in mT
Bloc2 = PHloc2/(2*pi*dwell*42.577);
figure(12); hold on; plot([0 dwell*np],[0 0],'k:'); plot(expT,Bloc1,'k'); plot(expT,Bloc2,'k:'); 
xlabel('ms'); ylabel('mT'); xlim([0 dwell*np]); title('Field Evolution (Total)');  

Bbgloc1 = mean(Bloc1(gzeroloc1:gzeroloc2));
Bbgloc2 = mean(Bloc2(gzeroloc1:gzeroloc2));

Bloc1 = Bloc1 - Bbgloc1;
Bloc2 = Bloc2 - Bbgloc2;
figure(13); hold on; plot([0 dwell*np],[0 0],'k:'); plot(expT,Bloc1,'k'); plot(expT,Bloc2,'k:'); 
xlabel('ms'); ylabel('mT'); xlim([0 dwell*np]); title('Field Evolution (BG Normalized)');  

%-------------------------------------
% Phantom Locations
%-------------------------------------
loc1 = mean(Bloc1(gmaxloc1:gmaxloc2))/Gmax;                                  % return
loc2 = mean(Bloc2(gmaxloc1:gmaxloc2))/Gmax;
sep = loc2 - loc1;

n = n+1;
SCRPTipt(n).number = n;
SCRPTipt(n).labelstyle = '0smalloutput';
SCRPTipt(n).labelstr = 'BackGround (mT/m)';
SCRPTipt(n).entrystyle = '0text';
SCRPTipt(n).entrystr = num2str((Bbgloc1 - Bbgloc2)/sep);
SCRPTipt(n).unitstyle = '0text';
SCRPTipt(n).unitstr = '';

n = n+1;
SCRPTipt(n).number = n;
SCRPTipt(n).labelstyle = '0smalloutput';
SCRPTipt(n).labelstr = 'loc1 (m)';
SCRPTipt(n).entrystyle = '0text';
SCRPTipt(n).entrystr = num2str(loc1);
SCRPTipt(n).unitstyle = '0text';
SCRPTipt(n).unitstr = '';

n = n+1;
SCRPTipt(n).number = n;
SCRPTipt(n).labelstyle = '0smalloutput';
SCRPTipt(n).labelstr = 'loc2 (m)';
SCRPTipt(n).entrystyle = '0text';
SCRPTipt(n).entrystr = num2str(loc2);
SCRPTipt(n).unitstyle = '0text';
SCRPTipt(n).unitstr = '';

n = n+1;
SCRPTipt(n).number = n;
SCRPTipt(n).labelstyle = '0smalloutput';
SCRPTipt(n).labelstr = 'separation (m)';
SCRPTipt(n).entrystyle = '0text';
SCRPTipt(n).entrystr = num2str(abs(sep));
SCRPTipt(n).unitstyle = '0text';
SCRPTipt(n).unitstr = '';

%-------------------------------------
% Determine B0eddy
%-------------------------------------
Geddy = (Bloc2 - Bloc1)/sep;
figure(20); hold on; plot([0 dwell*np],[0 0],'k:'); plot(expT,Geddy,'r'); plot(dT,G,'k:');        
xlabel('ms'); ylabel('mT/m'); xlim([0 dwell*np]); title('Measured Gradient Field'); box on; set(gca,'fontsize',10');

B0eddy1 = Bloc1 - Geddy*loc1;
%B0eddy2 = Bloc2 - Geddy*loc2;      % same as B0eddy1
B0eddy = B0eddy1;
figure(30); hold on; plot([0 dwell*np],[0 0],'k:'); plot(expT,B0eddy,'r');
xlabel('ms'); ylabel('mT'); xlim([0 dwell*np]); title('Measured B0 Field');  box on; set(gca,'fontsize',10');


