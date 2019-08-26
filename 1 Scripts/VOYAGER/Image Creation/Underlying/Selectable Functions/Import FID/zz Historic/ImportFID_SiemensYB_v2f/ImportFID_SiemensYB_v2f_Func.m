%=========================================================
%
%=========================================================

function [FID,err] = ImportFID_SiemensYB_v2f_Func(FID,INPUT)

Status2('busy','Load FID',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMP = INPUT.IC.IMP;
PROJimp = IMP.PROJimp;
KSMP = IMP.KSMP;
DCCOR = FID.DCCOR;
DATA = FID.DATA;
clear INPUT;

%---------------------------------------------
% Get Measurement ID
%---------------------------------------------
ind = strfind(DATA.file,'_');
DATA.mid = DATA.file(ind(1)+1:ind(2)-1);

%---------------------------------------------
% Test
%---------------------------------------------
if not(isfield(DATA,'FIDmat'))
    err.flag = 1;
    err.msg = 'Reload Data';
    return
end
if not(isempty(FID.rcvrtest))
    FIDmat0 = DATA.FIDmat(:,:,:,FID.rcvrtest,:,:);
else
    FIDmat0 = DATA.FIDmat;
end
DATA = rmfield(DATA,'FIDmat');
FID.DATA = rmfield(FID.DATA,'FIDmat');

%---------------------------------------------
% Test/Facilitate Multi-Echo
%---------------------------------------------
if isfield(KSMP,'SampStart')
    SampStart = KSMP.SampStart;
else
    SampStart = KSMP.DiscardStart+1;
end

%---------------------------------------------
% Do Averging
%---------------------------------------------
if isfield(FID,'doaveraging')
    if strcmp(FID.doaveraging,'Yes')
    	FIDmat0 = mean(FIDmat0,5);
    end
end

%---------------------------------------------
% Test Initial Data Points
%---------------------------------------------
TestTraj = 100;
if strcmp(FID.visuals,'Yes')
    Status2('busy','Plot initial data points',3);
    fh = figure(1000); clf;
    fh.Name = 'Data Testing';
    fh.NumberTitle = 'off';
    fh.Position = [400 150 1000 800];
    subplot(2,2,1); hold on;
    TestFid = squeeze(FIDmat0(TestTraj,:,1,1,1,1));
    plot(real(TestFid),'r:'); plot(imag(TestFid),'b:'); plot(abs(TestFid),'k:');
    TestFid(1:SampStart(1)-1) = NaN + 1i*NaN;
    plot(real(TestFid),'r*'); plot(imag(TestFid),'b*'); plot(abs(TestFid),'k*');
    %xlim([0 100]);
    xlabel('Sampling Points'); title('Sampling Discard Test');
end

%---------------------------------------------
% Drop Data Points
%---------------------------------------------
Status2('busy','Organize data points',3);
if length(SampStart) > 1
    sz = ones(1,6);
    sz0 = size(FIDmat0);
    sz(1:length(sz0)) = sz0;
    sz(2) = KSMP.nproRecon;
    sz(6) = length(SampStart);
    FIDmat = zeros(sz);
    for n = 1:length(SampStart)
        FIDmat(:,:,:,:,:,n) = FIDmat0(:,(SampStart(n):SampStart(n)+KSMP.nproRecon-1),:,:,:);
        if isfield(KSMP,'flip')
            if KSMP.flip(n)
                FIDmat(:,:,:,:,:,n) = flip(FIDmat(:,:,:,:,:,n),2);
            end
        end
    end
else
    FIDmat = FIDmat0(:,(SampStart:SampStart+KSMP.nproRecon-1),:,:,:);
end 
clear FIDmat0;
sz = size(FIDmat);

%---------------------------------------------
% Test For Steady-State Effect
%---------------------------------------------
if strcmp(FID.visuals,'Yes')
    Status2('busy','Plot stead-state',3);
    figure(1000);
    subplot(2,2,2); hold on;
    TestFid = zeros(length(SampStart),sz(1));
    for n = 1:length(SampStart)
        TestFid(n,:) = squeeze(FIDmat(:,1,1,1,1,n));
        plot(real(TestFid(n,:)),'r:'); plot(imag(TestFid(n,:)),'b:'); plot(abs(TestFid(n,:)),'k:');
    end
    plot([0 sz(1)],[0 0],'k:');
    xlim([0 sz(1)]); ylim(1.1*[-max(abs(TestFid(:))) max(abs(TestFid(:)))]);
    xlabel('Trajectories'); title('Steady State Test');
end

%---------------------------------------------
% Drop Dummies
%---------------------------------------------
drop = [];
if isfield(IMP,'dummies')
    drop = IMP.dummies;
end
if isempty(drop)
    if sz(1) > PROJimp.nproj
        drop = sz(1) - PROJimp.nproj;
    end
end
if sz(1) ~= length(IMP.projsampscnr)+drop
    err.flag = 1;
    err.msg = 'Make sure Recon_File matches Data_file';
    return
end
if drop > 0
    Status2('busy','Drop dummies',3);
    FIDmat = FIDmat(drop+1:end,:,:,:,:,:);
    if strcmp(FID.visuals,'Yes')
        figure(1000);
        subplot(2,2,2); hold on;
        plot([drop drop],[-1 1],'k:');
    end
end

%---------------------------------------------
% Test
%---------------------------------------------
sz = size(FIDmat);
if isfield(IMP,'WRTRCN')                                % Old
    WRTRCN = IMP.WRTRCN;
    projsampscnr = WRTRCN.projsampscnr;
    nproj = length(projsampscnr);
elseif isfield(IMP,'TORD')
    TORD = IMP.TORD;                                
    projsampscnr = TORD.projsampscnr;
    nproj = length(projsampscnr);
end
if nproj ~= sz(1)
    error
end
if length(sz) < 4
    sz(3) = 1;
    sz(4) = 1;
    sz(5) = 1;
    sz(6) = 1;
elseif length(sz) < 4
    sz(4) = 1;
    sz(5) = 1;
    sz(6) = 1;
elseif length(sz) < 5
    sz(5) = 1;
    sz(6) = 1;
elseif length(sz) < 6
    sz(6) = 1; 
end

%---------------------------------------------
% Position Correction
%---------------------------------------------
if strcmp(FID.fovadjust,'Yes')
    %---
    shift = DATA.ExpPars.shift/1000;
    shift(2) = -shift(2);
    shift(3) = -shift(3);
    %---
    if shift(1)~=0 || shift(2)~=0 || shift(3)~=0
        for q = 1:sz(6)
            KArr = KMat2Arr(IMP.Kmat(projsampscnr,:,:,q),nproj,IMP.PROJimp.npro);
            for p = 1:sz(5)
                for m = 1:sz(4)
                    Status2('busy',['FoV Adjust: ',num2str(sz(4)-m)],3);
                    for n = 1:sz(3)
                        FIDarr = DatMat2Arr(FIDmat(:,:,n,m,p,q),nproj,IMP.PROJimp.npro);
                        FIDarr = FIDarr.*exp(-1i*2*pi*shift*KArr.').';
                        FIDmat(:,:,n,m,p,q) = DatArr2Mat(FIDarr,nproj,IMP.PROJimp.npro);
                    end
                end
            end
        end
    end
end

%---------------------------------------------
% Radial Evolution
%---------------------------------------------
if strcmp(FID.visuals,'Yes')
    Status2('busy','Plot radial evolution',3);
    figure(1000);
    subplot(2,2,3); hold on;
    for n = 1:length(SampStart)
        TestFid = squeeze(FIDmat(TestTraj,:,1,1,1,n));
        plot(KSMP.rKmag,real(TestFid),'r'); plot(KSMP.rKmag,imag(TestFid),'b'); plot(KSMP.rKmag,abs(TestFid),'k');
    end
    xlim([0 1]);
    xlabel('Relative k-Space'); title('Radial Evolution');
end

%--------------------------------------------
% DC correction
%--------------------------------------------
func = str2func([DCCOR.method,'_Func']);  
INPUT.FIDmat = FIDmat;
INPUT.nrcvrs = sz(4);
INPUT.visuals = FID.visuals;
[DCCOR,err] = func(DCCOR,INPUT);
if err.flag
    return
end
clear INPUT;
FIDmat = DCCOR.FIDmat;
DCCOR = rmfield(DCCOR,'FIDmat');

%---------------------------------------------
% Test DC Correction
%---------------------------------------------
if strcmp(FID.visuals,'Yes')
    Status2('busy','Test DC offset',3);
    figure(1000);
    subplot(2,2,4); hold on;
    TestFid = squeeze(FIDmat(TestTraj,:,1,1,1,1));
    plot(real(TestFid(end-99:end)),'r'); plot(imag(TestFid(end-99:end)),'b');
    plot((1:100),zeros(1,100),'k:');
    xlabel('Last Sampling Points'); title('DC Offset Test');    
end

%--------------------------------------------
% Other Parameters
%--------------------------------------------
ShimVals = cell(1,9);
ShimVals{1} = DATA.MrProt.sGRADSPEC.asGPAData{1}.lOffsetX;
ShimVals{2} = DATA.MrProt.sGRADSPEC.asGPAData{1}.lOffsetY;
ShimVals{3} = DATA.MrProt.sGRADSPEC.asGPAData{1}.lOffsetZ;
ShimVals0 = [];
if isfield(DATA.MrProt.sGRADSPEC,'alShimCurrent')
    ShimVals0 = DATA.MrProt.sGRADSPEC.alShimCurrent;
end
ShimVals(4:3+length(ShimVals0)) = ShimVals0;
Freq = DATA.MrProt.sTXSPEC.asNucleusInfo{1}.lFrequency;
Ref = DATA.MrProt.sProtConsistencyInfo.flNominalB0 * 42577000;
tof = Freq - Ref;
ShimVals(9) = {tof};
ShimNames = {'x','y','z','z2','zx','zy','x2y2','xy','tof'};
ShimMrProt = cell2struct(ShimVals.',ShimNames.',1);

% ShimValsUI{1} = ShimVals{1}/6.259;
% ShimValsUI{2} = ShimVals{2}/6.2465;
% ShimValsUI{3} = ShimVals{3}/6.108;
% ShimValsUI{4} = ShimVals{4}/2.016;
% ShimValsUI{5} = ShimVals{5}/2.815;
% ShimValsUI{6} = ShimVals{6}/2.853;
% ShimValsUI{7} = ShimVals{7}/2.815;
% ShimValsUI{8} = ShimVals{8}/2.866;
ShimValsUI{1} = ShimVals{1}/6.2587;
ShimValsUI{2} = ShimVals{2}/6.2463;
ShimValsUI{3} = ShimVals{3}/6.1081;
ShimValsUI{4} = ShimVals{4}/2.0146;
ShimValsUI{5} = ShimVals{5}/2.7273;
ShimValsUI{6} = ShimVals{6}/2.8389;
ShimValsUI{7} = ShimVals{7}/2.8049;
ShimValsUI{8} = ShimVals{8}/2.7928;
ShimValsUI{9} = ShimVals{9};

for n = 1:9
    if isempty(ShimValsUI{n})
        ShimValsUI{n} = 0;
    end
end
ShimUI = cell2struct(ShimValsUI.',ShimNames.',1);

%--------------------------------------------
% Return
%--------------------------------------------
FID.ShimMrProt = ShimMrProt;
FID.Shim = ShimUI;
FID.FIDmat = FIDmat;
FID.ExpPars = DATA.ExpPars;
FID.PanelOutput = DATA.PanelOutput;
FID.DCCOR = DCCOR;
FID.file = DATA.file;
FID.path = DATA.path;
FID.Seq = DATA.Seq;
FID.Protocol = DATA.Protocol;
FID = rmfield(FID,'DATA');

Status2('done','',2);
Status2('done','',3);


