function [obj,err] = CompassSubFuncInit(CompassInput,Label)

Ipt = CompassInput.(Label);
CallingFunction = CompassInput.Struct.labelstr;
if isfield(CompassInput,([CallingFunction,'_Data']))
    if isfield(CompassInput.([CallingFunction,'_Data']),([Label,'_Data']))
        Ipt.TrajOrderfunc_Data = CompassInput.([CallingFunction,'_Data']).([Label,'_Data']);
    end
end
func = str2func(CompassInput.(Label).Func);                   
obj = func();
err = obj.InitViaCompass(Ipt);