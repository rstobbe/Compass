function InitFcn(softwarefolder,Setup)

%-----------------------------------
% Container Folder
%-----------------------------------
ind = strfind(softwarefolder,'\');
compassfolder = softwarefolder(1:ind(end));

%-----------------------------------
% General
%-----------------------------------
global COMPASSINFO
COMPASSINFO.USERGBL.epssave = 'No';
COMPASSINFO.USERGBL.setup = 'ImageAnalysis';
COMPASSINFO.USERGBL.experimentsloc = compassfolder;
COMPASSINFO.USERGBL.defloc = compassfolder;
COMPASSINFO.USERGBL.defrootloc = compassfolder;
COMPASSINFO.USERGBL.trajdevloc = compassfolder;
COMPASSINFO.USERGBL.tempdataloc = compassfolder;
COMPASSINFO.USERGBL.invfiltloc = compassfolder;
COMPASSINFO.USERGBL.imkernloc = compassfolder;
COMPASSINFO.USERGBL.sysresploc = compassfolder; 
if exist('CompassUserInfo','file')
    COMPASSINFO.USERGBL = CompassUserInfo(Setup);
end
if not(strcmp(COMPASSINFO.USERGBL.setup,'ImageAnalysis'))
    COMPASSINFO.CUDA = GraphicCard_Info(COMPASSINFO.USERGBL);
end
disp('Initialize Structures');
COMPASSINFO.USERGBL.softwaredrive = compassfolder(1:3);
LOCS = ScriptPath_Info([softwarefolder,'\']);
COMPASSINFO.LOCS = LOCS;

%-----------------------------------
% RWSUI Global
%-----------------------------------
global RWSUIGBL
RWSUIGBL.errfunc = 'CompassErrDisp';
RWSUIGBL.statusfunc = 'CompassStatus2';
RWSUIGBL.status2func = 'CompassStatus2';
RWSUIGBL.outputfunc = 'CompassPanel4K';
RWSUIGBL.numwid = 10;
RWSUIGBL.editwid = 0.4;
RWSUIGBL.textwid = 0.55;
RWSUIGBL.fullwid = 45;
RWSUIGBL.Character = '';
RWSUIGBL.Key = '';
RWSUIGBL.AllTabs = {'One Image','Two Images','Ortho','Four Images','Script1','Script2','Script3','Script4'};
if not(strcmp(COMPASSINFO.USERGBL.setup,'ImageAnalysis'))
    RWSUIGBL.TabArray = {'IM','IM2','IM3','IM4','ACC','ACC2','ACC3','ACC4'};
else
    RWSUIGBL.TabArray = {'IM2','IM3'};
end

RWSUIGBL.ActiveScript.treepanipt = [0 0 0 0];
RWSUIGBL.ActiveScript.curpanipt = 0;
RWSUIGBL.ActiveScript.treecellarray = [0 0 0 0 0];
RWSUIGBL.ActiveScript.tab = '';
RWSUIGBL.ActiveScript.panelnum = 0; 

%-----------------------------------
% Software Globals
%-----------------------------------
global SCRPTPATHS
Tabs = {'ACC','ACC2','ACC3','ACC4'};
for tab = 1:length(Tabs)
    for n = 1:5
        SCRPTPATHS.(Tabs{tab})(n).loc = LOCS.scriptloc;
        SCRPTPATHS.(Tabs{tab})(n).rootloc = LOCS.scriptloc;
        SCRPTPATHS.(Tabs{tab})(n).defloc = '';
        SCRPTPATHS.(Tabs{tab})(n).defrootloc = COMPASSINFO.USERGBL.lastdefloc;
        SCRPTPATHS.(Tabs{tab})(n).pioneerloc = LOCS.pioneerloc;
        SCRPTPATHS.(Tabs{tab})(n).newhorizonsloc = LOCS.newhorizonsloc;
        SCRPTPATHS.(Tabs{tab})(n).voyagerloc = LOCS.voyagerloc;
        SCRPTPATHS.(Tabs{tab})(n).galileoloc = LOCS.galileoloc;
        SCRPTPATHS.(Tabs{tab})(n).apolloloc = LOCS.apolloloc;
        SCRPTPATHS.(Tabs{tab})(n).mercuryloc = LOCS.mercuryloc;
        SCRPTPATHS.(Tabs{tab})(n).vikingloc = LOCS.vikingloc;
        SCRPTPATHS.(Tabs{tab})(n).outloc = '';
        SCRPTPATHS.(Tabs{tab})(n).outrootloc = COMPASSINFO.USERGBL.lastscriptloc;
        SCRPTPATHS.(Tabs{tab})(n).scrptshareloc = LOCS.scrptshareloc;
        SCRPTPATHS.(Tabs{tab})(n).experimentsloc = COMPASSINFO.USERGBL.experimentsloc;
        SCRPTPATHS.(Tabs{tab})(n).tempdataloc = COMPASSINFO.USERGBL.tempdataloc;
        SCRPTPATHS.(Tabs{tab})(n).invfiltloc = COMPASSINFO.USERGBL.invfiltloc;
        SCRPTPATHS.(Tabs{tab})(n).imkernloc = COMPASSINFO.USERGBL.imkernloc;
        SCRPTPATHS.(Tabs{tab})(n).sysresploc = COMPASSINFO.USERGBL.sysresploc;        
    end
end
Tabs = {'IM','IM2','IM3','IM4'};
for tab = 1:length(Tabs)
    for n = 1:4
        SCRPTPATHS.(Tabs{tab})(n).loc = LOCS.scriptloc;
        SCRPTPATHS.(Tabs{tab})(n).rootloc = LOCS.scriptloc;
        SCRPTPATHS.(Tabs{tab})(n).defloc = '';
        SCRPTPATHS.(Tabs{tab})(n).defrootloc = COMPASSINFO.USERGBL.lastdefloc;
        SCRPTPATHS.(Tabs{tab})(n).pioneerloc = LOCS.pioneerloc;
        SCRPTPATHS.(Tabs{tab})(n).newhorizonsloc = LOCS.newhorizonsloc;
        SCRPTPATHS.(Tabs{tab})(n).voyagerloc = LOCS.voyagerloc;
        SCRPTPATHS.(Tabs{tab})(n).galileoloc = LOCS.galileoloc;
        SCRPTPATHS.(Tabs{tab})(n).mercuryloc = LOCS.mercuryloc;
        SCRPTPATHS.(Tabs{tab})(n).apolloloc = LOCS.apolloloc;
        SCRPTPATHS.(Tabs{tab})(n).vikingloc = LOCS.vikingloc;
        SCRPTPATHS.(Tabs{tab})(n).outloc = '';
        SCRPTPATHS.(Tabs{tab})(n).outrootloc = COMPASSINFO.USERGBL.lastscriptloc;
        SCRPTPATHS.(Tabs{tab})(n).scrptshareloc = LOCS.scrptshareloc;
        SCRPTPATHS.(Tabs{tab})(n).experimentsloc = COMPASSINFO.USERGBL.experimentsloc;
        SCRPTPATHS.(Tabs{tab})(n).roisloc = COMPASSINFO.USERGBL.experimentsloc;
        SCRPTPATHS.(Tabs{tab})(n).tempdataloc = COMPASSINFO.USERGBL.tempdataloc;
        SCRPTPATHS.(Tabs{tab})(n).invfiltloc = COMPASSINFO.USERGBL.invfiltloc;
        SCRPTPATHS.(Tabs{tab})(n).imkernloc = COMPASSINFO.USERGBL.imkernloc;
        SCRPTPATHS.(Tabs{tab})(n).sysresploc = COMPASSINFO.USERGBL.sysresploc;        
    end
end

global SCRPTIPTGBL
Tabs = {'ACC','ACC2','ACC3','ACC4','IM','IM2','IM3','IM4'};
for tab = 1:length(Tabs)
    SCRPTIPTGBL.(Tabs{tab}).default = {};
end

global SCRPTGBL
Tabs = {'ACC','ACC2','ACC3','ACC4','IM','IM2','IM3','IM4'};
for tab = 1:length(Tabs)
    SCRPTGBL.(Tabs{tab}) = cell(5,5);
end

global DEFFILEGBL
cellarr = cell(5,10);
Tabs = {'ACC','ACC2','ACC3','ACC4','IM','IM2','IM3','IM4'};
for tab = 1:length(Tabs)
    DEFFILEGBL.(Tabs{tab}) = struct('file',cellarr);
end

global TOTALGBL
TOTALGBL = cell(2,0);



