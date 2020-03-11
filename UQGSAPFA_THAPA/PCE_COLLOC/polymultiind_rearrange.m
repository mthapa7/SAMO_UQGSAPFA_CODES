%%THIS CODE IS TO REARRANGE THE MULTIINDICES BASED ON THE INTERACTION OF
%%THE DIMENSIONS given the additional multiindices for a given order!!
function output=polymultiind_rearrange(VARNUM,MULTINDEX_ADDITION)
for itk=1:length(MULTINDEX_ADDITION)
    vals_interaction(itk,1)=length(find(MULTINDEX_ADDITION(itk,:)>0));
end

MULTINDEX_REARRANGED=[];
for count=1:VARNUM
    locs_intrcn=find(vals_interaction==count);
    MULTINDEX_ORDER=MULTINDEX_ADDITION(locs_intrcn,:);
    MULTINDEX_REARRANGED=[MULTINDEX_REARRANGED;MULTINDEX_ORDER];
end
output=MULTINDEX_REARRANGED;
end