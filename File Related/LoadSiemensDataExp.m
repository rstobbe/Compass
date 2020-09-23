%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = LoadSiemensDataExp(SCRPTipt,SCRPTGBL,saveData)

global FIGOBJS
err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load
%---------------------------------------------    
Status('busy','Load Siemens Data');
Status2('done','',2);
Status2('done','',3);

twix = mapVBVD(saveData.loc);
fclose('all');
if length(twix) == 2
    twix = twix{2};                         % 2nd 'image' is the relevant one if 'setup' performed as well
elseif length(twix) == 3
    twix = twix{3};                         % don't know why there would be 3 images
end
DataInfo = twix.image;
%hdr = twix.hdr
%Dicom = twix.hdr.Dicom
%Config = twix.hdr.Config
%Spice = twix.hdr.Spice
%MeasYaps = twix.hdr.MeasYaps
%Meas = twix.hdr.Meas                       % if needed all MrProt parameters in an array
Phoenix = twix.hdr.Phoenix;                 % seems to have the most info neatly organized
MrProt = Phoenix;

%---------------------------------------------
% Rearrange
%---------------------------------------------        
%FIDmat = twix.image{''};                   % bad - squeezes the data
FIDmat = twix.image(); 
sz0 = size(FIDmat);
if length(sz0) == 3
    FIDmat = permute(FIDmat,[3,1,4,2]);                  % 4 is a 'dummy'
elseif length(sz0) == 6
    FIDmat = permute(FIDmat,[3,1,4,2,6,5]);              % 4&5 aren't used and should be 'ones'
elseif length(sz0) == 10
    FIDmat = permute(FIDmat,[3,1,10,2,6,4,5,7,8,9]);     % 4,5,7,8,9 aren't used and should be 'ones'
end
sz = size(FIDmat);

%---------------------------------------------
% Determine Sequence
%---------------------------------------------
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
    VolunteerID = twix.hdr.Config.Patient;
else 
    VolunteerID = twix.hdr.Config.PatientName;
end 
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'VolunteerID',['"',VolunteerID,'"'],'Output'};
Panel(3,:) = {'Protocol',Protocol,'Output'};
Panel(4,:) = {'Sequence',Seq,'Output'};
Panel(5,:) = {'File',saveData.file,'Output'};
PanelOutput0 = cell2struct(Panel,{'label','value','type'},2);

%---------------------------------------------
% Trajectory Set
%---------------------------------------------
func = str2func([Seq,'_SeqDat']);
[ExpPars,PanelOutput,err] = func(MrProt,DataInfo);
PanelOutput = [PanelOutput0;PanelOutput];
ExpDisp = PanelStruct2Text(PanelOutput);
FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = ExpDisp;

%--------------------------------------------
% Save
%--------------------------------------------
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.display = ExpDisp; 

saveData.MrProt = MrProt;
saveData.ExpPars = ExpPars;
saveData.FIDmat = FIDmat;
clear FIDmat
saveData.ExpDisp = ExpDisp;
saveData.PanelOutput = PanelOutput;
saveData.Seq = Seq;
saveData.Protocol = Protocol;
saveData.VolunteerID = VolunteerID;
saveData.TrajName = ExpPars.TrajName;
saveData.TrajImpName = ExpPars.TrajImpName;

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

