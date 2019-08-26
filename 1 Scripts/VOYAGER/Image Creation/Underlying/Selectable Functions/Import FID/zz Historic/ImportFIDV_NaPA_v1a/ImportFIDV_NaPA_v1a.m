%=========================================================
% (v1a)
%
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = ImportFIDV_NaPA_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Load FID');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

CallingLabel = 'ImportFIDfunc';
if not(isfield(SCRPTGBL.CurrentTree,CallingLabel))
    err.flag = 1;
    err.msg = ['Calling label must be: ''',CallingLabel,''''];
    ErrDisp(err);
    return
end
if not(isfield(SCRPTGBL,[CallingLabel,'_Data']))
    err.flag = 1;
    err.msg = '(Re) Select FID path';
    ErrDisp(err);
    return
end
if not(isfield(SCRPTGBL.([CallingLabel,'_Data']),'FIDpath_Data'))
    err.flag = 1;
    err.msg = '(Re) Select FID path';
    ErrDisp(err);
    return
end
if not(isfield(SCRPTGBL,'FID'))
    err.flag = 1;
    err.msg = '''FID'' struct must be loaded into ''SCRPTGBL''';
    ErrDisp(err);
    return
end

%---------------------------------------------
% Load FID
%---------------------------------------------
FIDpath = SCRPTGBL.([CallingLabel,'_Data']).('FIDpath_Data').path;
[FIDmat] = ImportExpArrayFIDmatV_v1a([FIDpath,'\fid']);

%--------------------------------------------
% Return
%--------------------------------------------
SCRPTGBL.FID.origFIDmat = FIDmat;
SCRPTGBL.FID.FIDpath = FIDpath;
Status('done','');



