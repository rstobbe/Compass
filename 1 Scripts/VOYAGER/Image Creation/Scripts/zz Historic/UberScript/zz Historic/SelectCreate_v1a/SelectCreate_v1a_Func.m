%====================================================
%  
%====================================================

function [IMG,err] = SelectCreate_v1a_Func(INPUT,IMG)

global TOTALGBL

Status('busy','Create Image');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
FIDpath = INPUT.FID.path;
RWSUI = INPUT.RWSUI;
CellArray = INPUT.CellArray;
clear INPUT;

%---------------------------------------------
% For now use seqfil
%---------------------------------------------
ExpPars = readprocpar(FIDpath);
func = str2func([ExpPars.seqfil,'_Def']);
Def = func();

%---------------------------------------------
% Create Structure
%---------------------------------------------
AutoRecon.AutoRecon = 'yes';
AutoRecon.AutoSave = 'yes';
AutoRecon.SaveName = ExpPars.seqfil;
AutoRecon.FIDpath = FIDpath;

%---------------------------------------------
% Write FID path to Default
%---------------------------------------------
RWSUI.SaveGlobal = 'yes';
RWSUI.SaveGlobalNames = 'AutoRecon';
RWSUI.SaveVariables = {AutoRecon};
Save_Global(RWSUI,CellArray);

%---------------------------------------------
% Run Image Construction Default 
%---------------------------------------------
panelnum = 1;
panel = 'des';
scrptnum = 1;
ExtRunScrptDefault(panelnum,panel,scrptnum,Def.imconfile,Def.imconpath);

%---------------------------------------------
% Delete AutoRecon Global
%---------------------------------------------
val = length(TOTALGBL(1,:));
val = val-1;
TOTALGBL = [TOTALGBL(:,1:val-1) TOTALGBL(:,val+1:length(TOTALGBL(1,:)))];
set(findobj('tag','totalgbl'),'value',length(TOTALGBL(1,:)));
set(findobj('tag','totalgbl'),'string',TOTALGBL(1,:));
drawnow;        

%---------------------------------------------
% Add Image Construction Default 
%---------------------------------------------
% - based on FID data load defaults for image creation and run them...
% - write name of FID file to global (to be retreived by create image...)

Status('done','');
Status2('done','',2);
Status2('done','',3);

