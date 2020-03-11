%GENERATING MULTI-INDICES
%p=number of variables
%d=the chaos order
function a=polymultiindex(p,d)
%%p=dimensions number
%%%d=PC order
a(1,1:p)=zeros(1,p);
a(2:p+1,1:p)=eye(p,p);
P=p+1;
pmat=[];
pmat(1:p,1)=1;
for k=2:d
    L=P;
    for i=1:p
        pmat(i,k)=sum(pmat(i:p,k-1));
          i=i+1;
    end
    for j=1:p
        for m=L-pmat(j,k)+1:L
            P=P+1;
            a(P,1:p)=a(m,1:p);
            a(P,j)=a(P,j)+1;
            m=m+1;
        end
        j=j+1;
    end
          
    k=k+1;
end
size(a);
end
