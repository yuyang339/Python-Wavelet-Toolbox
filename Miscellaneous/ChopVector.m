function y = ChopVector(v,its,varargin)
%ChopVector takes as input a vector v and a number of iterations its and
%chops enough elements off the bottom (or right for a row vector) so that
%the length of v is divisible by 2^its.  You can also add optional
%arguments to instruct the routine to print the new length of the vector.
%In this case, the call is y=ChopVector(v,its,'PrintInfo','True');

if round(its)~=its
    str=sprintf('ChopVector: The value for its must be an integer - returning the original input vector.');
    disp(str);
    y=v;
    return;
end

if its<=0
    str=sprintf('ChopVector: The value for its must be a positive integer - returning the original input vector.');
    disp(str);
    y=v;
    return;
end

if ~isvector(v)
    str=sprintf('ChopVector: v must be either a row vector or a column vector - returning the original input vector.');
    disp(str);
    y=v;
    return;
end

n=length(v);
if size(v)==[1 n]
    v=v';
end

if n<2^its
    str=sprintf('ChopVector: 2^%i is larger than the length (%i) of the input vector - returning the original input vector.',its,n);
    disp(str);
    y=v;
    return;
end

newn=n-mod(n,2^its);

if length(varargin)==2
    if isequal(varargin{1},'PrintInfo') && isequal(varargin{2},'True')
        str=sprintf('\nThe length of the chopped vector is %i.',newn);
        disp(str);
    end
end

y=v(1:newn);

