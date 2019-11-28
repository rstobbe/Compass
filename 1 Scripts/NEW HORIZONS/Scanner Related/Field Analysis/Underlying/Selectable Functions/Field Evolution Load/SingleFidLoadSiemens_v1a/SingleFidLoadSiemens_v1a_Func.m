%====================================================
%           
%====================================================

function [FEVOL,err] = SingleFidLoadSiemens_v1a_Func(FEVOL,INPUT)

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
averages = DataInfo.NAve;

%---------------------------------------------
% Determine Gradient File
%---------------------------------------------
sWipMemBlock = MrProt.sWipMemBlock;
test = sWipMemBlock.alFree;
if test{3} == 20
    type = 'BP';
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
% BG
%---------------------------------------------
tData = Data;
tBG_Fid = tData(:,GWFM.aves == 0,:);
BG_Fid = permute(double(reshape(tBG_Fid,DataInfo.NCol,[])),[2 1]);
BG_Params.dwell = PROJimp.dwell;
BG_Params.np = DataInfo.NCol;

%---------------------------------------------
% Return
%---------------------------------------------
FEVOL.BG_Fid1 = BG_Fid;
FEVOL.BG_Params = BG_Params;
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
Panel(6,:) = {'File1',FEVOL.File.name,'Output'};
Panel(7,:) = {'GradFile',GradFile,'Output'};
Panel(8,:) = {'GradDir',dir,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
FEVOL.PanelOutput = PanelOutput;
FEVOL.ExpDisp = PanelStruct2Text(FEVOL.PanelOutput);

Status2('done','',2);
Status2('done','',3);
