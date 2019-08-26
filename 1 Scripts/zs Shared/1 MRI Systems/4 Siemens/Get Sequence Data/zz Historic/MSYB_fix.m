%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = LoadSiemensDataCur(SCRPTipt,SCRPTGBL)

INPUT.Extension = '.dat';
INPUT.CurFunc = 'LoadSiemensDataCur';
[SCRPTipt,SCRPTGBL,saveData,err] = SelectGeneralFileCur_v5(SCRPTipt,SCRPTGBL,INPUT);

if not(isempty(saveData))

    Status('busy','Load Siemens Data');
    Status2('done','',2);
    %---------------------------------------------
    % Load
    %---------------------------------------------    
    twix = mapVBVD(saveData.loc);
    fclose('all');
    if length(twix) == 2
        twix = twix{2};                         % 2nd 'image' is the relevant one if 'setup' performed as well
    end
    DataInfo = twix.image;  
    MrProt = twix.hdr.MeasYaps;
    FIDmat = twix.image{''}; 
    
    %---------------------------------------------
    % Rearrange
    %---------------------------------------------        
    sz = size(FIDmat);
    if DataInfo.NCha == 1 && length(sz) == 2
        FIDmat = permute(FIDmat,[2,1]);
    else
        FIDmat = permute(FIDmat,[3,1,4,2]);
    end
    
    %---------------------------------------------
    % Determine Sequence
    %---------------------------------------------
    Seq = MrProt.tSequenceFileName;
    if isempty(strfind(Seq,'"%CustomerSeq%\'))
        error
    end
    Seq = Seq(16:end-1);
    
    %---------------------------------------------
    % Stuff
    %---------------------------------------------
    Protocol = MrProt.tProtocolName;
    Protocol = Protocol(2:end-1);
    VolunteerID = twix.hdr.Config.Patient;
    
    %---------------------------------------------
    % Trajectory Set
    %---------------------------------------------
    if strcmp(Seq(1:4),'MSYB')                  % ...Old
        sWipMemBlock = MrProt.sWipMemBlock;
        test1 = sWipMemBlock.alFree;
        test2 = sWipMemBlock.adFree;
        if test1{3} == 10
            type = 'YB';
        end
        fov = num2str(test1{4});
        vox = num2str(round(10*test2{5}*test2{6}*test2{7}));
        elip = num2str(100);            
        tro = num2str(round(10*test2{8}));
        nproj = num2str(test1{9});
        p = num2str(test1{10});
        samptype = num2str(test1{11});
        usamp = num2str(100*test2{12});
        id = num2str(test1{13});
        TrajName = [type,'_F',fov,'_V',vox,'_E',elip,'_T',tro,'_N',nproj,'_P',p,'_S',samptype,usamp,'_ID',id];
        vox = num2str(round(10*test2{5}*test2{6}*test2{7}),'%04.0f');
        tro = num2str(round(10*test2{8}),'%03.0f');
        if test1{11} == 10
            samptype = 'U';
        end
        TrajImpName = ['IMP_F',fov,'_V',vox,'_E',elip,'_T',tro,'_N',nproj,'_S',samptype,usamp,'_ID',id];
    elseif  strcmp(Seq(1:4),'YUTE') || strcmp(Seq(1:3),'YWE') || strcmp(Seq(1:4),'YMTE')
        sWipMemBlock = MrProt.sWipMemBlock;
        test1 = sWipMemBlock.alFree;
        test2 = sWipMemBlock.adFree;
        if test1{3} == 10
            type = 'YB';
        end
        fov = num2str(test1{21});
        vox = num2str(round(test1{22}*test1{23}*test1{24}/1e8));
        elip = num2str(100);            
        tro = num2str(round(10*test2{5}));
        nproj = num2str(test1{6});
        p = num2str(test1{25});
        samptype = num2str(test1{26});
        usamp = num2str(100*test2{7});
        id = num2str(test1{27});
        TrajName = [type,'_F',fov,'_V',vox,'_E',elip,'_T',tro,'_N',nproj,'_P',p,'_S',samptype,usamp,'_ID',id];
        vox = num2str(round(10*test2{5}*test2{6}*test2{7}),'%04.0f');
        tro = num2str(round(10*test2{5}),'%03.0f');
        if test1{26} == 10
            samptype = 'U';
        end
        TrajImpName = ['IMP_F',fov,'_V',vox,'_E',elip,'_T',tro,'_N',nproj,'_S',samptype,usamp,'_ID',id];
    end

    %---------------------------------------------
    % Other Info
    %---------------------------------------------
    ExpPars.scantime = MrProt.lTotalScanTimeSec;
    ExpPars.Sequence.flip = MrProt.adFlipAngleDegree{1};             % in degrees
    ExpPars.Sequence.tr = MrProt.alTR{1}/1e3;                        % in ms
    ExpPars.Sequence.te = MrProt.alTE{1}/1e3;                        % in ms
    ExpPars.rcvrs = DataInfo.NCha;

    if isfield(MrProt.sAAInitialOffset,'SliceInformation');  
        SliceInformation = MrProt.sAAInitialOffset.SliceInformation;
        ExpPars.shift = zeros(1,3);
        if isfield(SliceInformation,'sPosition'); 
            if isfield(SliceInformation.sPosition,'dSag')
                ExpPars.shift(1) = SliceInformation.sPosition.dSag;
            else
                ExpPars.shift(1) = 0;
            end
            if isfield(SliceInformation.sPosition,'dCor')
                ExpPars.shift(3) = SliceInformation.sPosition.dCor;
            else
                ExpPars.shift(3) = 0;
            end
            if isfield(SliceInformation.sPosition,'dTra')
                ExpPars.shift(2) = SliceInformation.sPosition.dTra;
            else
                ExpPars.shift(2) = 0;
            end
        else
            ExpPars.shift(1) = 0;
            ExpPars.shift(3) = 0;
            ExpPars.shift(2) = 0; 
        end
    else
        ExpPars.shift(1) = 0;
        ExpPars.shift(3) = 0;
        ExpPars.shift(2) = 0; 
    end
    
    %--------------------------------------------
    % Panel
    %--------------------------------------------
    Panel(1,:) = {'','','Output'};
    Panel(2,:) = {'VolunteerID',['"',VolunteerID,'"'],'Output'};
    Panel(3,:) = {'Sequence',Seq,'Output'};
    Panel(4,:) = {'Protocol',Protocol,'Output'};
    Panel(5,:) = {'Trajectory',TrajName,'Output'};
    Panel(6,:) = {'Receivers',ExpPars.rcvrs,'Output'};
    Panel(7,:) = {'Scan Time (seconds)',ExpPars.scantime,'Output'};
    Panel(8,:) = {'TR (ms)',ExpPars.Sequence.tr,'Output'};
    Panel(9,:) = {'TE (ms)',ExpPars.Sequence.te,'Output'};
    Panel(10,:) = {'Flip (degrees)',ExpPars.Sequence.flip,'Output'};
    PanelOutput = cell2struct(Panel,{'label','value','type'},2);
    ExpDisp = PanelStruct2Text(PanelOutput);
    FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = ExpDisp;
    
    %--------------------------------------------
    % Save
    %--------------------------------------------
    SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.display = ExpDisp; 
    
    saveData.DataInfo = DataInfo;
    saveData.MrProt = MrProt;
    saveData.ExpPars = ExpPars;
    saveData.FIDmat = FIDmat;
    saveData.ExpDisp = ExpDisp;
    saveData.PanelOutput = PanelOutput;
    saveData.Seq = Seq;
    saveData.Protocol = Protocol;
    saveData.VolunteerID = VolunteerID;
    saveData.TrajName = TrajName;
    saveData.TrajImpName = TrajImpName;
    
    funclabel = SCRPTGBL.RWSUI.funclabel;
    callingfuncs = SCRPTGBL.RWSUI.callingfuncs;
    if isempty(callingfuncs)
        SCRPTGBL.([funclabel,'_Data']) = saveData;
    elseif length(callingfuncs) == 1
        SCRPTGBL.([callingfuncs{1},'_Data']).([funclabel,'_Data']) = saveData;
    elseif length(callingfuncs) == 2
        SCRPTGBL.([callingfuncs{1},'_Data']).([callingfuncs{2},'_Data']).([funclabel,'_Data']) = saveData;
    end
 
    Status('done','');
    Status2('done','',2);       
end
