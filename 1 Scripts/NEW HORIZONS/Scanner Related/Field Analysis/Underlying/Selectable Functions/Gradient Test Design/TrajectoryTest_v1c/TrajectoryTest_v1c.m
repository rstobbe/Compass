%=====================================================
% (v1c) 
%       
%=====================================================
function [SCRPTipt,SCRPTGBL,GTDES,err] = TrajectoryTest_v1c(SCRPTipt,SCRPTGBL,GTDESipt)

Status2('busy','Gradient Test Design',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

GTDES = struct();
CallingLabel = GTDESipt.Struct.labelstr;
%---------------------------------------------
% Tests
%---------------------------------------------
LoadAll = 0;
if not(isfield(GTDESipt,[CallingLabel,'_Data']))
    LoadAll = 1;
end
if LoadAll == 1 || not(isfield(GTDESipt.([CallingLabel,'_Data']),'Imp_File_Data'))
    if isfield(GTDESipt.('Imp_File').Struct,'selectedfile')
        file = GTDESipt.('Imp_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Imp_File';
            ErrDisp(err);
            return
        else
            Status2('busy','Load Implementation Data',2);
            load(file);
            saveData.path = file;
            GTDESipt.([CallingLabel,'_Data']).('Imp_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Imp_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Get Input
%---------------------------------------------
GTDES.method = GTDESipt.Func;
GTDES.numbgtests = str2double(GTDESipt.('NumBGtests'));
GTDES.numpltests = str2double(GTDESipt.('NumPLtests'));
GTDES.numwfmtests = str2double(GTDESipt.('NumWFMtests'));
GTDES.plgrad = str2double(GTDESipt.('PLGrad'));
GTDES.pregdur = str2double(GTDESipt.('PreGDur'));
GTDES.totgdur = str2double(GTDESipt.('TotGDur'));
GTDES.usetrajnum = GTDESipt.('UseTrajNum');
GTDES.usetrajdir = GTDESipt.('UseTrajDir');
GTDES.dir = GTDESipt.('Dir');
GTDES.IMP = GTDESipt.([CallingLabel,'_Data']).('Imp_File_Data').IMP;

%------------------------------------------
% Return
%------------------------------------------
SCRPTGBL.([CallingLabel,'_Data']).('Imp_File_Data') = GTDESipt.([CallingLabel,'_Data']).('Imp_File_Data');

