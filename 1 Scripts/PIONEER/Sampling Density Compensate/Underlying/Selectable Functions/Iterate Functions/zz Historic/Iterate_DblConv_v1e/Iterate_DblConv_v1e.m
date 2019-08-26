%=========================================================
% (v1e)
%       - Update for function splitting
%=========================================================

function [SCRPTipt,IT,err] = Iterate_DblConv_v1e(SCRPTipt,ITipt)

Status2('busy','Get SDC Iteration Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

CallingPanel = ITipt.Struct.labelstr;
%---------------------------------------------
% Load Input
%---------------------------------------------
IT.Accfunc = ITipt.('Accfunc').Func;
IT.Anlzfunc = ITipt.('Anlzfunc').Func;
IT.Breakfunc = ITipt.('Breakfunc').Func;
IT.maxrelchange = str2double(ITipt.('MaxRelChange'));

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
ACCipt = ITipt.('Accfunc');
if isfield(ITipt,([CallingPanel,'_Data']))
    if isfield(ITipt.([CallingPanel,'_Data']),('Accfunc_Data'))
        ACCipt.('Accfunc_Data') = ITipt.([CallingPanel,'_Data']).('Accfunc_Data');
    end
end
ANLZipt = ITipt.('Anlzfunc');
if isfield(ITipt,([CallingPanel,'_Data']))
    if isfield(ITipt.([CallingPanel,'_Data']),('Anlzfunc_Data'))
        ANLZipt.('Anlzfunc_Data') = ITipt.([CallingPanel,'_Data']).('Anlzfunc_Data');
    end
end
BRKipt = ITipt.('Breakfunc');
if isfield(ITipt,([CallingPanel,'_Data']))
    if isfield(ITipt.([CallingPanel,'_Data']),('Breakfunc_Data'))
        BRKipt.('Breakfunc_Data') = ITipt.([CallingPanel,'_Data']).('Breakfunc_Data');
    end
end

%------------------------------------------
% Get Acceleration Info
%------------------------------------------
func = str2func(IT.Accfunc);           
[SCRPTipt,ACC,err] = func(SCRPTipt,ACCipt);
if err.flag
    return
end

%------------------------------------------
% Get Analyze Info
%------------------------------------------
func = str2func(IT.Anlzfunc);           
[SCRPTipt,ANLZ,err] = func(SCRPTipt,ANLZipt);
if err.flag
    return
end

%------------------------------------------
% Get Break Info
%------------------------------------------
func = str2func(IT.Breakfunc);           
[SCRPTipt,BRK,err] = func(SCRPTipt,BRKipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
IT.ACC = ACC;
IT.ANLZ = ANLZ;
IT.BRK = BRK;

Status2('done','',2);
Status2('done','',3);
