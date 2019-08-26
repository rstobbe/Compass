%====================================================
%
%====================================================

function [default,AIDimp,AIDsys] = LR_v1d_Default(~)

global IMPROUTLOC
gradquantPath = [IMPROUTLOC,'0 Scanner Related\Gradient Quantization Timing\'];
gradwfmPath = [IMPROUTLOC,'0 Scanner Related\Create Gradient Waveform\'];
trajsampPath = [IMPROUTLOC,'0 Scanner Related\Trajectory Sampling\'];
ksampPath = [IMPROUTLOC,'1 ImCon Related\'];

AIDsys.name = 'Varian_Inova_47T';
AIDimp.nucleus = 'Proton';
AIDimp.gamma = '42.577';
AIDimp.visuals = 'On1';

Imp_Name = 'LR';
Orient = 'Axial';
Grad_Quant = 'Even_Division_v1c';
Grad_WFM = 'NoAccom_v4b';
Traj_Samp = 'Const_TR_v3c';
k_Samp = 'NoECI_v1c';

m = 1;
default{m,1}.labelstyle = '0labellvl1'; 
default{m,1}.labelstr = 'Imp_Name';
default{m,1}.entrystr = Imp_Name;
default{m,1}.entryvalue = 0;
default{m,1}.searchpath = '';
default{m,1}.buttonname = 'Edit';
default{m,1}.entrytype = 'Label';
default{m,1}.funcname = '';

m = m+1;
default{m,1}.labelstyle = '0labellvl1'; 
default{m,1}.labelstr = 'Orient';
default{m,1}.entrystr = Orient;
default{m,1}.entryvalue = 0;
default{m,1}.searchpath = '';
default{m,1}.buttonname = 'Choose';
default{m,1}.options = {'Axial','Sagittal','Coronal'};
default{m,1}.entrytype = 'Input';
default{m,1}.funcname = '';

m = m+1;
default{m,1}.labelstyle = '0labellvl1'; 
default{m,1}.labelstr = 'Grad_Quant';
default{m,1}.entrystr = Grad_Quant;
default{m,1}.entryvalue = 0;
default{m,1}.searchpath = gradquantPath;
default{m,1}.buttonname = 'Select';
default{m,1}.entrytype = 'Function';
default{m,1}.funcname = '';

m = m+1;
default{m,1}.labelstyle = '0labellvl1'; 
default{m,1}.labelstr = 'Traj_Samp';
default{m,1}.entrystr = Traj_Samp;
default{m,1}.entryvalue = 0;
default{m,1}.searchpath = trajsampPath;
default{m,1}.buttonname = 'Select';
default{m,1}.entrytype = 'Function';
default{m,1}.funcname = '';

m = m+1;
default{m,1}.labelstyle = '0labellvl1'; 
default{m,1}.labelstr = 'Grad_WFM';
default{m,1}.entrystr = Grad_WFM;
default{m,1}.entryvalue = 0;
default{m,1}.searchpath = gradwfmPath;
default{m,1}.buttonname = 'Select';
default{m,1}.entrytype = 'Function';
default{m,1}.funcname = '';

m = m+1;
default{m,1}.labelstyle = '0labellvl1'; 
default{m,1}.labelstr = 'k_Samp';
default{m,1}.entrystr = k_Samp;
default{m,1}.entryvalue = 0;
default{m,1}.searchpath = ksampPath;
default{m,1}.buttonname = 'Select';
default{m,1}.entrytype = 'Function';
default{m,1}.funcname = '';

