%=========================================================
% (v1a) 
%       
%=========================================================

function [SCRPTipt,TMTSPGR,err] = SeqSimSPGR_v1a(SCRPTipt,TMTSPGRipt)

Status2('busy','Simulate SPGR sequence (include MT)',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
TMTSPGR.script = TMTSPGRipt.Func;
TMTSPGR.exrffa = str2double(TMTSPGRipt.('ExRF_FA'));
TMTSPGR.exrfwoff = str2double(TMTSPGRipt.('ExRF_woff'));
TMTSPGR.exrftau = str2double(TMTSPGRipt.('ExRF_tau'));
TMTSPGR.TR = str2double(TMTSPGRipt.('TR'));
TMTSPGR.TE = str2double(TMTSPGRipt.('TE'));
TMTSPGR.NSteady = str2double(TMTSPGRipt.('NSteady'));
TMTSPGR.ExPulseN = str2double(TMTSPGRipt.('ExPulseN'));
TMTSPGR.RecN = str2double(TMTSPGRipt.('RecN'));
TMTSPGR.RecordSS = TMTSPGRipt.('RecordSS');
TMTSPGR.simfunc = TMTSPGRipt.('MTsimSPGRfunc').Func;

%---------------------------------------------
% Get Working Structures
%---------------------------------------------
CallingLabel = TMTSPGRipt.Struct.labelstr;
SIMipt = TMTSPGRipt.('MTsimSPGRfunc');
if isfield(TMTSPGRipt,([CallingLabel,'_Data']))
    if isfield(TMTSPGRipt.([CallingLabel,'_Data']),'MTsimSPGRfunc_Data')
        SIMipt.('MTsimSPGRfunc_Data') = TMTSPGRipt.([CallingLabel,'_Data']).('MTsimSPGRfunc_Data');
    end
end

%------------------------------------------
% Sim Function Info
%------------------------------------------
func = str2func(TMTSPGR.simfunc);           
[SCRPTipt,SIM,err] = func(SCRPTipt,SIMipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
TMTSPGR.SIM = SIM;


Status2('done','',2);
Status2('done','',3);