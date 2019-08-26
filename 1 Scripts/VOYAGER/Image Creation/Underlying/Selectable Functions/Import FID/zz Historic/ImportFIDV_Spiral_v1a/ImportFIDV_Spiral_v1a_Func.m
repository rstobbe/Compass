%=========================================================
%
%=========================================================

function [FID,err] = ImportFIDV_PAgeneral_v1a_Func(FID,INPUT)

Status2('busy','Load FID',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMP = INPUT.IC.IMP;
DCCOR = FID.DCCOR;
clear INPUT;

%---------------------------------------------
% Build Structure to Test with AcqPars
%---------------------------------------------
ImpPars.fov = IMP.impPROJdgn.fov;
ImpPars.vox = IMP.impPROJdgn.vox;
ImpPars.elip = IMP.impPROJdgn.elip;
ImpPars.nproj = IMP.PROJimp.nproj;
ImpPars.tro = IMP.PROJimp.tro;
ImpPars.sampstart = round(IMP.PROJimp.sampstart*1000*1e9)/1e9;
ImpPars.dwell = round(IMP.PROJimp.dwell*1000*1e9)/1e9;
ImpPars.fb = IMP.TSMP.filtBW;

%---------------------------------------------
% Get Parameters
%---------------------------------------------
[Text,err] = Load_ParamsV_v1a([FID.path,'\params']);
if err.flag == 1
    return
end
[ProcPar,err] = Load_ProcparV_v1a([FID.path,'procpar']);
if err.flag == 1
    return
end

%---------------------------------------------
% Create Parameter Structure ('layout' based
%---------------------------------------------
% func = str2func('CreateParamStructV_NaGeneral_v1b');
% [ExpPars,err] = func(Text);
% if err.flag == 1;
%     return
% end
params = {'fov','vox','elip','nproj','tro','sampstart','dwell','fb'};
out = Parse_ProcparV_v1a(ProcPar,params);
AcqPars = cell2struct(out.',params.',1);
ExpPars = struct();

%---------------------------------------------
% Compare
%---------------------------------------------
[~,~,comperr] = comp_struct(ImpPars,AcqPars,'ImpPars','AcqPars');
if not(isempty(comperr))
    err.flag = 1;
    err.msg = 'Data Does Not Match ''Imp_File''';
    return
end

%-------------------------------------------
% Read Shim Values
%-------------------------------------------
params = {'z1c','z2c','z3c','z4c','x1','y1',...
          'xz','yz','xy','x2y2','x3','y3','xz2','yz2','zxy','zx2y2',...
          'tof'};
out = Parse_ProcparV_v1a(ProcPar,params);
Shim = cell2struct(out.',params.',1);

%-------------------------------------------
% Read Array Dim
%-------------------------------------------
params = {'arraydim','array'};
out = Parse_ProcparV_v1b(ProcPar,params);
ArrayDim = out{1};
ArrayText = out{2}{1};
%----
% finish
%----

%---------------------------------------------
% Load FID
%---------------------------------------------
split = IMP.SYS.split;
npro = IMP.PROJimp.npro;
nproj = IMP.PROJimp.nproj;

nblocks = 1;
projmult = 1;

FIDmat0 = zeros(projmult,npro,nblocks,split);
for n = 1:split
   temp = strtok(FID.path,'.');
   ptemp = [temp(1:length(temp)-2),num2str(str2double(temp(length(temp)-1:length(temp)))+(n-1),'%02d'),'.fid\fid'];
   [FIDmat0(:,:,:,n),FIDparams] = ImportSplitArrayFIDmatV_v1a(ptemp);
end
if FIDparams.np ~= npro || FIDparams.nblocks ~= nblocks || FIDparams.ntraces ~= projmult
    error;
end

%---------------------------------------------
% Update in Future...
%---------------------------------------------
nrcvrs = 1;

%---------------------------------------------
% Update in Future...
%---------------------------------------------
FIDmat = FIDmat0;
npro = length(FIDmat);

%---------------------------------------------
% Magnitude Test
%---------------------------------------------
if strcmp(FID.visuals,'Yes');
    figure(1001); hold on; 
    plot(mean(real(FIDmat),1),'r','linewidth',2); plot(mean(imag(FIDmat),1),'b','linewidth',2);
    plot([1 npro],[0 0],'k:'); xlim([1 npro/5]);
    xlabel('Initial Readout Points'); title('Magnitude Test (mean readout value)');
end

%--------------------------------------------
% DC correction
%--------------------------------------------
func = str2func([FID.dccorfunc,'_Func']);  
INPUT.FIDmat = FIDmat;
INPUT.nrcvrs = nrcvrs;
INPUT.visuals = FID.visuals;
[DCCOR,err] = func(DCCOR,INPUT);
if err.flag
    return
end
clear INPUT;
FIDmat = DCCOR.FIDmat;
DCCOR = rmfield(DCCOR,'FIDmat');

%---------------------------------------------
% Plot  (update for nrcvrs > 1)
%---------------------------------------------
% if strcmp(FID.visuals,'Yes');
%     clr = ['r','b','g','c','m'];
%         
%         figure(1002); hold on;
%         plot(abs(FIDmat(:,1,n)),clr(n));
%         title('First Data Point Magnitude Test');
%         xlabel('Trajectory Number');    
% 
%         figure(1003); hold on;
%         plot(angle(FIDmat(:,1,n)),clr(n));
%         title('First Data Point Phase Test');
%         xlabel('Trajectory Number'); 
% 
% end

%--------------------------------------------
% Image Params for Recon
%--------------------------------------------
ReconPars.Imfovx = AcqPars.fov;
ReconPars.Imfovy = AcqPars.fov;
ReconPars.Imfovz = AcqPars.fov;
%ReconPars.orp = ExpPars.Sequence.orp;

%--------------------------------------------
% Panel
%--------------------------------------------
Panel(1,:) = {'FID',FID.DatName,'Output'};
Panel(2,:) = {'',Text,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
FID.PanelOutput = PanelOutput;

%--------------------------------------------
% Return
%--------------------------------------------
FID.FIDmat = FIDmat.';
FID.ExpPars = ExpPars;
FID.ReconPars = ReconPars;
FID.Shim = Shim;
FID.DCCOR = DCCOR;


Status2('done','',2);
Status2('done','',3);


