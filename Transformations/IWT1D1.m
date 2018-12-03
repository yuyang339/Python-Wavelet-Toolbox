function y=IWT1D1(x,h)
%IWT1D1 takes as input a vector of even length and an even-length orthogonal filter h, and returns one iteration of
%the discrete inverse wavelet transformation.

    L=length(h);
    N=length(x);

    if mod(N,2)~=0
        str='IWT1D1: The length of the input vector must be an even integer - returning x.';
        disp(str);
        y=x;
        return;
    end
    
    if mod(L,2)~=0
        str='IWT1D1: The input filter length must be an even integer - returning x.';
        disp(str);
        y=x;
        return;
    end

    if size(x)==[N,1]
        x=x';
    end
    
    if size(h)==[1,L]
        h=h';
    end
    
    hh=flipud(h);

    for k=1:L
        g(k)=(-1)^k*h(k);
    end
    g=g';
        
    t=x(1:1:N/2);
    b=x(N/2+1:1:N);
    y=IWTht(t,hh)+IWTht(b,g);