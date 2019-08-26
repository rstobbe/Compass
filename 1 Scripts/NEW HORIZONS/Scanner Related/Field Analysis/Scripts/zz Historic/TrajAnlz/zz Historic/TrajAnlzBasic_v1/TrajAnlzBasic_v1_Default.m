%====================================================
%
%====================================================

function [default] = TrajAnlzBasic_v1_Default(TestNum,level)

global DEFAULTDATALOC
addpath('D:\0 Programs\A9 FieldAnlz\0 Scripts\zz Common Routines');

m = 1;
default{m,1}.labelstyle = ['0labellvl',num2str(level)]; 
default{m,1}.labelstr = 'System';
default{m,1}.entrystr = 'Varian';
default{m,1}.entryvalue = 0;
default{m,1}.searchpath = '';
default{m,1}.buttonname = 'Choose';
default{m,1}.options = {'SMIS','Varian'};
default{m,1}.entrytype = 'Choose';
default{m,1}.funcname = '';

%m = m+1;
%default{m,1}.labelstyle = ['0labellvl',num2str(level)]; 
%default{m,1}.labelstr = 'File_PosLoc1';
%default{m,1}.entrystr = '';
%default{m,1}.entryvalue = 0;
%default{m,1}.searchpath = '';
%default{m,1}.buttonname = 'Load';
%default{m,1}.entrytype = 'Label';
%default{m,1}.funcname = ['SelectDataFile(',num2str(TestNum),',''',SMISDATALOC,''''];

%m = m+1;
%default{m,1}.labelstyle = ['0labellvl',num2str(level)]; 
%default{m,1}.labelstr = 'File_PosLoc2';
%default{m,1}.entrystr = '';
%default{m,1}.entryvalue = 0;
%default{m,1}.searchpath = '';
%default{m,1}.buttonname = 'Load';
%default{m,1}.entrytype = 'Label';
%default{m,1}.funcname = ['SelectDataFile(',num2str(TestNum),',''',SMISDATALOC,''''];

%m = m+1;
%default{m,1}.labelstyle = ['0labellvl',num2str(level)]; 
%default{m,1}.labelstr = 'File_NoGrad1';
%default{m,1}.entrystr = '';
%default{m,1}.entryvalue = 0;
%default{m,1}.searchpath = '';
%default{m,1}.buttonname = 'Load';
%default{m,1}.entrytype = 'Label';
%default{m,1}.funcname = ['SelectDataFile(',num2str(TestNum),',''',SMISDATALOC,''''];

%m = m+1;
%default{m,1}.labelstyle = ['0labellvl',num2str(level)]; 
%default{m,1}.labelstr = 'File_NoGrad2';
%default{m,1}.entrystr = '';
%default{m,1}.entryvalue = 0;
%default{m,1}.searchpath = '';
%default{m,1}.buttonname = 'Load';
%default{m,1}.entrytype = 'Label';
%default{m,1}.funcname = ['SelectDataFile(',num2str(TestNum),',''',SMISDATALOC,''''];

m = m+1;
default{m,1}.labelstyle = ['0labellvl',num2str(level)]; 
default{m,1}.labelstr = 'File_Grad1';
default{m,1}.entrystr = '';
default{m,1}.entryvalue = 0;
default{m,1}.searchpath = '';
default{m,1}.buttonname = 'Load';
default{m,1}.entrytype = 'Label';
default{m,1}.funcname = ['SelectData(',num2str(TestNum),',''',DEFAULTDATALOC,''''];

m = m+1;
default{m,1}.labelstyle = ['0labellvl',num2str(level)]; 
default{m,1}.labelstr = 'File_Grad2';
default{m,1}.entrystr = '';
default{m,1}.entryvalue = 0;
default{m,1}.searchpath = '';
default{m,1}.buttonname = 'Load';
default{m,1}.entrytype = 'Label';
default{m,1}.funcname = ['SelectData(',num2str(TestNum),',''',DEFAULTDATALOC,''''];

m = m+1;
default{m,1}.labelstyle = ['0labellvl',num2str(level)];
default{m,1}.labelstr = 'loc1';
default{m,1}.entrystr = '0';
default{m,1}.entryvalue = 0;
default{m,1}.searchpath = '';
default{m,1}.buttonname = 'Edit';
default{m,1}.entrytype = 'Input';
default{m,1}.funcname = '';

m = m+1;
default{m,1}.labelstyle = ['0labellvl',num2str(level)];
default{m,1}.labelstr = 'loc2';
default{m,1}.entrystr = '0';
default{m,1}.entryvalue = 0;
default{m,1}.searchpath = '';
default{m,1}.buttonname = 'Edit';
default{m,1}.entrytype = 'Input';
default{m,1}.funcname = '';




