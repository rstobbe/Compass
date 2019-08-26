%===========================================
% 
%===========================================

function [TF,err] = TFBuild_TPIstandfromdesreload_v1a_Func(TF,INPUT)

Status2('busy','Create Transfer Function',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
DES = TF.DES;
PROJdgn = DES.PROJdgn;
T = DES.T0;
KSA = DES.KSA;
GAM = DES.TPIT.GAM;
tfdiam = INPUT.tfdiam;
tforient = INPUT.tforient;
Vis = INPUT.vis;
clear INPUT

if isempty(tfdiam)
    tfdiam = PROJdgn.rad*2;
end

%---------------------------------------------
% Build Evolution Relationship
%---------------------------------------------
rad = (KSA(:,:,1).^2 + KSA(:,:,2).^2 + KSA(:,:,3).^2).^0.5;
rad = mean(rad,1);
rad = rad/max(rad);
ind = find(rad >= PROJdgn.p,1,'first');
rad = [0 rad(ind:end)];

T = T(ind:end)-T(ind);
T = PROJdgn.TPIiseg + ((PROJdgn.tro-PROJdgn.TPIiseg)/T(end))*T;
tatr = [0 T];

if strcmp(Vis,'On')
    figure(100); subplot(2,2,4); hold on;
    plot(tatr,rad,'k'); 
    ylabel('Relative k-Space Radius'); xlabel('Time (ms)'); title('Trajectory Timing') 
end

%---------------------------------------------
% Variables / Structures
%---------------------------------------------
RLX = TF.RLX;
RLX.r = rad;
RLX.tatr = tatr;
RLX.diam = tfdiam;
RLX.elip = PROJdgn.elip;
FLT.r = GAM.r;
FLT.tf = GAM.GamShape;
FLT.diam = tfdiam;
FLT.elip = PROJdgn.elip;

%---------------------------------------------
% Get Signal Decay Function
%---------------------------------------------
func = str2func([TF.sigdecfunc,'_Func']);  
INPUT = struct();
[RLX,err] = func(RLX,INPUT);
if err.flag
    return
end
clear INPUT;

%--------------------------------------
% Build Filtering Shape
%--------------------------------------
[FLT,err] = FltTF_Build_v4a(FLT);
if err.flag == 1
    return
end
FltTF = FLT.tf;
if strcmp(tforient,'Sagittal')
    FltTF = permute(FltTF,[3 2 1]);
elseif strcmp(tforient,'Coronal')
    FltTF = permute(FltTF,[1 3 2]);
end
if strcmp(Vis,'On')
    figure(100); subplot(2,2,1); hold on;
    plot(squeeze(FltTF((length(FltTF)+1)/2,(length(FltTF)+1)/2,:)),'k:'); 
    plot(squeeze(FltTF(:,(length(FltTF)+1)/2,(length(FltTF)+1)/2)),'k'); 
    ylim([0 max(FltTF(:))*1.05]); xlim([1 length(FltTF)]);
    xlabel('k-Space Matrix'); ylabel('Relative Value'); title('Filter')  
end

%--------------------------------------
% Build Signal Decay Shape
%--------------------------------------
[RLX,err] = RlxTF_Build_v4a(RLX);
if err.flag == 1
    return
end
if (FLT.Tot ~= RLX.Tot)
    error('RlxTF and FiltTF not the same size');
end
RlxTF = RLX.tf;
if strcmp(tforient,'Sagittal')
    RlxTF = permute(RlxTF,[3 2 1]);
elseif strcmp(tforient,'Coronal')
    RlxTF = permute(RlxTF,[1 3 2]);
end
if strcmp(Vis,'On')
    figure(100); subplot(2,2,2); hold on;
    plot(squeeze(RlxTF((length(RlxTF)+1)/2,(length(RlxTF)+1)/2,:)),'k:'); 
    plot(squeeze(RlxTF(:,(length(RlxTF)+1)/2,(length(RlxTF)+1)/2)),'k'); 
    ylim([0 max(RlxTF(:))*1.05]); xlim([1 length(RlxTF)]);
    xlabel('k-Space Matrix'); ylabel('Relative Value'); title('Signal Decay')  
end

%--------------------------------------
% Combine
%--------------------------------------
tf = FltTF.*RlxTF;
if strcmp(Vis,'On')
    figure(100); subplot(2,2,3); hold on;
    plot(squeeze(tf((length(tf)+1)/2,(length(tf)+1)/2,:)),'k:'); 
    plot(squeeze(tf(:,(length(tf)+1)/2,(length(tf)+1)/2)),'k'); 
    ylim([0 max(tf(:))*1.05]); xlim([1 length(tf)]);
    xlabel('k-Space Matrix'); ylabel('Relative Value'); title('Transfer Function')      
end
TF.tf = tf;

%---------------------------------------------
% Panel
%---------------------------------------------
Panel0(1,:) = {'','','Output'};
Panel0(2,:) = {'Method',TF.method,'Output'};
Panel0(3,:) = {'','','Output'};

Panel = [Panel0;RLX.Panel];
PanelOutput = cell2struct(Panel,{'label','value','type'},2);   

TF.Panel = Panel;
TF.PanelOutput = PanelOutput;

Status2('done','',2);
Status2('done','',3);


