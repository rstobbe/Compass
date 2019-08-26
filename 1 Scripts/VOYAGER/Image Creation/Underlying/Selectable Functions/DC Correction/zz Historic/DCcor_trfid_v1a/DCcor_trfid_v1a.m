%=====================================================
% (v1a)
%
%=====================================================

function [SCRPTipt,SCRPTGBL,err] = DCcor_trfid_v1a(SCRPTipt,SCRPTGBL)

Status('busy','DC correct FID');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

CallingLabel = 'DCcorfunc';
if not(isfield(SCRPTGBL.CurrentTree,CallingLabel))
    err.flag = 1;
    err.msg = ['Calling label must be: ''',CallingLabel,''''];
    ErrDisp(err);
    return
end
if not(isfield(SCRPTGBL,'FID'))
    err.flag = 1;
    err.msg = '''FID'' struct must be loaded into ''SCRPTGBL''';
    ErrDisp(err);
    return
end
if not(isfield(SCRPTGBL.FID,'FIDmat'))
    err.flag = 1;
    err.msg = '''FID'' struct must contain ''FIDmat''';
    ErrDisp(err);
    return
end

trfidper = str2double(SCRPTGBL.CurrentTree.(CallingLabel).trfid);

%---------------------------------------------
% DC correct from trailing FID values
%---------------------------------------------
Dat = SCRPTGBL.FID.FIDmat;
np = length(Dat(1,:));
trfidpts = round(trfidper*np*0.01);

DatSum = mean(Dat,1);
DCcor = mean(DatSum(np-trfidpts+1:np));    
Dat = Dat - DCcor;

%---------------------------------------------
% Return
%---------------------------------------------
SCRPTGBL.FID.dccorFIDmat = Dat;
SCRPTGBL.FID.dccorval = DCcor;
Status('done','');




