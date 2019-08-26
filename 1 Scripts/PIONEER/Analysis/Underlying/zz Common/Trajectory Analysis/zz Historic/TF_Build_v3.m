%======================================================
%
%======================================================

function [TF,Tot] = TF_Build_v3(TRAJ,RLX,SUS,TF_diam,Vis)

[GamTF,TotGam] = GamTF_Build_v3(TRAJ,TF_diam);
if strcmp(TRAJ.orient,'Sagittal')
    GamTF = permute(GamTF,[3 2 1]);
elseif strcmp(TRAJ.orient,'Coronal')
    GamTF = permute(GamTF,[1 3 2]);
end
if strcmp(Vis,'On')
    figure(100); hold on; plot(squeeze(GamTF((length(GamTF)+1)/2,(length(GamTF)+1)/2,:))); title('Gamma Function');
end
[RlxTF,TotRlx] = RlxTF_Build_v3(TRAJ,RLX,TF_diam);
if (TotGam ~= TotRlx)
    error();
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