%=====================================================
% 
%=====================================================

function [GQNT,err] = QVecSlv_BasicQuantizedTPI_v1a_Func(GQNT,INPUT)

Status2('busy','Quantize Gradient Waveforms',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJdgn = INPUT.PROJdgn;
SYS = INPUT.SYS;
mode = INPUT.mode;
clear INPUT

%---------------------------------------------
% Test
%---------------------------------------------
if rem(GQNT.twseg*1000,SYS.GradSampBase)
    err.flag = 1;
    err.msg = ['twGseg must be a multiple of ',num2str(SYS.GradSampBase),' us'];
    return
end
if rem(PROJdgn.iseg*1000,SYS.GradSampBase)
    err.flag = 1;
    err.msg = ['iGseg must be a multiple of ',num2str(SYS.GradSampBase),' us'];
    return
end
if rem((PROJdgn.tro-PROJdgn.iseg)*1000,SYS.GradSampBase)
    err.flag = 1;
    err.msg = 'Tro must be a multiple of iGseg and twGseg';
    return
end

switch mode
%====================================================
% Find Best Quantization
%====================================================
case 'FindBest'
    GQNT.besttro = PROJdgn.tro;                     % relavent to INOVA
    GQNT.bestiseg = PROJdgn.iseg;
    GQNT.besttwseg = GQNT.twseg;
    
%====================================================
% Generate Quantization Vector
%====================================================   
case 'Output'   
    GQNT.scnrarr = [0 PROJdgn.iseg (PROJdgn.iseg+GQNT.twseg:GQNT.twseg:PROJdgn.tro)];
    GQNT.samparr = GQNT.scnrarr;
    GQNT.mingseg = min([PROJdgn.iseg GQNT.twseg]); 
    GQNT.tro = PROJdgn.tro;
    GQNT.iseg = PROJdgn.iseg;
    GQNT.twwords = length(GQNT.samparr)-2;
end


        
Status2('done','',2);
Status2('done','',3);

