function [Output,err] = CompassLoadScriptFile(CompassInput,Label)

CallingFunction = CompassInput.Struct.labelstr;
Present = 0;
if isfield(CompassInput,([CallingFunction,'_Data']))
    if isfield(CompassInput.([CallingFunction,'_Data']),([Label,'_Data']))
        Present = 1;
    end
end
if Present == 0
    if isfield(CompassInput.([Label,'_Data']).Struct,'selectedfile')
        file = CompassInput.([Label,'_Data']).Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = ['(Re) Load ',Label];
            ErrDisp(err);
            return
        else
            load(file);
            CompassInput.([CallingFunction,'_Data']).([Label,'_Data']) = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Dictionary_File';
        ErrDisp(err);
        return
    end
end
Output = CompassInput.([CallingFunction,'_Data']).([Label,'_Data']).SCRPT.DictObj;


