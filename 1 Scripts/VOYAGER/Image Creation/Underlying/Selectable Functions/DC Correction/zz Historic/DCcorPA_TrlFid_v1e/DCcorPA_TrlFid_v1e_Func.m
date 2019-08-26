%=====================================================
%
%=====================================================

function [DCCOR,err] = DCcorPA_TrlFid_v1e_Func(DCCOR,INPUT)

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
    trajno = 1;
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
            trlpts = FIDmat(m,np-trfidpts+1:np,n);
            stesearch = abs(trlpts)/median(abs(trlpts));
            stetest(n,m) = max(stesearch);
            if stetest(n,m) > 1.5
                %clf(figure(1101)); hold on;
                %plot(real(FIDmat(m,:,n)),'r');
                %plot(imag(FIDmat(m,:,n)),'b');
                %plot(abs(FIDmat(m,:,n)),'c');
                %plot([np-trfidpts np-trfidpts],[min([real(FIDmat(trajno,:,1)) imag(FIDmat(trajno,:,1))]) max([real(FIDmat(trajno,:,1)) imag(FIDmat(trajno,:,1))])],'k:');
                %xlabel('Readout Points'); title('DC Offset (One Trajectory)');
                goodinds = ones(1,length(trlpts));
                inds = find(stesearch > 1.5);
                for p = 1:length(inds)
                    if inds(p)-8 < 1
                        inds(p) = 9;
                    end
                    goodinds(inds(p)-8:inds(p)+8) = 0;
                end   
                %clf(figure(1102)); hold on;
                %plot(abs(trlpts),'c');
                %plot(real(trlpts),'r');
                %plot(imag(trlpts),'b');
                %plot(goodinds*mean(abs(trlpts)),'k');
                %xlabel('Trailing Points Used'); title('DC Offset (One Trajectory)'); 
                trlpts = trlpts(logical(goodinds));   
            end
            %medR = median(real(trlpts))
            %medI = median(imag(trlpts))
            %dcval(m,n) = medR + 1i*medI;
            dcval(m,n) = mean(trlpts);
        end
        rsmdc = smooth(squeeze(real(dcval(:,n))),200);
        ismdc = smooth(squeeze(imag(dcval(:,n))),200);
        if strcmp(visuals,'Yes')
            figure(1102); hold on
            plot(real(dcval(:,n)),'r');
            plot(imag(dcval(:,n)),'b');
            plot(rsmdc,'k');
            plot(ismdc,'k');
            xlabel('trajectory number'); ylabel('DC offset'); title('DC offset variation');
        end
        dcval(:,n) = rsmdc + 1i*ismdc;    
        for m = 1:nproj
            FIDmat(m,:,n) = FIDmat(m,:,n) - dcval(m,n);
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



