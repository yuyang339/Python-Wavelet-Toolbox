function j = MaxIterations(n)
%MaxIterations takes an integer n and returns the largest j so that 2^j is
%a factor of n.

m=factor(n);
y=find(m==2);
j=length(y);