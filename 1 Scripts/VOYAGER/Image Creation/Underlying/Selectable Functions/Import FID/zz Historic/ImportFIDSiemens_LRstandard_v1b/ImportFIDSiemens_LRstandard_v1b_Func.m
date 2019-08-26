%=========================================================
%
%=========================================================

function [FID,err] = ImportFIDSiemens_LRstandard_v1b_Func(FID,INPUT)

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
% Test
%---------------------------------------------
if not(isfield(DATA,'FIDmat'))
    err.flag = 1;
    err.msg = 'Reload Data';
    return
end
%if isempty(strfind(DATA.TrajImpName,IMP.name));
%    err.flag = 1;
%    err.msg = 'Wrong ''Imp_File''';
%    return
%end
FIDmat = DATA.FIDmat;

%---------------------------------------------
% Test Initial Data Points
%---------------------------------------------
TestTraj = 1;
if strcmp(FID.visuals,'Yes');
    fh = figure(1000); clf;
    fh.Name = 'Data Testing';
    fh.NumberTitle = 'off';
    fh.Position = [400 150 1000 800];
    subplot(2,2,1); hold on;
    TestFid = squeeze(FIDmat(TestTraj,:,1,1));
    plot(real(TestFid),'r:'); plot(imag(TestFid),'b:'); plot(abs(TestFid),'k:');
    TestFid(1:KSMP.DiscardStart) = NaN + 1i*NaN;
    plot(real(TestFid),'r*'); plot(imag(TestFid),'b*'); plot(abs(TestFid),'k*');
    xlim([0 100]);
    xlabel('Sampling Points'); title('Sampling Discard Test');
end

%---------------------------------------------
% Drop Data Points
%---------------------------------------------
FIDmat = FIDmat(:,(KSMP.DiscardStart+1:end-KSMP.DiscardEnd),:,:);
sz = size(FIDmat);
if length(sz) == 2
    sz = [sz 1 1];
end
if sz(2) ~= KSMP.nproRecon;
    err.flag = 1;
    err.msg = 'Wrong ''Imp_File''';
    return
end

%---------------------------------------------
% Test For Steady-State Effect
%---------------------------------------------
if strcmp(FID.visuals,'Yes');
    figure(1000);
    subplot(2,2,2); hold on;
    TestFid = squeeze(FIDmat(:,1,1,1));
    plot(real(TestFid),'r:'); plot(imag(TestFid),'b:'); plot(abs(TestFid),'k:');
    plot([0 sz(1)],[0 0],'k:');
    xlim([0 sz(1)]); ylim(1.1*[-max(abs(TestFid)) max(abs(TestFid))]);
    xlabel('Trajectories'); title('Steady State Test');
end

%---------------------------------------------
% Drop Dummies
%---------------------------------------------
if sz(1) > PROJimp.nproj
    drop = sz(1) - PROJimp.nproj;
    FIDmat = FIDmat(drop+1:end,:,:,:);
    if strcmp(FID.visuals,'Yes');
        figure(1000);
        subplot(2,2,2); hold on;
        plot([drop drop],[-1 1],'k:');
    end
end

%---------------------------------------------
% Siemens Position Correction
%---------------------------------------------
shift = DATA.ExpPars.shift/1000;
shift(2) = -shift(2);
shift(3) = -shift(3);

%---------------------------------------------
% Phase Correct (FoV Shift)
%---------------------------------------------
Kmat = IMP.Kmat;
KArr = KMat2Arr(Kmat,IMP.PROJimp.nproj,IMP.PROJimp.npro);
for n = 1:sz(3)
    for m = 1:sz(4)
        FIDarr = DatMat2Arr(FIDmat(:,:,n,m),IMP.PROJimp.nproj,IMP.PROJimp.npro);
        FIDarr = FIDarr.*exp(-1i*2*pi*shift*KArr.').';
        FIDmat(:,:,n,m) = DatArr2Mat(FIDarr,IMP.PROJimp.nproj,IMP.PROJimp.npro);
    end
end

%---------------------------------------------
% Radial Evolution
%---------------------------------------------
if strcmp(FID.visuals,'Yes');
    figure(1000);
    subplot(2,2,3); hold on;
    TestFid = squeeze(FIDmat(TestTraj,:,1,1));
    plot(KSMP.rKmag,real(TestFid),'r'); plot(KSMP.rKmag,imag(TestFid),'b'); plot(KSMP.rKmag,abs(TestFid),'k');
    xlim([0 1]);
    xlabel('Relative k-Space'); title('Radial Evolution');
end

%--------------------------------------------
% DC correction
%--------------------------------------------
func = str2func([FID.dccorfunc,'_Func']);  
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
if strcmp(FID.visuals,'Yes');
    figure(1000);
    subplot(2,2,4); hold on;
    TestFid = squeeze(FIDmat(TestTraj,:,1,1));
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
Shim = cell2struct(ShimVals.',ShimNames.',1);

ShimValsUI{1} = ShimVals{1}/6.259;
ShimValsUI{2} = ShimVals{2}/6.2465;
ShimValsUI{3} = ShimVals{3}/6.108;
ShimValsUI{4} = ShimVals{4}/2.016;
ShimValsUI{5} = ShimVals{5}/2.815;
ShimValsUI{6} = ShimVals{6}/2.853;
ShimValsUI{7} = ShimVals{7}/2.815;
ShimValsUI{8} = ShimVals{8}/2.866;
ShimValsUI{9} = ShimVals{9};
ShimUI = cell2struct(ShimValsUI.',ShimNames.',1);

%--------------------------------------------
% Return
%--------------------------------------------
FID.Shim = Shim;
FID.ShimUI = ShimUI;
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


