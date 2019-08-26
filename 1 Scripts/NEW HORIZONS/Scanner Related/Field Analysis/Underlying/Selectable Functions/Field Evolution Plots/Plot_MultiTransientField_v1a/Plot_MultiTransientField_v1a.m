%====================================================
% (v1a)
%    
%====================================================

function [SCRPTipt,FPLT,err] = Plot_MultiTransientField_v1a(SCRPTipt,FPLTipt)

Status2('busy','Plotting Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
FPLT.method = FPLTipt.Func;
FPLT.acqnum = str2double(FPLTipt.('AcqNumber'));
FPLT.transnum = str2double(FPLTipt.('TransientNumber'));

Status2('done','',2);
Status2('done','',3);
