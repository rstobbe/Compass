function init_fcn(doCuda,doPaths)

%-----------------------------------
% Local Paths
%-----------------------------------
curfolder = pwd;
ind = strfind(curfolder,'\');
softwarefolder = curfolder(1:ind(end)-1);
addpath(genpath(softwarefolder));
ind = strfind(softwarefolder,'\');
compassfolder = softwarefolder(1:ind(end));

%-----------------------------------
% General
%-----------------------------------
global COMPASSINFO
COMPASSINFO.CUDA = GraphicCard_Info(doCuda);
COMPASSINFO.USERGBL = User_Info;
COMPASSINFO.USERGBL.softwaredrive = compassfolder(1:3);
LOCS = ScriptPath_Info(compassfolder);
COMPASSINFO.LOCS = LOCS;
COMPASSINFO.CONSOLEGBL = Console_Info;

if not(isfield(COMPASSINFO.USERGBL,'trajdevloc'))
    COMPASSINFO.USERGBL.trajdevloc = COMPASSINFO.USERGBL.experimentsloc;
end
if not(isfield(COMPASSINFO.USERGBL,'trajreconloc'))
    COMPASSINFO.USERGBL.trajreconloc = [COMPASSINFO.USERGBL.softwaredrive,'3 ReconFiles\'];
end

%-----------------------------------
% RWSUI Global
%-----------------------------------
global RWSUIGBL
RWSUIGBL.errfunc = 'CompassErrDisp';
RWSUIGBL.statusfunc = 'CompassStatus2';
RWSUIGBL.status2func = 'CompassStatus2';
RWSUIGBL.outputfunc = 'CompassPanel';
RWSUIGBL.numwid = 10;
RWSUIGBL.editwid = 100;
RWSUIGBL.textwid = 205;
RWSUIGBL.fullwid = 49;
RWSUIGBL.Character = '';
RWSUIGBL.Key = '';
RWSUIGBL.AllTabs = {'Imaging','Imaging2','Imaging3','Imaging4','Script1','Script2','Script3','Script4'};
RWSUIGBL.TabArray = {'IM','IM2','IM3','IM4','ACC','ACC2','ACC3','ACC4'};

RWSUIGBL.ActiveScript.treepanipt = [0 0 0 0];
RWSUIGBL.ActiveScript.curpanipt = 0;
RWSUIGBL.ActiveScript.treecellarray = [0 0 0 0 0];
RWSUIGBL.ActiveScript.tab = '';
RWSUIGBL.ActiveScript.panelnum = 0; 

%-----------------------------------
% Set Paths
%-----------------------------------
if doPaths
    disp('Loading Paths');
    addpath(genpath(LOCS.defrootloc));
    addpath(genpath(LOCS.newhorizonsloc));
    addpath(genpath(LOCS.pioneerloc));
    addpath(genpath(LOCS.voyagerloc));
    addpath(genpath(LOCS.galileoloc));
    addpath(genpath(LOCS.apolloloc));
    addpath(genpath(LOCS.vikingloc));
    addpath(genpath(LOCS.scrptshareloc));
end

%-----------------------------------
% Software Globals
%-----------------------------------
global SCRPTPATHS
Tabs = {'ACC','ACC2','ACC3','ACC4'};
for tab = 1:length(Tabs)
    for n = 1:5
        SCRPTPATHS.(Tabs{tab})(n).loc = LOCS.scriptloc;
        SCRPTPATHS.(Tabs{tab})(n).rootloc = LOCS.scriptloc;
        SCRPTPATHS.(Tabs{tab})(n).defloc = LOCS.defloc;
        SCRPTPATHS.(Tabs{tab})(n).defrootloc = LOCS.defrootloc;
        SCRPTPATHS.(Tabs{tab})(n).pioneerloc = LOCS.pioneerloc;
        SCRPTPATHS.(Tabs{tab})(n).newhorizonsloc = LOCS.newhorizonsloc;
        SCRPTPATHS.(Tabs{tab})(n).voyagerloc = LOCS.voyagerloc;
        SCRPTPATHS.(Tabs{tab})(n).galileoloc = LOCS.galileoloc;
        SCRPTPATHS.(Tabs{tab})(n).apolloloc = LOCS.apolloloc;
        SCRPTPATHS.(Tabs{tab})(n).mercuryloc = LOCS.mercuryloc;
        SCRPTPATHS.(Tabs{tab})(n).vikingloc = LOCS.vikingloc;
        SCRPTPATHS.(Tabs{tab})(n).outloc = COMPASSINFO.USERGBL.trajdevloc;
        SCRPTPATHS.(Tabs{tab})(n).outrootloc = COMPASSINFO.USERGBL.trajdevloc;
        SCRPTPATHS.(Tabs{tab})(n).scrptshareloc = LOCS.scrptshareloc;
        SCRPTPATHS.(Tabs{tab})(n).experimentsloc = COMPASSINFO.USERGBL.experimentsloc;
        SCRPTPATHS.(Tabs{tab})(n).tempdataloc = COMPASSINFO.USERGBL.tempdataloc;
    end
end
Tabs = {'IM','IM2','IM3','IM4'};
for tab = 1:length(Tabs)
    for n = 1:4
        SCRPTPATHS.(Tabs{tab})(n).loc = LOCS.scriptloc;
        SCRPTPATHS.(Tabs{tab})(n).rootloc = LOCS.scriptloc;
        SCRPTPATHS.(Tabs{tab})(n).defloc = LOCS.defloc;
        SCRPTPATHS.(Tabs{tab})(n).defrootloc = LOCS.defrootloc;
        SCRPTPATHS.(Tabs{tab})(n).pioneerloc = LOCS.pioneerloc;
        SCRPTPATHS.(Tabs{tab})(n).newhorizonsloc = LOCS.newhorizonsloc;
        SCRPTPATHS.(Tabs{tab})(n).voyagerloc = LOCS.voyagerloc;
        SCRPTPATHS.(Tabs{tab})(n).galileoloc = LOCS.galileoloc;
        SCRPTPATHS.(Tabs{tab})(n).apolloloc = LOCS.apolloloc;
        SCRPTPATHS.(Tabs{tab})(n).mercuryloc = LOCS.mercuryloc;
        SCRPTPATHS.(Tabs{tab})(n).vikingloc = LOCS.vikingloc;
        SCRPTPATHS.(Tabs{tab})(n).outloc = COMPASSINFO.USERGBL.experimentsloc;
        SCRPTPATHS.(Tabs{tab})(n).outrootloc = COMPASSINFO.USERGBL.experimentsloc;
        SCRPTPATHS.(Tabs{tab})(n).scrptshareloc = LOCS.scrptshareloc;
        SCRPTPATHS.(Tabs{tab})(n).experimentsloc = COMPASSINFO.USERGBL.experimentsloc;
        SCRPTPATHS.(Tabs{tab})(n).roisloc = COMPASSINFO.USERGBL.experimentsloc;
        SCRPTPATHS.(Tabs{tab})(n).tempdataloc = COMPASSINFO.USERGBL.tempdataloc;
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



