%=========================================================
% 
%=========================================================

function [WRTRFCS,err] = WrtRefocus_REALVSL_v1e_Func(WRTRFCS,INPUT)

Status2('busy','Write Gradient Refocussing Tables',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-------------------------------------------------
% Get input
%-------------------------------------------------
IMP = INPUT.IMP;
WRT = INPUT.WRT;
clear INPUT

%-------------------------------------------------
% Lengths
%-------------------------------------------------
lengths = WRTRFCS.lengths;
inds = strfind(lengths,' ');
len(1) = str2double(lengths(1:inds(1)-1));
if length(inds) == 1
    len(2) = str2double(lengths(inds(1)+1:length(lengths)));
else
    for n = 2:length(inds-1)
        len(n) = str2double(lengths(inds(n-1)+1:inds(n)-1));
    end
    len(n+1) = str2double(lengths(inds(n)+1:length(lengths)));
end

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

%-------------------------------------------------
% Calculate Refocus Gradient Value
%-------------------------------------------------
GA = IMP.Kend/IMP.PROJimp.gamma;              % Kend is the k-value beyond sampling at the very end of the gradients after fall 
for n = 1:length(len)
    GV(:,:,n) = GA(:,:)/len(n);
    MaxRefG(n) = max(max(GV(:,:,n)));
end
    
%-------------------------------------------------
% Test
%-------------------------------------------------
if max(MaxRefG(:)) > WRT.sysgmax
    err.flag = 1;
    err.msg = 'Adjust Refocus lengths';
    return;
end
WRTRFCS.MaxRefG = MaxRefG(1);
WRTRFCS.MaxRefGlen = len(1);

%-------------------------------------------------
% Calculate Varian Gradient Value
%-------------------------------------------------
rel = (1/WRT.sysgmax) * 32767; 
GV = round(rel*GV);

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
if isempty(IMP.SYS.projmult)
    mult = 1;
else
    mult = IMP.SYS.projmult;
end

if strcmp(IMP.SYS.sym,'PosNeg')
    sym = 2;
else
    sym = 1;
end

N = IMP.PROJimp.nproj/(mult*sym);
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
