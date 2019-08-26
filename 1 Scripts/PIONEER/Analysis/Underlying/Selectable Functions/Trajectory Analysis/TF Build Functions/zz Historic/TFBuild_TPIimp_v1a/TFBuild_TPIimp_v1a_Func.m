%===========================================
% 
%===========================================

function [TF,err] = TFBuild_TPIimp_v1a_Func(TF,INPUT)

Status2('busy','Create Transfer Function',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
IMP = INPUT.IMP;
tfdiam = INPUT.tfdiam;
tforient = INPUT.tforient;
Vis = INPUT.vis;
clear INPUT

%--------------------------------------------
% TF diameter
%--------------------------------------------
PROJdgn = IMP.PROJdgn;
if isempty(tfdiam)
    tfdiam = PROJdgn.rad*2;
end

%--------------------------------------------
% Calculate tatr
%--------------------------------------------
Kmat = IMP.Kmat;
r = sqrt(Kmat(:,:,1).^2 + Kmat(:,:,2).^2 + Kmat(:,:,3).^2);
r = mean(r,1);
r = r/max(r);
tatr = IMP.samp;
if strcmp(Vis,'On')
    figure(100); subplot(2,2,4); hold on;
    plot(PROJdgn.tatr,PROJdgn.r,'k'); 
    plot(tatr,r,'r'); 
    ylabel('Relative k-Space Radius'); xlabel('Time (ms)'); title('Trajectory Timing') 
    %legend('Design','Implementation');
end

%---------------------------------------------
% Variables / Structures
%---------------------------------------------
RLX = TF.RLX;
RLX.r = r;
RLX.tatr = tatr;
RLX.diam = tfdiam;
RLX.elip = PROJdgn.elip;
FLT.r = PROJdgn.r;
FLT.tf = PROJdgn.sdcTF;
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

Status2('done','',2);
Status2('done','',3);


