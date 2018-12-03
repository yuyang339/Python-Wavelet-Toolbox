function p = PolySin2j(K)
%PolySin2j takes a positive integer K and returns the coefficients of the
%ubiquitous trigonometric polynomial P(t)=sum_{k=0}^{K-1}
%binomial(K-1+j,j)sin^(2j)(w/2).  This function is based on trigpoly.m from
%the Uvi_Wave package written at Universidad de Vigo.

%For a given K, the polynomial will have 2K-1 coefficients.  We create a
%matrix to hold the 2K-1 coefficients for each j=0,1,...,K-1 and load the
%the first row with the constant polynomial 1:

c=zeros(K,2*K-1);
c(1,K)=1;

%The first row is done - now compute the remaining rows in the array.

for j=1:K-1
    %First write down the polynomial for sin^2(w/2):
    s2=[-.25 .5 -.25];
    
    %Now raise s2 to the jth power:
    t=s2;
    for m=2:j
        t=conv(t,s2);
    end
 
    %Next multiply this polyomial by the binomial coefficient
    t=nchoosek(K+j-1,j)*t;
    
    %Pad t with the appropriate number of zeros.  t consists of
    %2j+1 terms.  Since there are 2K-1 terms in the final polynomial, we
    %need to pad by 2*K-1-2j-1 = 2(K-j-1).  So we put K-j-1 zeros on each
    %side.
    t=[zeros(1,K-j-1) t zeros(1,K-j-1)];
    
    %Finally, load t in the j+1 row of c
    c(j+1,:)=t;
end

%The last step is to add the columns of c
p=sum(c);