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
GWFM = FEVOL.SysTest.IMP.GWFM;
PROJimp = FEVOL.SysTest.IMP.PROJimp;
clear INPUT

for n = 1:2
    %---------------------------------------------
    % Load Data
    %---------------------------------------------
    twix = mapVBVD(FEVOL.(['File_Pos',num2str(n)]));
    twix = twix{2};                         % 2nd 'image' is the relevant one - first is setup stuff
    DataInfo = twix.image;
    Hdr = twix.hdr;
    MrProt = Hdr.MeasYaps;
    Data{n} = twix.image{''};                  

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
    GradFile{n} = ['SysTest_',type,num2str(test{4})];

    %---------------------------------------------
    % Determine In/Out
    %---------------------------------------------

end
if not(strcmp(GradFile{1},GradFile{2}))
    err.flag = 1;
    err.msg = 'Not the Same Gradient File';
    return
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
    tPL_Fid = tData(:,GWFM.aves == 1,:);
    PL_Fid{n} = permute(double(reshape(tPL_Fid,DataInfo.NCol,[])),[2 1]);
end
PL_Params.dwell = PROJimp.dwell;
PL_Params.np = DataInfo.NCol;
PL_Params.gval = GWFM.plgrad;

%---------------------------------------------
% TF
%---------------------------------------------
for n = 1:2
    tData = Data{n};
    tTF_Fid = tData(:,GWFM.aves == 2,:);
    TF_Fid{n} = permute(double(reshape(tTF_Fid,DataInfo.NCol,[])),[2 1]);
end
TF_Params.dwell = PROJimp.dwell;
TF_Params.np = DataInfo.NCol;
TF_Params.pnum = 1;
TF_Params.gval = 10;
TF_Params.graddir = 'Z';

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
FEVOL.GradFile = GradFile{1};

Status2('done','',2);
Status2('done','',3);
