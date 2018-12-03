function y=IBWT1D1(v,h,ht,varargin)
%IBWT1D1 takes as input a vector of even length and a symmetric biorthogonal filter pair [h,ht] and returns one iteration of the discrete 
%inverse biorthogonal wavelet transformation.  Arguments can be added so that
%IBWT1D1 utilizes the symmetry of the filter pair (see Section 11.3).  In
%this case the call is IBWT1D1(y,h,ht,'Boundary','Reflective').

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
    
    hwStop=(Mt-mod(Mt,2))/2;
    p=[0 Mt-1]+mod(hwStop+1,2)*[1 1];

    if length(varargin)==2 && isequal(varargin{1},'Boundary')
        boundaryon=varargin{2};
    else
        boundaryon='False';
    end
    
    if isequal(boundaryon,'Reflective') %Use reflective boundaries
        lp=v(1:N/2);
        lp=[lp fliplr(lp(mod(Mt,2)+1:end))];
        hp=v(N/2+1:end);
        hp=[hp (-1)^(Mt+1)*fliplr(hp(1:end-mod(Mt,2)))];
        vv=[lp hp];
    else
        vv=v;
    end
    
    NN=length(vv);
    
    g=ht;
    for k=p(1):p(2)
        a(k-p(1)+1)=(-1)^k;
    end
     
    g=g.*a';
     
   y=IBWTht(vv(1:NN/2),h,0)'+IBWTht(vv(NN/2+1:end),g,1)';
   
   if isequal(boundaryon,'Reflective') 
       y=y(1:N);
   end

   