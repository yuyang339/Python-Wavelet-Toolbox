function B = GammaCorrection(A,r)
%GammaCorrection takes a matrix A whose elements are nonnegative integers <
%256 and a positive number r and returns a gamma-corrected version of A
%(see Section 3.1).

 if max(max(abs(round(A)-A)))~=0
     str=sprintf('GammaCorrection: The elements of the input matrix must be integers - returning the input matrix.');
     disp(str);
     B=A;
     return;
 end
 
 if max(max(A<0))==1 || max(max(A>255))==1
     str=sprintf('GammaCorrection: The elements of the input matrix must be nonnegative integers less than 256 - returning the input matrix.');
     disp(str);
     B=A;
     return;
 end

 if r<=0
     str=sprintf('GammaCorrection: The value of r must be a positive number - returning the input matrix.');
     disp(str);
 end
 
 B=round(255*(A/255).^r);