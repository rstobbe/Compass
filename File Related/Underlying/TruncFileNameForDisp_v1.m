%=========================================================
% For Use with RWSUI B5+
%=========================================================

function [Output] = TruncFileNameForDisp_v1(Input,DropExt)

global RWSUIGBL

if contains(Input,'.')
    if strcmp(DropExt,'Yes')
        ext = Input;
        while true
            [fileext,ext] = strtok(ext,'.');
            if isempty(ext)
                break
            end
        end
        Input = Input(1:length(Input)-length(fileext)-1);
    end
end

Output = Input;
if length(Output) > RWSUIGBL.fullwid-2
    ind = strfind(Input,filesep);
    n = 1;
    while true
        if n > length(ind)
            %Output = [Output(1:RWSUIGBL.fullwid-3),'...'];
            ind = strfind(Output,'_');
            if not(isempty(ind))
                Output = Output(ind(1)+1:end);
            end
            if length(Output) >= RWSUIGBL.fullwid
                Output = ['...',Output(length(Output)-RWSUIGBL.fullwid+4:end)];
            end
            break
        end 
        Output = ['...',Input(ind(n):length(Input))];
        if length(Output) < RWSUIGBL.fullwid
%             if n == length(ind)
%                 ind = strfind(Output,'_');
%                 if not(isempty(ind))
%                     Output = Output(ind(1)+1:end);
%                 end
%             end
            break
        end       
        n = n+1;
    end
end
