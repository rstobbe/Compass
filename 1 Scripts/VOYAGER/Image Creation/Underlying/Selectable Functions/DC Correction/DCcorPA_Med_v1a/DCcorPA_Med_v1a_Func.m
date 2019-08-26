%=====================================================
%
%=====================================================

function [DCCOR,err] = DCcorPA_Med_v1a_Func(DCCOR,INPUT)

Status2('busy','DC correct FID',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
FIDmat = INPUT.FIDmat;
nrcvrs = INPUT.nrcvrs;
visuals = INPUT.visuals;
clear INPUT;

%---------------------------------------------
% DC correct from median FID values
%---------------------------------------------
nproj = length(FIDmat(:,1,1));

if strcmp(visuals,'Yes')
    figure(1101); hold on;
    trajno = 4;
    plot(real(FIDmat(trajno,:,1)),'r');
    plot(imag(FIDmat(trajno,:,1)),'b');
    xlabel('Readout Points'); title('DC Offset (One Trajectory)');
end

if strcmp(DCCOR.type,'Mean')
    TrajMean = median(FIDmat,1);
    TrajMean = median(TrajMean,2);
    squeeze(TrajMean)
    for n = 1:nrcvrs
        dcval(n) = TrajMean(n);    
        FIDmat(:,:,n) = FIDmat(:,:,n) - dcval(n);
    end
elseif strcmp(DCCOR.type,'Individual')
    for n = 1:nrcvrs
        for m = 1:nproj
            dcval(m,n) = median(FIDmat(m,:,n));    
            FIDmat(m,:,n) = FIDmat(m,:,n) - dcval(m,n);
        end
        if strcmp(visuals,'Yes')
            figure(1102); hold on
            plot(real(dcval(:,n)),'r');
            plot(imag(dcval(:,n)),'b');
            xlabel('trajectory number'); ylabel('DC offset'); title('DC offset variation');
        end
    end
end
    
%--------------------------------------------
% Panel
%--------------------------------------------
Panel(1,:) = {'DCval_Mean',mean(dcval(:)),'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);

%---------------------------------------------
% Return
%---------------------------------------------
DCCOR.FIDmat = FIDmat;
DCCOR.dcval = dcval;
DCCOR.PanelOutput = PanelOutput;

Status2('done','',2);
Status2('done','',3);



