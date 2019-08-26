%=========================================================
% 
%=========================================================

function SelectDataFile(~,dataloc,N)

Status('busy','Select Data File');
Status2('done','',2);
Status2('done','',3);

global SCRPTGBL
global DATALOC
if isempty(DATALOC)
    DATALOC = dataloc;
end

[file,path] = uigetfile('*.*','Select Data File',DATALOC);
if path == 0
    Status('done','Data File Not Selected');
    return
end
DATALOC = path;
SCRPTGBL.outpath = [path,file];

file = strtok(file,'.');
SCRPTipt = LabelGet;
SCRPTipt(N).entrystr = file;
setfunc = 1;
DispScriptParam(SCRPTipt,setfunc);

Status('done','Data File Selected');


