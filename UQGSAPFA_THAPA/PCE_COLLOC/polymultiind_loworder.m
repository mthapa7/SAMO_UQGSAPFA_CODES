%% use only low order index polynomials
function output=polymultiind_loworder(VARNUM,interactionorder,MULTINDEX_ADDITION)

for itk=1:size(MULTINDEX_ADDITION,1)
    vals_interaction(itk,1)=length(find(MULTINDEX_ADDITION(itk,:)>0));
end

%%rearrange according to interaction order!!!
MULTINDEX_REARRANGED=[];
for count=1:VARNUM
    locs_intrcn=find(vals_interaction==count);
    MULTINDEX_ORDER=MULTINDEX_ADDITION(locs_intrcn,:);
    MULTINDEX_REARRANGED=[MULTINDEX_REARRANGED;MULTINDEX_ORDER];
end


%%then use the interation order of arrange multiindex
for itk=1:size(MULTINDEX_REARRANGED,1)
    vals_interaction_new(itk,1)=length(find(MULTINDEX_REARRANGED(itk,:)>0));
end



%%find the interation order
goodlocs=find(vals_interaction_new<=interactionorder);
lth=goodlocs(end);
MULTINDEX_LOWORDERINTERACT=MULTINDEX_REARRANGED(1:lth,:);
%%the use for only given interaction order polynomials\

output=MULTINDEX_LOWORDERINTERACT;
end