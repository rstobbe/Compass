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
twix = mapVBVD(FEVOL.('File'));
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
GradFile = ['SysTest_',type,num2str(test{4})];

%---------------------------------------------
% Make Sure 'SysTest_Imp' right
%---------------------------------------------
%TrajName = GradFile

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
Panel(1,:) = {'Flip Angle (degrees)',flip,'Output'};
Panel(2,:) = {'TR (seconds)',tr,'Output'};
Panel(3,:) = {'Averages',averages,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
FEVOL.PanelOutput = PanelOutput;
FEVOL.ExpDisp = PanelStruct2Text(FEVOL.PanelOutput);

Status2('done','',2);
Status2('done','',3);
