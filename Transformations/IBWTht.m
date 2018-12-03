function y=IBWTht(u,f,passflag)
%IBWTht is an auxiliary routine used by IBWT1D1 to compute half of the inverse biorthogonal wavelet transform on input vector v.

    N=length(u);
    Lf=length(f);
    L=(Lf-mod(Lf,2))/2;
    
    if mod(Lf,2)==0
        if mod(L,2)==0
            for k=0:L-1
                feven(k+1)=f(Lf-2*k);
                fodd(k+1)=f(Lf-2*k-1);
            end
        else
            for k=0:L-1
                fodd(k+1)=f(Lf-2*k);
                feven(k+1)=f(Lf-2*k-1);
            end
        end
        
        p=floor(L/2);
        a=floor((L-1)/2);
    
        c=[u(N-p+1:end) u];
        c=[c u(1:a)];
    
        p=floor((L-1)/2);
        a=floor((L+1)/2);
    
        d=[u(N-p+1:end) u];
        d=[d u(1:a)];
    
        for k=1:N
            y(2*k-1)=0;
            y(2*k)=0;
            for j=1:L
                y(2*k-1)=y(2*k-1)+feven(j)*c(k+j-1);
                y(2*k)=y(2*k)+fodd(j)*d(k+j-1);
            end
        end
    else
        if passflag==1
            L=L+1;
        end

        if mod(L,2)==0
            for k=0:L-passflag
                feven(k+1)=f(Lf-2*k);
            end
            
            for k=0:L-1-passflag
                fodd(k+1)=f(Lf-1-2*k);
            end
        else
            for k=0:L-passflag
                fodd(k+1)=f(Lf-2*k);
            end
            
            for k=0:L-1-passflag
                feven(k+1)=f(Lf-2*k-1);
            end
        end
        
        l=length(feven);
        m=length(fodd);
        
        p=floor(L/2);
        a=floor((L-2*passflag)/2);
        
        c=[ u(N-p+1:end) u];
        c=[c u(1:a)];
        
        p=floor((L-1)/2);
        a=floor((L+1-2*passflag)/2);
        
        d=[ u(N-p+1:end) u];
        d=[d u(1:a)];
               
        for k=1:N
            y(2*k-1)=0;
            y(2*k)=0;
            
            for j=1:l
                y(2*k-1)=y(2*k-1)+feven(j)*c(k+j-1);
            end
            
            for j=1:m
                y(2*k)=y(2*k)+fodd(j)*d(k+j-1);
            end
        end
    end