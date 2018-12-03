function y=IWTht(x,h)
    L=length(h);
    N=length(x);
    e=flipud(h(2:2:L));
    o=flipud(h(1:2:L));
    
	t=[x(N-L/2+2:1:N) x];

    for k=1:N
        c(k,:)= t(k:1:k+L/2-1);
    end
    
    b=c*e; a=c*o;
    y=[]';
    for k=1:N
        y=[y; a(k); b(k)];
    end