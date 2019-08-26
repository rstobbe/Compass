%====================================================
%
%====================================================

function [default] = ReadSMISparams_Default(TestNum,level)

global SMISDATALOC

m = 1;
default{m,1}.labelstyle = ['0labellvl',num2str(level)]; 
default{m,1}.labelstr = 'Data_File';
default{m,1}.entrystr = '';
default{m,1}.entryvalue = 0;
default{m,1}.searchpath = '';
default{m,1}.buttonname = 'Load';
default{m,1}.entrytype = 'Label';
default{m,1}.funcname = ['SelectDataFile(',num2str(TestNum),',''',SMISDATALOC,''''];

