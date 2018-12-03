function y=WT1D1(x,h)
%WT1D1 takes as input a vector of even length and an even-length orthogonal filter h, and returns one iteration of
%the discrete wavelet transformation.

    L=length(h);
    N=length(x);

    if mod(N,2)~=0
        str='WT1D1: The length of the input vector must be an even integer - returning x.';
        disp(str);
        y=x;
        return;
    end
    
    if mod(L,2)~=0
        str='WT1D1: The input filter length must be an even integer - returning x.';
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
   
    c=zeros(N/2,L);
    t=[x x(1:L-2)];
    for k=1:N/2
        idx=2*k-1;
        c(k,:)= t(idx:1:idx+L-1);
    end
    
    y=[c*hh; c*g'];