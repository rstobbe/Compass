%=========================================================
% 
%=========================================================

function [default] = B0_MonoExp_Manual_Default(TestNum,level)

m = 1;
default{m,1}.labelstyle = ['0labellvl',num2str(level)];
default{m,1}.labelstr = 'B0_TC (ms)';
default{m,1}.entrystr = '0';
default{m,1}.entryvalue = 0;
default{m,1}.searchpath = '';
default{m,1}.buttonname = 'Edit';
default{m,1}.entrytype = 'Input';
default{m,1}.funcname = '';

m = m+1;
default{m,1}.labelstyle = ['0labellvl',num2str(level)];
default{m,1}.labelstr = 'B0_mag (uT)';
default{m,1}.entrystr = '0';
default{m,1}.entryvalue = 0;
default{m,1}.searchpath = '';
default{m,1}.buttonname = 'Edit';
default{m,1}.entrytype = 'Input';
default{m,1}.funcname = '';

