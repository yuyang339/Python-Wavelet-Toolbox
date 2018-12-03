function y=SureShrink(v,h,its)
%SureShrink takes a vector or matrix, an orthogonal filter, and a 
%number of iterations for the wavelet transform and uses the Sureshrink 
%tolerance with Algorithm 9.1 to return a denoised version of the input.

if ~isvector(h)
    str='SureShrink: The input filter must be a row vector or a column vector - returning original input';
    disp(str);
    y=v;
    return;
end

if mod(length(h),2)~=0
    str='SureShrink: The input filter length must be an even integer - returning original input.';
    disp(str);
    y=v;
    return;
end

if(round(its)~=its)
    str=sprintf('SureShrink: The number of iterations its must be an integer - returning original input.');
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
    str=sprintf('SureShrink: The number of iterations (%i) is larger than the maximum iterations (%i) allowed for the input.  Returning the original input.',i,maxits);
    disp(str);
    y=v;
    return;
end;

if isvector(v)
    wt=WT1D(v,h,its);
    wtlist=WaveletVectorToList(wt,its);
    sigma=MAD(wtlist(1).hp)/.6745;
    for j=1:its
        [lambda,flag]=TestSparseness(wtlist(j).hp);
        if flag==1 %wtlist(j).hp is not sparse - use sureshrink threshold
            wtlist(j).hp=wtlist(j).hp/sigma;
        end
        wtlist(j).hp=ShrinkageFunction(wtlist(j).hp,lambda);
        if flag==1
            wtlist(j).hp=wtlist(j).hp*sigma;
        end
    end
    wt=WaveletListToVector(wtlist,its);
    y=IWT1D(wt,h,its);
else
    wt=WT2D(v,h,its);
    wtlist=WaveletMatrixToList(wt,its);
    tmp=[wtlist(1,1).hp wtlist(1,2).hp wtlist(1,3).hp];
    sigma=MAD(tmp)/.6745;
    for j=1:its
        for k=1:3
            [lambda,flag]=TestSparseness(wtlist(j,k).hp);
            if flag==1 %wtlist(j,k).hp is not sparse - use sureshrink
                wtlist(j,k).hp=wtlist(j,k).hp/sigma;
            end
            wtlist(j,k).hp=ShrinkageFunction(wtlist(j,k).hp,lambda);
            if flag==1
                wtlist(j,k).hp=wtlist(j,k).hp*sigma;
            end
        end
    end
    wt=WaveletListToMatrix(wtlist,its);
    y=IWT2D(wt,h,its);
end
 
    
   
        