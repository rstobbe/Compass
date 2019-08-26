%=========================================================
% 
%=========================================================

function [TMTSPGR,err] = SeqSimSPGR_v1a_Func(TMTSPGR,INPUT)

Status2('busy','Simulate SPGR sequence (include MT)',2);
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
SeqPrms.exrffa = TMTSPGR.exrffa;
SeqPrms.exrfwoff = TMTSPGR.exrfwoff;
SeqPrms.exrftau = TMTSPGR.exrftau;
SeqPrms.TR = TMTSPGR.TR;
SeqPrms.NSteady = TMTSPGR.NSteady;
SeqPrms.TE = TMTSPGR.TE;

%---------------------------------------------
% Sim Parameters
%---------------------------------------------
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
Panel(1,:) = {'Excitation Flip',SeqPrms.exrffa,'Output'};
Panel(2,:) = {'Excitation Off-Res',SeqPrms.exrfwoff,'Output'};
Panel(3,:) = {'Excitation Pulse-Len',SeqPrms.exrftau,'Output'};
Panel(4,:) = {'TR',SeqPrms.TR,'Output'};
Panel(5,:) = {'NSteady',SeqPrms.NSteady,'Output'};
Panel(6,:) = {'TE',SeqPrms.TE,'Output'};
TMTSPGR.PanelOutput = cell2struct(Panel,{'label','value','type'},2);

