%=====================================================
% 
%=====================================================

function [GQNT,err] = QVecSlv_Even_v2b_Func(GQNT,INPUT)

Status2('busy','Quantize Gradient Waveforms',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJdgn = INPUT.PROJdgn;
clear INPUT

%---------------------------------------------
% Output
%---------------------------------------------
GQNT.samparr = (0:GQNT.gseg:PROJdgn.tro);
GQNT.scnrarr = GQNT.samparr;
GQNT.divno = 1;
GQNT.mingseg = GQNT.gseg;

%---------------------------------------------
% Test Quantization
%---------------------------------------------
if GQNT.samparr(length(GQNT.samparr)) ~= PROJdgn.tro 
    err.flag = 1;
    err.msg = 'Tro not a multiple of Gseg';
    returnl
end
if GQNT.gseg < 0.0002
    error('Gseg must be greater than 0.2 us');
end
GQNTtbase = round(GQNT.gseg*1e9)/1e9;
if rem(GQNTtbase*1e6,50)
    error('GQNTtbase must be a multiple of 50 ns');
end

%---------------------------------------------
% Panel Output
%---------------------------------------------    
Panel(1,:) = {'gseg',GQNT.gseg,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
GQNT.PanelOutput = PanelOutput;
        
Status2('done','',2);
Status2('done','',3);

