%====================================================
%           
%====================================================

function [FEVOL,err] = FieldEvoLoadSiemens_v1a_Func(FEVOL,INPUT)

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

fclose('all');
%file = FEVOL.('File_Pos1');
%fid = fopen(file);
%prot = read_twix_hdr(fid);
%headers = ReadRawHeaders(file)

for n = 1:2
    %---------------------------------------------
    % Load Data
    %---------------------------------------------
    twix = mapVBVD(FEVOL.(['File_Pos',num2str(n)]).loc);
    twix = twix{2};                         % 2nd 'image' is the relevant one - first is setup stuff
    DataInfo = twix.image;
    Hdr = twix.hdr;
    MrProt = Hdr.MeasYaps;
    Data{n} = twix.image{''};                  

    %---------------------------------------------
    % Other Info
    %---------------------------------------------
    flip(n) = MrProt.adFlipAngleDegree{1};             % in degrees
    tr(n) = MrProt.alTR{1}/1e6;                        % in seconds
    averages(n) = DataInfo.NAve;
    
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
    GradImpName{n} = ['IMP_',type,num2str(test{4}),dir];
    GradFile{n} = ['SysTest_',type,num2str(test{4}),dir];
    GradName{n} = [type,num2str(test{4}),dir];
    
    %---------------------------------------------
    % Determine In/Out
    %---------------------------------------------
    %switch test{8}         % 2015
    switch test{13}
        case 1
           loc{n} = 'Left';
        case 2
           loc{n} = 'Right';
        case 3
           loc{n} = 'Up';
        case 4
           loc{n} = 'Down';
        case 5
           loc{n} = 'In';
        case 6
           loc{n} = 'Out';
    end    
end

%---------------------------------------------
% Compare
%---------------------------------------------
if not(strcmp(GradFile{1},GradFile{2}))
    err.flag = 1;
    err.msg = 'Not the Same Gradient File';
    return
end

if not(strcmp(AcqName,GradImpName{1}))
    err.flag = 1;
    err.msg = ['''SysTest_Imp'' should be ',GradImpName{1}];
    return
end

if flip(1) ~= flip(2) || tr(1) ~= tr(2) || averages(1) ~= averages(2)
    err.flag = 1;
    err.msg = 'Files from different sequences';
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
for n = 1:2
    tData = Data{n};
    tBG_Fid = tData(:,GWFM.aves == 0,:);
    BG_Fid{n} = permute(double(reshape(tBG_Fid,DataInfo.NCol,[])),[2 1]);
end
BG_Params.dwell = PROJimp.dwell;
BG_Params.np = DataInfo.NCol;

%---------------------------------------------
% PL
%---------------------------------------------
for n = 1:2
    tData = Data{n};
    test = size(tData)
    tPL_Fid = tData(:,GWFM.aves == 1,:);
    PL_Fid{n} = permute(double(reshape(tPL_Fid,DataInfo.NCol,[])),[2 1]);
end
PL_Params.dwell = PROJimp.dwell;
PL_Params.np = DataInfo.NCol;
PL_Params.gval = GWFM.plgrad;
PL_Params.graddir = GWFM.dir;

%---------------------------------------------
% TF
%---------------------------------------------
for n = 1:2
    for m = 2:max(GWFM.aves)
        tData = Data{n};
        tTF_Fid = tData(:,GWFM.aves == m,:);
        tTF_Fid2(:,:,m-1) = permute(double(reshape(tTF_Fid,DataInfo.NCol,[])),[2 1]);
    end
    TF_Fid{n} = tTF_Fid2;
end
TF_Params.dwell = PROJimp.dwell;
TF_Params.np = DataInfo.NCol;
TF_Params.gval = GWFM.gval;
TF_Params.pnum = GWFM.pnum;
TF_Params.graddir = GWFM.dir;

%---------------------------------------------
% Return
%---------------------------------------------
FEVOL.BG_Fid1 = BG_Fid{1};
FEVOL.BG_Fid2 = BG_Fid{2};
FEVOL.BG_Params = BG_Params;
FEVOL.PL_Fid1 = PL_Fid{1};
FEVOL.PL_Fid2 = PL_Fid{2};
FEVOL.PL_Params = PL_Params;
FEVOL.TF_Fid1 = TF_Fid{1};
FEVOL.TF_Fid2 = TF_Fid{2};
FEVOL.TF_Params = TF_Params;
FEVOL.DataInfo = DataInfo;
FEVOL.MrProt = MrProt;
FEVOL.GradFile = GradName{1};

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'StudyId',['"',StudyId,'"'],'Output'};
Panel(3,:) = {'Protocol',Protocol,'Output'};
Panel(4,:) = {'Sequence',Seq,'Output'};
Panel(5,:) = {'Path',FEVOL.path,'Output'};
Panel(6,:) = {'File1',FEVOL.File_Pos1.name,'Output'};
Panel(7,:) = {'File2',FEVOL.File_Pos2.name,'Output'};
Panel(8,:) = {'GradFile',GradFile{1},'Output'};
Panel(9,:) = {'GradDir',dir,'Output'};
Panel(10,:) = {'ProbePos',[loc{1},'-',loc{2}],'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
FEVOL.PanelOutput = PanelOutput;
FEVOL.ExpDisp = PanelStruct2Text(FEVOL.PanelOutput);

Status2('done','',2);
Status2('done','',3);
