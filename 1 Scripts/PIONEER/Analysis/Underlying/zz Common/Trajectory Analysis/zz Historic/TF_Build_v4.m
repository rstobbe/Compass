%======================================================
%
%======================================================

function [TF,Tot,err] = TF_Build_v4(TRAJ,RLX,SUS,TF_diam,Vis,err)

TF = [];
Tot = [];

%--------------------------------------
% Build Gamma Function
%--------------------------------------
[GamTF,TotGam,err] = GamTF_Build_v4(TRAJ,TF_diam,err);
if err.flag == 1
    return
end
if strcmp(TRAJ.orient,'Sagittal')
    GamTF = permute(GamTF,[3 2 1]);
elseif strcmp(TRAJ.orient,'Coronal')
    GamTF = permute(GamTF,[1 3 2]);
end
if strcmp(Vis,'On')
    figure(100); hold on; plot(squeeze(GamTF((length(GamTF)+1)/2,(length(GamTF)+1)/2,:))); title('Gamma Function');
end

%--------------------------------------
% Build Relaxation Function
%--------------------------------------
[RlxTF,TotRlx,err] = RlxTF_Build_v4(TRAJ,RLX,TF_diam,err);
if err.flag == 1
    return
end
if (TotGam ~= TotRlx)
    error('RlxTF and GamTF not the same size');
end
if strcmp(TRAJ.orient,'Sagittal')
    RlxTF = permute(RlxTF,[3 2 1]);
elseif strcmp(TRAJ.orient,'Coronal')
    RlxTF = permute(RlxTF,[1 3 2]);
end
if strcmp(Vis,'On')
    figure(101); hold on; plot(squeeze(RlxTF((length(RlxTF)+1)/2,(length(RlxTF)+1)/2,:))); title('Signal Decay Function');
end
if not(strcmp(SUS.func,'none'))
    [SusTF,TotSus] = SusTF_Build_v2(SUS,TF_diam);
    if (TotGam ~= TotSus)
        error();
    end
    if strcmp(Vis,'On')
        figure(102); hold on; plot(squeeze(SusTF((length(SusTF)+1)/2,(length(SusTF)+1)/2,:))); title('Susceptibility Function');
    end
else
    SusTF = ones(size(GamTF));
end

Tot = TotGam;
TF = GamTF.*RlxTF.*SusTF;
if strcmp(Vis,'On')
    TFprof = squeeze(TF((length(TF)+1)/2,(length(TF)+1)/2,:));
    TFprof = TFprof ./ max(TFprof(:));
    figure(103); hold on; plot(TFprof); title('Transfer Function');
end