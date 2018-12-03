function y = Coiffun(h)
%Coiffun creates the system that must be solved in order to find the
%Coiflet filter.

global COIFLENGTH;
K=COIFLENGTH/6;

for m=1:COIFLENGTH/2
    if m==1
        y(m)=-1;
    else
        y(m)=0;
    end
    
    idx=2*(m-1);
    for k=1:COIFLENGTH-idx
        y(m)=y(m)+h(k)*h(k+idx);
    end
end

y(COIFLENGTH/2+1)=-sqrt(2);
for k=1:COIFLENGTH
    y(COIFLENGTH/2+1)=y(COIFLENGTH/2+1)+h(k);
end

y(COIFLENGTH/2+1)=0;
for k=1:COIFLENGTH
    y(COIFLENGTH/2+1)=y(COIFLENGTH/2+1)+(-1)^k*h(k);
end

idx=COIFLENGTH/2+2;
for m=1:2*K-1
    y(m+idx)=0;
    for k=0:2*K-1
        y(m+idx)=y(m+idx)+(-1)^(k+m-1)*(2*K-k)^m*h(k+1);
    end
    for k=0:4*K-2
        y(m+idx)=y(m+idx)+(-1)^k*(k+1)^m*h(2*K+2+k);
    end
end

idx=idx+2*K-1;
for m=1:2*K-1
    y(m+idx)=0;
    for k=0:2*K-1
        y(m+idx)=y(m+idx)+(2*K-k)^m*h(k+1);
    end
    for k=0:4*K-2
        y(m+idx)=y(m+idx)+(-1)^m*(k+1)^m*h(2*K+2+k);
    end
end