function y = Daubfun(h)
%Daubfun creates the system that must be solved in order to find the
%orthogonal Daubechies filter.

global DAUBLENGTH;

for m=1:DAUBLENGTH/2
    if m==1
        y(m)=-1;
    else
        y(m)=0;
    end
    idx=2*(m-1);
    for k=1:DAUBLENGTH-idx
        y(m)=y(m)+h(k)*h(k+idx);
    end
end

y(DAUBLENGTH/2+1)=-sqrt(2);
for k=1:DAUBLENGTH
    y(DAUBLENGTH/2+1)=y(DAUBLENGTH/2+1)+h(k);
end

y(DAUBLENGTH/2+2)=0;
for k=1:DAUBLENGTH
    y(DAUBLENGTH/2+2)=y(DAUBLENGTH/2+2)+(-1)^k*h(k);
end

for m=1:DAUBLENGTH/2-1
    y(DAUBLENGTH/2+2+m)=0;
    for k=2:DAUBLENGTH
        y(DAUBLENGTH/2+2+m)=y(DAUBLENGTH/2+2+m)+(-1)^k*(k-1)^m*h(k);
    end
end