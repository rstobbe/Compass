%=========================================================
%
%=========================================================

function [Array,err] = ArrayAssessVarian_v1a(ProcPar)

err.flag = 0;
err.msg = '';

params = {'arraydim','array','arrayname','rcvrs'};
out = Parse_ProcparV_v1b(ProcPar,params);
ArrayDim = out{1};
ArrayText = out{2}{1};
if not(isempty(out{3}))
    tArrayNames = out{3}{1};
else
    tArrayNames = '';
end
nrcvrs = length(strfind(out{4}{1},'y'));
ArrayDim = ArrayDim/nrcvrs;
if not(isempty(tArrayNames))
    ind = strfind(tArrayNames,',');
    if isempty(ind)
        ArrayNames{1} = tArrayNames;
    elseif length(ind) == 1
        ArrayNames{1} = tArrayNames(1:ind-1);
        ArrayNames{2} = tArrayNames(ind+1:end); 
    end        
else
    ind0 = strfind(ArrayText,',');
    if isempty(ind0)
    	ArrayNames{1} = ArrayText;
    else
        ArrayNames{1} = 'Array';      % add array names to sequence
    end
end
        
if ArrayDim > 1
    arrdim = 1;
    while true
        ArrayVars = [];
        ArrayVals = [];
        ind0 = strfind(ArrayText,',');   
        if isempty(ind0)
            if not(isempty(ArrayText))
                ArrayVars{1} = ArrayText;
                ArrayVals = Parse_ProcparV_v1b(ProcPar,ArrayVars);
                Array{arrdim}.VarNames = ArrayVars;
                Array{arrdim}.ArrayLength = length(ArrayVals{1}); 
                ArrayVals = Parse_ProcparV_v1b(ProcPar,ArrayVars);
                Array{arrdim}.(ArrayVars{1}) = ArrayVals{1};
                break
            end
        end
        ind1 = strfind(ArrayText,'(');   
        jointarr = 0;
        if ind1(1) < ind0(1)
            jointarr = 1;
        end
        %-----------------------------------
        % Jointly Arrayed Parameters
        if jointarr == 1
            ind1 = strfind(ArrayText,'('); 
            ind2 = strfind(ArrayText,')');
            ArrayText0 = ArrayText(ind1+1:ind2-1);
            if ind2 < length(ArrayText)
                ArrayTextLeft = ArrayText(ind2+2:end); 
            end
            ind = strfind(ArrayText0,',');
            ArrayVars{1} = ArrayText0(1:ind(1)-1);
            m = 2;
            for p = 2:length(ind)
                ArrayVars{m} = ArrayText0(ind(p-1)+1:ind(p)-1);
                m = m+1;
            end
            if isempty(p)
                p = 1;
            end
            ArrayVars{m} = ArrayText0(ind(p)+1:end);
            ArrayVals = Parse_ProcparV_v1b(ProcPar,ArrayVars);
            for n = 1:length(ArrayVars)
                Array{arrdim}.(ArrayVars{n}) = ArrayVals{n};
            end
            Array{arrdim}.VarNames = ArrayVars;
            Array{arrdim}.ArrayLength = length(ArrayVals{1});
            if ind2 == length(ArrayText)
                break
            end
        else
            ind0 = strfind(ArrayText,',');   
            ArrayVars{1} = ArrayText(1:ind0(1)-1);
            ArrayTextLeft = ArrayText(ind0(1)+1);
            ArrayVals = Parse_ProcparV_v1b(ProcPar,ArrayVars);
            Array{arrdim}.(ArrayVars{1}) = ArrayVals{1};
            Array{arrdim}.VarNames = ArrayVars;
            Array{arrdim}.ArrayLength = length(ArrayVals{1}); 
        end
        ArrayText = ArrayTextLeft;
        arrdim = arrdim + 1;
    end
end

if not(isempty(ArrayNames))
    if length(ArrayNames) ~= length(Array)
        error()
    end
    for n = 1:length(Array)
        Array{n}.ArrayName = ArrayNames{n};
    end
else
    for n = 1:length(Array)
        Array{n}.ArrayName = [];
    end
end

arraylen = 1;
for n = 1:length(Array)
    arraylen = arraylen*Array{n}.ArrayLength;
end
if arraylen~= ArrayDim
    error()
end

