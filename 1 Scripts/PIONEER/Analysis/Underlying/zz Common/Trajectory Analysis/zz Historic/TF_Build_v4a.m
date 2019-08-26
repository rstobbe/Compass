%======================================================
%
%======================================================

function [TF,err] = TF_Build_v4a(TF,FLT,RLX,SUS)

Vis = 'On';

%--------------------------------------
% Build Gamma Function
%--------------------------------------
[FLT,err] = FltTF_Build_v4a(TF,FLT);
if err.flag == 1
    return
end
FltTF = FLT.FltTF;
if strcmp(TF.orient,'Sagittal')
    FltTF = permute(FltTF,[3 2 1]);
elseif strcmp(TF.orient,'Coronal')
    FltTF = permute(FltTF,[1 3 2]);
end
if strcmp(Vis,'On')
    figure(100); hold on; plot(squeeze(FltTF((length(FltTF)+1)/2,(length(FltTF)+1)/2,:))); 
    ylim([0 max(FltTF(:))*1.1]);
    title('Filtering Shape');
end

%--------------------------------------
% Build Relaxation Function
%--------------------------------------
[RLX,err] = RlxTF_Build_v4a(TF,RLX);
if err.flag == 1
    return
end
if (FLT.Tot ~= RLX.Tot)
    error('RlxTF and FiltTF not the same size');
end
RlxTF = RLX.RlxTF;
if strcmp(TF.orient,'Sagittal')
    RlxTF = permute(RlxTF,[3 2 1]);
elseif strcmp(TF.orient,'Coronal')
    RlxTF = permute(RlxTF,[1 3 2]);
end
if strcmp(Vis,'On')
    figure(101); hold on; plot(squeeze(RlxTF((length(RlxTF)+1)/2,(length(RlxTF)+1)/2,:))); 
    ylim([0 max(RlxTF(:))*1.1]);
    title('Signal Decay Function');
end

%--------------------------------------
% Build Susceptibility Function
%--------------------------------------
if not(strcmp(SUS.func,'none'))
    [SusTF,TotSus] = SusTF_Build_v2(SUS,TF_diam);
    if (TotGam ~= TotSus)
        error();
    end
    if strcmp(Vis,'On')
        figure(102); hold on; plot(squeeze(SusTF((length(SusTF)+1)/2,(length(SusTF)+1)/2,:))); title('Susceptibility Function');
    end
else
    SusTF = ones(size(FltTF));
end

%--------------------------------------
% Combine
%--------------------------------------
tf = FltTF.*RlxTF.*SusTF;
if strcmp(Vis,'On')
    TFprof = squeeze(tf((length(tf)+1)/2,(length(tf)+1)/2,:));
    TFprof = TFprof ./ max(TFprof(:));
    figure(103); hold on; plot(TFprof); 
    ylim([0 max(TFprof(:))*1.1]);
    title('Transfer Function');
end
TF.tf = tf;
