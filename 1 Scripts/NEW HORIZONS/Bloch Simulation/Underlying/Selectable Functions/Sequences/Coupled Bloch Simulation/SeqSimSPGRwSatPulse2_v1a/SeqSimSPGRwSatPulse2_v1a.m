%=========================================================
% (v1a) 
%       
%=========================================================

function [SCRPTipt,TMTSPGR,err] = SeqSimSPGRwSatPulse2_v1a(SCRPTipt,TMTSPGRipt)

Status2('busy','Simulate MT with SPGR sequence',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
TMTSPGR.script = TMTSPGRipt.Func;
TMTSPGR.satrffa = str2double(TMTSPGRipt.('SatRF_FA'));
TMTSPGR.satrfwoff = str2double(TMTSPGRipt.('SatRF_woff'));
TMTSPGR.satrftau = str2double(TMTSPGRipt.('SatRF_tau'));
TMTSPGR.exrffa = str2double(TMTSPGRipt.('ExRF_FA'));
TMTSPGR.exrfwoff = str2double(TMTSPGRipt.('ExRF_woff'));
TMTSPGR.exrftau = str2double(TMTSPGRipt.('ExRF_tau'));
TMTSPGR.Del = str2double(TMTSPGRipt.('Del'));
TMTSPGR.TR = str2double(TMTSPGRipt.('TR'));
TMTSPGR.TE = str2double(TMTSPGRipt.('TE'));
TMTSPGR.NSteady = str2double(TMTSPGRipt.('NSteady'));
TMTSPGR.SatPulseN = str2double(TMTSPGRipt.('SatPulseN'));
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