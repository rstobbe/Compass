%=====================================================
%
%=====================================================

function [DCCOR,err] = DCcorPA_TrlFid_v1c_Func(DCCOR,INPUT)

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
% DC correct from trailing FID values
%---------------------------------------------
np = length(FIDmat(1,:,1));
nproj = length(FIDmat(:,1,1));
trfidpts = round(DCCOR.trfidper*np*0.01);

if strcmp(visuals,'Yes')
    figure(1101); hold on;
    trajno = 4;
    plot(real(FIDmat(trajno,:,1)),'r');
    plot(imag(FIDmat(trajno,:,1)),'b');
    plot([np-trfidpts np-trfidpts],[min([real(FIDmat(trajno,:,1)) imag(FIDmat(trajno,:,1))]) max([real(FIDmat(trajno,:,1)) imag(FIDmat(trajno,:,1))])],'k:');
    xlabel('Readout Points'); title('DC Offset (One Trajectory)');
end

if strcmp(DCCOR.type,'Mean')
    TrajMean = mean(FIDmat,1);
    for n = 1:nrcvrs
        dcval(n) = mean(TrajMean(1,np-trfidpts+1:np,n));    
        FIDmat(:,:,n) = FIDmat(:,:,n) - dcval(n);
    end
elseif strcmp(DCCOR.type,'Individual')
    for n = 1:nrcvrs
        for m = 1:nproj
            dcval(m,n) = mean(FIDmat(m,np-trfidpts+1:np,n));    
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



