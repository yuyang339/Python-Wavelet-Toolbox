function y=DonohoSure(v)
%DonohoSure takes as input a vector v and returns the SUREShrink tolerance lambda.

[r c]=size(v);
n=r*c;
v=reshape(v,1,n);
a=sort(v.^2);
b=cumsum(a);
c=n-1:-1:0;
s=b+c.*a;
r=n-2*linspace(1,n,n)+s;
[b,idx]=sort(r);
y=sqrt(a(idx(1)));