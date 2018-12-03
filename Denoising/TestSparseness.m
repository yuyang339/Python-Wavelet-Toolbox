function [y,flag] = TestSparseness(v,varargin)
%Testsparse takes a vector or matrix and determines whether or not it 
%is sparse.  If it is sparse, the routine returns the 
%UniversalThreshold tolerance, and if it is not sparse, the routine 
%returns the SureShrink threshold tolerance.  An optional argument
%instructs the routine to print the result of the test.  In this case, the
%call is TestSparseness(v,'PrintResult','True');

[r c]=size(v);
n=r*c;
v=reshape(v,1,n);
s=sum(v.^2)/n-1;
u=3*log2(n)/(2*sqrt(n));
sigma=MAD(v)/.6745;
if s<=u
    y=sigma*sqrt(2*log(n));
    flag=0;
else
    y=DonohoSure(v/sigma);
    flag=1;
end

if length(varargin)==2 && isequal(varargin{1},'PrintResult') && isequal(varargin{2},'True')
    if s<=u
        str=sprintf('The input is sparse - returning the universal threshold value.');
    else
        str=sprintf('The input is not sparse - returning the SureShrink threshold value.');
    end
    disp(str);
end
