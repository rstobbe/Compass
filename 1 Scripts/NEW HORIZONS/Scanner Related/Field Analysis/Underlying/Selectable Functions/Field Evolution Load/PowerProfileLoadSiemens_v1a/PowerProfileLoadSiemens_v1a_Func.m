%====================================================
%           
%====================================================

function [FEVOL,err] = PowerProfileLoadSiemens_v1a_Func(FEVOL,INPUT)

Status2('busy','Load Siemens Data',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
IMP = FEVOL.SysTest.IMP;
GWFM = IMP.GWFM;
PROJimp = IMP.PROJimp;
AcqName = IMP.name;
clear INPUT

%---------------------------------------------
% Load Data
%---------------------------------------------
twix = mapVBVD(FEVOL.('File').loc);
fclose('all');
twix = twix{2};                         % 2nd 'image' is the relevant one - first is setup stuff
DataInfo = twix.image;
Hdr = twix.hdr;
MrProt = Hdr.MeasYaps;
Data = twix.image{''};                  

%---------------------------------------------
% Other Info
%---------------------------------------------
flip = MrProt.adFlipAngleDegree{1};             % in degrees
tr = MrProt.alTR{1}/1e6;                        % in seconds
flamplitude = MrProt.sTXSPEC.aRFPULSE{1}.flAmplitude;

%---------------------------------------------
% Determine Gradient File
%---------------------------------------------
sWipMemBlock = MrProt.sWipMemBlock;
test = sWipMemBlock.alFree;
if test{3} == 20
    type = 'BP';
elseif test{3} == 21
    type = 'PC';
elseif test{3} == 10
    type = 'TJ';
end
switch test{5}
    case 1
       dir = 'X';
    case 2
       dir = 'Y';
    case 3
       dir = 'Z';
end
rfpulselen = test{31};

GradImpName = ['IMP_',type,num2str(test{4}),dir];
GradFile = ['SysTest_',type,num2str(test{4})];
GradName = [type,num2str(test{4}),dir];

%---------------------------------------------
% Make Sure 'SysTest_Imp' right
%---------------------------------------------
if not(strcmp(AcqName,GradImpName))
    err.flag = 1;
    err.msg = ['''SysTest_Imp'' should be ',GradImpName{1}];
    return
end

%---------------------------------------------
% Determine Sequence
%---------------------------------------------
Phoenix = twix.hdr.Phoenix;                 % seems to have the most info neatly organized
MrProt = Phoenix;
Seq = MrProt.tSequenceFileName;
Seq = char(Seq);
if ~contains(Seq,'%CustomerSeq%\')
    SeqFound = Seq
    error
end
Seq = Seq(15:end);

%---------------------------------------------
% Stuff
%---------------------------------------------
Protocol = MrProt.tProtocolName;
Protocol = char(Protocol);
Protocol = Protocol(1:end);
if strcmp(twix.hdr.Config.PatientName(1:2),'xx')
    StudyId = twix.hdr.Config.Patient;
else 
    StudyId = twix.hdr.Config.PatientName;
end 

%---------------------------------------------
% PL
%---------------------------------------------
tData = Data;
tPC_Fid = tData(:,GWFM.aves == 1,:);
PC_Fid = permute(double(reshape(tPC_Fid,DataInfo.NCol,[])),[2 1]);
PC_Params.dwell = PROJimp.dwell;
PC_Params.np = DataInfo.NCol;
PC_Params.gval = GWFM.readgrad;
PC_Params.graddir = GWFM.dir;

%---------------------------------------------
% Return
%---------------------------------------------
FEVOL.PC_Fid = PC_Fid;
FEVOL.PC_Params = PC_Params;
FEVOL.flamplitude = flamplitude;
FEVOL.rfpulselen = rfpulselen;
FEVOL.flip = flip;
FEVOL.tr = tr;
FEVOL.DataInfo = DataInfo;
FEVOL.MrProt = MrProt;
FEVOL.GradFile = GradFile;

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'StudyId',['"',StudyId,'"'],'Output'};
Panel(3,:) = {'Protocol',Protocol,'Output'};
Panel(4,:) = {'Sequence',Seq,'Output'};
Panel(5,:) = {'Path',FEVOL.path,'Output'};
Panel(6,:) = {'File',FEVOL.File.name,'Output'};
Panel(7,:) = {'GradFile',GradFile,'Output'};
Panel(8,:) = {'GradDir',dir,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
FEVOL.PanelOutput = PanelOutput;
FEVOL.ExpDisp = PanelStruct2Text(FEVOL.PanelOutput);

Status2('done','',2);
Status2('done','',3);
