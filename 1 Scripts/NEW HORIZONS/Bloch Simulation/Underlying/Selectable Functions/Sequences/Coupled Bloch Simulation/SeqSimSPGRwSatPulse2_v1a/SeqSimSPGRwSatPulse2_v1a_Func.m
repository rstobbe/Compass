%=========================================================
% 
%=========================================================

function [TMTSPGR,err] = SeqSimSPGRwSatPulse2_v1a_Func(TMTSPGR,INPUT)

Status2('busy','SPGR Simulation',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
NMRPrms = INPUT.NMRPrms;
SIM = TMTSPGR.SIM;
clear INPUT

%---------------------------------------------
% Seq Parameters
%---------------------------------------------
SeqPrms.satrffa = TMTSPGR.satrffa;
SeqPrms.satrfwoff = TMTSPGR.satrfwoff;
SeqPrms.satrftau = TMTSPGR.satrftau;
SeqPrms.exrffa = TMTSPGR.exrffa;
SeqPrms.exrfwoff = TMTSPGR.exrfwoff;
SeqPrms.exrftau = TMTSPGR.exrftau;
SeqPrms.Del = TMTSPGR.Del;
SeqPrms.TR = TMTSPGR.TR;
SeqPrms.NSteady = TMTSPGR.NSteady;
SeqPrms.TE = TMTSPGR.TE;

%---------------------------------------------
% Sim Parameters
%---------------------------------------------
SimPrms.SatPulseN = TMTSPGR.SatPulseN;
SimPrms.ExPulseN = TMTSPGR.ExPulseN;
SimPrms.RecN = TMTSPGR.RecN;
SimPrms.RecordSS = TMTSPGR.RecordSS;

%---------------------------------------------
% Simulate
%---------------------------------------------
func = str2func([TMTSPGR.simfunc,'_Func']);  
INPUT.NMRPrms = NMRPrms;
INPUT.SeqPrms = SeqPrms;
INPUT.SimPrms = SimPrms;
[SIM,err] = func(SIM,INPUT);
if err.flag
    return
end

%---------------------------------------------
% Output
%---------------------------------------------
TMTSPGR.T = SIM.T;
TMTSPGR.Marr = SIM.Marr;
TMTSPGR.TLast = SIM.TLast;
TMTSPGR.MarrLast = SIM.MarrLast;
TMTSPGR.Mxy = SIM.Mxy;
TMTSPGR.SeqPrms = SeqPrms;

%--------------------------------------------
% Panel
%--------------------------------------------
Panel(1,:) = {'Saturation Flip',SeqPrms.satrffa,'Output'};
Panel(2,:) = {'Saturation Off-Res',SeqPrms.satrfwoff,'Output'};
Panel(3,:) = {'Saturation Pulse-Len',SeqPrms.satrftau,'Output'};
Panel(4,:) = {'Excitation Flip',SeqPrms.exrffa,'Output'};
Panel(5,:) = {'Excitation Off-Res',SeqPrms.exrfwoff,'Output'};
Panel(6,:) = {'Excitation Pulse-Len',SeqPrms.exrftau,'Output'};
Panel(7,:) = {'Del',SeqPrms.Del,'Output'};
Panel(8,:) = {'TR',SeqPrms.TR,'Output'};
Panel(9,:) = {'NSteady',SeqPrms.NSteady,'Output'};
Panel(10,:) = {'TE',SeqPrms.TE,'Output'};
TMTSPGR.PanelOutput = cell2struct(Panel,{'label','value','type'},2);

