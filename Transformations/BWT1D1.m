function y=BWT1D1(v,h,ht,varargin)
%BWT1D1 takes as input a vector of even length and a symmetric biorthogonal filter [h,ht] pair and returns one iteration of the discrete 
%biorthogonal wavelet transformation.  Arguments can be added so that
%BWT1D1 utilizes the symmetry of the filter pair (see Section 11.3).  In
%this case the call is BWT1D1(y,h,ht,'Boundary','Reflective').

    M=length(h);
    Mt=length(ht);
    N=length(v);

    if mod(N,2)~=0
        str='BWT1D1: The length of the input vector must be an even integer - returning x.';
        disp(str);
        y=v;
        return;
    end
    
    if mod(abs(M-Mt),2)~=0
        str='BWT1D1: The input filter lengths must have the same parity - returning x.';
        disp(str);
        y=v;
        return;
    end

    if size(v)==[N,1]
        v=v';
    end
    
    if size(h)==[1,M]
        h=h';
    end
    
    if size(ht)==[1,Mt]
        ht=ht';
    end

    L=(M-mod(M,2))/2;
    Lt=(Mt-mod(Mt,2))/2;
    p=[0 M-1]+mod(L+1,2)*[1 1];
    
    if length(varargin)==2 && isequal(varargin{1},'Boundary')
        boundaryon=varargin{2};
    else
        boundaryon='False';
    end
    
    if isequal(boundaryon,'Reflective') %Use reflective boundaries
        idx = [1 N] + mod(Mt,2)*[1 -1];
        vv=[v fliplr(v(idx(1):idx(2)))];
    else
        vv=v;
    end
    
    NN=length(vv);
    
    gt=flipud(h);
    for k=p(1):p(2)
        a(k-p(1)+1)=(-1)^k;
    end
     
    gt=gt.*a';
     
    if mod(Mt,2)==0
        eo=1;
    else
        eo=0;
    end
   
    w=[vv(NN-(Lt-1)+eo:end) vv];
    w=[w vv(1:Lt-eo)];
   
    top=zeros(NN/2,Mt);
    for k=1:NN/2
        idx=2*k-1;
        top(k,:)= w(idx:1:idx+Mt-1);
    end
    
    w=[vv(NN-(L-2):end) vv];
    w=[w vv(1:L)];
    bot=zeros(NN/2,M);
    for k=1:NN/2
        idx=2*k-1;
        bot(k,:)= w(idx:1:idx+M-1);
    end
    
    
    y=[top*ht; bot*gt];
    
    if isequal(boundaryon,'Reflective') %Grab the correct portion of y to return
        y=[y(1:N/2); y(NN/2+1:(NN+N)/2)];
    end

   