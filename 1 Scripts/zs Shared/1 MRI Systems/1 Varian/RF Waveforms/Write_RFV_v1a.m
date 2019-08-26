%================================================
% Write Varian RF_File
% 
%================================================

function [err] = Write_RFV_v1a(RF)

err.flag = 0;
err.msg = '';

[file,path] = uiputfile('*.RF','Name RF Waveform');
Name = strtok(file,'.');
fid = fopen([path,file],'w');
fprintf(fid,'# ************************************\n');
fprintf(fid,['# Name: ',Name,'\n']);
fprintf(fid,'# ************************************\n');
fprintf(fid,'%4.1f\t%4.1f\t%g\n',RF);
fclose(fid);