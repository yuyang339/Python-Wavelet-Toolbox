function y=WaveletShrinkage(v,h,its,lambda)
%WaveletShrinkage takes a vector or matrix, an orthogonal filter, a number of iterations for the 
%wavelet transform, and a tolerance (or list of tolerances), and returns a denoised version of the input vector 
%or matrix.  The module uses Algorithm 9.1 from Section 9.1 of the book.

if ~isvector(h)
    str='WaveletShrinkage: The input filter must be a row vector or a column vector - returning original input';
    disp(str);
    y=v;
    return;
end

if mod(length(h),2)~=0
    str='WaveletShrinkage: The input filter length must be an even integer - returning original input.';
    disp(str);
    y=v;
    return;
end

if(round(its)~=its)
    str=sprintf('WaveletShrinkage: The number of iterations its must be an integer - returning original input.');
    disp(str);
    y=v;
    return;
end;

if its<=0
    str=sprintf('SureShrink: The number of iterations its must be a positive integer - returning original input.');
    disp(str);
    y=v;
    return;
end;

if isvector(v)
    maxits=MaxIterations(length(v));
else
    [r c]=size(v);
    maxits=min(MaxIterations(r),MaxIterations(c));
end

if(its > maxits)
    str=sprintf('WaveletShrinkage: The number of iterations (%i) is larger than the maximum iterations (%i) allowed for the input.  Returning the original input.',i,maxits);
    disp(str);
    y=v;
    return;
end;

if isvector(v)
    wt=WT1D(v,h,its);
    wtlist=WaveletVectorToList(wt,its);
    if length(lambda)==1 || length(lambda)==its
        if length(lambda)==1
            lambda=lambda*ones(1,its);
        end
        for j=1:its
            wtlist(j).hp=ShrinkageFunction(wtlist(j).hp,lambda(j));
        end
        wt=WaveletListToVector(wtlist,its);
        y=IWT1D(wt,h,its);
        return;
    else
        str=sprintf('WaveletShrinkage: Lambda must either be a scalar or a row or column vector with length %i.  Returning the original input.',its);
        disp(str);
        y=v;
        return;
    end;
else
    wt=WT2D(v,h,its);
    wtlist=WaveletMatrixToList(wt,its);
    if length(lambda)==1 || max(size(lambda)-[its 3])==0
        if length(lambda)==1
            lambda=lambda*ones(its,3);
        end
        
        for j=1:its
            for k=1:3
                wtlist(j,k).hp=ShrinkageFunction(wtlist(j,k).hp,lambda(j,k));
            end
        end
        wt=WaveletListToMatrix(wtlist,its);
        y=IWT2D(wt,h,its);
        return;
    else
        str=sprintf('WaveletShrinkage: Lambda must either be a scalar or a matrix of size %i x 3.  Returning the original input.',its);
        disp(str);
        y=v;
        return;
    end;
end
 
    
   
        