%=========================================================
% 
%=========================================================

function  [FUNClabs,error,errorflag] = Labels(method,func)

error = '';
errorflag = 0;
funcpurp = 'function combines solution for kernel and data values';

%--------------------------------
% Tests
%--------------------------------
validfor = {''};

good = 0;
for n = 1:length(validfor)
    if (strcmp(method,validfor{n}))
        good = 1;
        break
    end
end
if good == 0
    errorflag = 1;
    error = [func,' Function Not Appropriate for ',method];
    Status2('error',error,1);
    Status2('busy',funcpurp,2);
    return
end

%--------------------------------
% Defaults
%--------------------------------

%--------------------------------
% Labels
%--------------------------------
FUNClabs = '';
