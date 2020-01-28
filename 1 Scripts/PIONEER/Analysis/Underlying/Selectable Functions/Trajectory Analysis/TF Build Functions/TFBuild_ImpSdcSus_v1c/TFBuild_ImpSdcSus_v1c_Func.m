%===========================================
% 
%===========================================

function [TF,err] = TFBuild_ImpSdcSus_v1c_Func(TF,INPUT)

Status2('busy','Create Transfer Function',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
IMP = INPUT.IMP;
PROJdgn = IMP.PROJdgn;
tfdiam = INPUT.tfdiam;
tforient = INPUT.tforient;
Vis = INPUT.vis;
TFO = TF.SDCS.TFO;
RLX = TF.RLX;
clear INPUT

%--------------------------------------------
% TF diameter
%--------------------------------------------
if isempty(tfdiam)
    tfdiam = (PROJdgn.rad*2)/TF.scaledown;
end

%--------------------------------------------
% Calculate tatr
%--------------------------------------------
Kmat = IMP.Kmat;
samp0 = IMP.samp;
samp = samp0 - 2*samp0(1) + samp0(2); 
r = sqrt(Kmat(:,:,1).^2 + Kmat(:,:,2).^2 + Kmat(:,:,3).^2);
r = mean(r,1);
r = [0 r/max(r)];
tatr = [0 samp];
if strcmp(Vis,'On')
    figure(100); subplot(2,2,4); hold on; box on;
    plot(tatr,r,'k'); 
    xlim([0 ceil(tatr(end))]);
    ylabel('Relative k-Space Radius'); xlabel('Time (ms)'); title('Trajectory Timing') 
end

%---------------------------------------------
% Variables / Structures
%---------------------------------------------
RLX.r = r;
RLX.tatr = tatr;
RLX.diam = tfdiam;
if isfield(PROJdgn,'elip')
    RLX.elip = PROJdgn.elip;
else
    RLX.elip = 1;
end
FLT.r = TFO.r;
FLT.tf = TFO.tf;
FLT.diam = tfdiam;
if isfield(PROJdgn,'elip')
    FLT.elip = PROJdgn.elip;
else
    FLT.elip = 1;
end

%---------------------------------------------
% Get Signal Decay Function
%---------------------------------------------
func = str2func([TF.sigdecfunc,'_Func']);  
INPUT = [];
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
    figure(100); subplot(2,2,1); hold on; box on;
    plot(squeeze(FltTF((length(FltTF)+1)/2,(length(FltTF)+1)/2,:)),'k:'); 
    plot(squeeze(FltTF(:,(length(FltTF)+1)/2,(length(FltTF)+1)/2)),'k'); 
    ylim([0 max(FltTF(:))*1.05]); xlim([1 length(FltTF)]);
    xlabel('k-Space Matrix'); ylabel('Relative Value'); title('Filter')  
end

%--------------------------------------
% Build Signal Decay Shape
%--------------------------------------
RLX.offres = TF.offres;
[RLX,err] = RlxSusTF_Build_v4a(RLX);
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
    figure(100); subplot(2,2,2); hold on; box on;
    plot(abs(squeeze(RlxTF((length(RlxTF)+1)/2,(length(RlxTF)+1)/2,:))),'k:'); 
    plot(abs(squeeze(RlxTF(:,(length(RlxTF)+1)/2,(length(RlxTF)+1)/2))),'k'); 
    plot(real(squeeze(RlxTF((length(RlxTF)+1)/2,(length(RlxTF)+1)/2,:))),'r:'); 
    plot(real(squeeze(RlxTF(:,(length(RlxTF)+1)/2,(length(RlxTF)+1)/2))),'r'); 
    plot(imag(squeeze(RlxTF((length(RlxTF)+1)/2,(length(RlxTF)+1)/2,:))),'b:'); 
    plot(imag(squeeze(RlxTF(:,(length(RlxTF)+1)/2,(length(RlxTF)+1)/2))),'b'); 
    ylim([0 max(RlxTF(:))*1.05]); xlim([1 length(RlxTF)]);
    xlabel('k-Space Matrix'); ylabel('Relative Value'); title('Signal Decay')  
end

%--------------------------------------
% Combine
%--------------------------------------
tf = FltTF.*RlxTF;
if strcmp(Vis,'On')
    fhand = figure(100); subplot(2,2,3); hold on; box on;
    plot(abs(squeeze(tf((length(tf)+1)/2,(length(tf)+1)/2,:))),'k:'); 
    plot(abs(squeeze(tf(:,(length(tf)+1)/2,(length(tf)+1)/2))),'k'); 
    plot(real(squeeze(tf((length(tf)+1)/2,(length(tf)+1)/2,:))),'r:'); 
    plot(real(squeeze(tf(:,(length(tf)+1)/2,(length(tf)+1)/2))),'r'); 
    plot(imag(squeeze(tf((length(tf)+1)/2,(length(tf)+1)/2,:))),'b:'); 
    plot(imag(squeeze(tf(:,(length(tf)+1)/2,(length(tf)+1)/2))),'b'); 
    ylim([0 max(tf(:))*1.05]); xlim([1 length(tf)]);
    xlabel('k-Space Matrix'); ylabel('Relative Value'); title('Transfer Function')      
end
TF.tf = tf;
TF.tfdiam = tfdiam;

%---------------------------------------------
% Return for Save
%---------------------------------------------
fig = 1;
TF.Figure(fig).Name = 'TransferFunction';
TF.Figure(fig).Type = 'NoEps';
TF.Figure(fig).hFig = fhand;
TF.Figure(fig).hAx = gca;

%---------------------------------------------
% Panel
%---------------------------------------------
Panel0(1,:) = {'','','Output'};
Panel0(2,:) = {'Method',TF.method,'Output'};
Panel0(3,:) = {'','','Output'};

Panel = [Panel0;TFO.Panel;RLX.Panel];
PanelOutput = cell2struct(Panel,{'label','value','type'},2);   

TF.Panel = Panel;
TF.PanelOutput = PanelOutput;
TF = rmfield(TF,'SDCS');

Status2('done','',2);
Status2('done','',3);


