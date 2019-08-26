%============================================
% Observe ROIs in Slice as a Seperate Image
%============================================

function [ROI_Arr] = Extract_ROI_Array_Each_Slice(roinum,imnum)

global IMT
global SAVEDXLOC
global SAVEDYLOC
global SAVEDZLOC
global SAVEDROISFLAG

%ROI_Arr = 0;
if SAVEDROISFLAG == 0
    return;
end
 
if isempty(cell2mat(SAVEDXLOC(roinum,1)))
    return;
else
    if isempty(cell2mat(IMT(imnum)));
        return;
    else
        for zloc = 1:6
            IM = cell2mat(IMT(imnum));
            outroi = zeros(size(IM)); 
            for m = 1:length(SAVEDXLOC)
                xloc = cell2mat(SAVEDXLOC(roinum,m));
                yloc = cell2mat(SAVEDYLOC(roinum,m));
                curroi = zeros(size(IM));
                curroi(:,:,zloc) = roipoly(IM(:,:,zloc),xloc,yloc);
                outroi = xor(outroi,curroi);                        
            end
            [x,y,z] = size(IM);                    
            p = 0;
            val = zeros(1,x*y*z);
            for i = 1:x
                for j = 1:y
                    for k = 1:z
                        if outroi(i,j,k) == 0
                        else
                            p = p+1;
                            val(p) = IM(i,j,k);
                        end
                    end
                end
            end
            ROI_Arr(zloc,:) = val(1:p);    
        end
    end
end


