%=====================================================
% (v2b)
%       - function splitting   
%=====================================================

function [SCRPTipt,GQNT,err] = QVecSlv_TPI_v2b(SCRPTipt,GQNTipt)

Status2('busy','Get Gradient Waveform Quantization Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
GQNT.method = GQNTipt.Func;
GQNT.destwseg = str2double(GQNTipt.('twGseg'));
GQNT.slvprior1 = GQNTipt.('Solve_Priority1');
GQNT.slvprior2 = GQNTipt.('Solve_Priority2');
GQNT.QVecfunc = GQNTipt.('QVecfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
CallingFunction = GQNTipt.Struct.labelstr;
QVECipt = GQNTipt.('QVecfunc');
if isfield(GQNT,([CallingFunction,'_Data']))
    if isfield(GQNT.([CallingFunction,'_Data']),('QVecfunc_Data'))
        QVECipt.QVecfunc_Data = GQNTipt.([CallingFunction,'_Data']).QVecfunc_Data;
    end
end

%------------------------------------------
% Get Quantization Vector Function Info
%------------------------------------------
func = str2func(GQNT.QVecfunc);           
[SCRPTipt,QVEC,err] = func(SCRPTipt,QVECipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
GQNT.QVEC = QVEC;

Status2('done','',2);
Status2('done','',3);