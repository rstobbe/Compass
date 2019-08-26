%=========================================================
% 
%=========================================================

function [WRTRFCS,err] = WrtRefocus_REALVSL_v1d_Func(WRTRFCS,INPUT)

Status2('busy','Write Gradient Refocussing Tables',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-------------------------------------------------
% Get input
%-------------------------------------------------
WRT = INPUT.WRT;
clear INPUT

%-------------------------------------------------
% Common Variables
%-------------------------------------------------
RefocusDefLoc = WRTRFCS.RefocusDefLoc;

%-------------------------------------------------
% Name Parameter File
%-------------------------------------------------
[path0] = uigetdir(RefocusDefLoc,'Select/Create Folder for Gradient Refocusing Tables');
if path0 == 0
    err.flag = 1;
    err.msg = 'Gradient Refocussing Tables Not Written';
    return
end
WRTRFCS.RefocusLoc = path0;

len = [1 2 3 4 5 10];
GA = WRT.Kend/WRT.gamma;              % Kend is the k-value beyond sampling at the very end of the gradients after fall 

GV(:,:,1) = GA(:,:)/len(1);
GV(:,:,2) = GA(:,:)/len(2);
GV(:,:,3) = GA(:,:)/len(3);
GV(:,:,4) = GA(:,:)/len(4);
GV(:,:,5) = GA(:,:)/len(5);
GV(:,:,6) = GA(:,:)/len(6);

%-------------------------------------------------
% Calculate Varian Gradient Value
%-------------------------------------------------
rel = (1/WRT.sysgmax) * 32767; 
GV = round(rel*GV);

if max(GV(:)) > 32767
    err.flag = 1;
    err.msg = 'Adjust Refocus lengths';
    return;
end

%-------------------------------------------------
% Create or Clear Directory
%-------------------------------------------------
if exist([path0,'\L1\GSx1'],'file')
    button = questdlg('Refocus files may aready exist. Rewrite files?');
    if strcmp(button,'No') || strcmp(button,'Cancel')
        err.flag = 1;
        err.msg = 'Refocus Files Not Written';
        return
    end
    rmdir(path0,'s');
    pause(0.5); %need sufficient wait time here... 
end

for n = 1:length(len)
    mkdir(path0,['\L',num2str(len(n))]);
    path{n} = [path0,'\L',num2str(len(n))];
end

%-------------------------------------------------
% Write files
%-------------------------------------------------
if isempty(WRT.projmult)
    mult = 1;
else
    mult = WRT.projmult;
end

if strcmp(WRT.sym,'PosNeg')
    sym = 2;
else
    sym = 1;
end

N = WRT.nproj/(mult*sym);
for m = 1:length(len)
    for n = 1:N

        filex = strcat(path{m},'\GSx',num2str((n-1)*mult+1));
        filey = strcat(path{m},'\GSy',num2str((n-1)*mult+1));
        filez = strcat(path{m},'\GSz',num2str((n-1)*mult+1));

        fid = fopen(filex,'w+');
        fprintf(fid,'t2 = ');
        fclose(fid);

        fid = fopen(filey,'w+');
        fprintf(fid,'t3 = ');
        fclose(fid);

        fid = fopen(filez,'w+');
        fprintf(fid,'t4 = ');
        fclose(fid);
              
        dlmwrite(filex,GV((n-1)*mult+1:n*mult,1,m)','delimiter',' ','newline','unix','-append');
        dlmwrite(filey,GV((n-1)*mult+1:n*mult,2,m)','delimiter',' ','newline','unix','-append');
        dlmwrite(filez,GV((n-1)*mult+1:n*mult,3,m)','delimiter',' ','newline','unix','-append');   
    end
end

Status2('done','',2);
Status2('done','',3);
