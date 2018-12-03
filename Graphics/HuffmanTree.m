function HuffmanTree(uniq,freq,codes,varargin)
%HuffmanTree takes a cell array uniq of unique characters (or integers), a
%vector freq of relative frequencies of uniq, and a cell array codes that
%hold the Huffman codes of the elements of uniq, and plots the Huffman
%tree.  The inputs uniq, freq, and codes, are presumably obtained from the 
%function MakeHuffmanCodes.  HuffmanTree will work well if numel(uniq)<=10.  
%
%There are several optional arguments for controlling the display:
%
%'NodeColor' - a vector of length three that sets the color for the
%nodes (default is [.698 .557 .18]).
%
%'NodeEdgeColor' - a vector of length three that sets the color for the
%edges of the nodes (default is [0 0 0]).
%
%'NodeSize' - this positive value sets the size of the node (in pixels).
%The default is 30.
%
%'NodeFontSize' - this positive value sets the font size for labeling
%branches and nodes.  The default is 8.
%
%'FontColor' - a vector of length three that sets the color for the
%font used to label branches and nodes (default is [.541 .118 .008]).
%
%'BranchColor' - a vector of length three that sets the color for the
%branches (default is [.698 .557 .18]).
%
%'Title' - A string that serves as the title of the plot.
%
%Example Calls:
%
%HuffmanTree(uniq,freq,codes,'Title','mississippi') - puts the title
%'mississippi' at the top of the plot.
%
%HuffmanTree(uniq,freq,codes,'BranchColor',[1 0 0],'FontColor',[0 0 1]) -
%sets the color of the branches to red and all text is displayed in blue.
%

opts={'NodeColor','NodeEdgeColor','NodeSize','NodeFontSize','FontColor','BranchColor','Title'};
vals={[.698 .557 .18],[0 0 0],30,8,[.541 .118 .008],[.698 .557 .18],''};

len=length(varargin);
if mod(len,2)~=0
    len=len-1;
end

nms=cell(len);

for k=1:len/2
    nms{k}=varargin{2*k-1};
end

for k=1:len/2
    t=ismember(opts,nms{k});
    [dum,idx]=max(t);
    if dum~=0
        vals{idx}=varargin{2*k};
    end
end

if length(codes)==1
    treeplot(0);
    return;
end

if length(codes)==2
    treeplot([0 1 1]);
    return;
end

for k=1:2
    if length(vals{k})~=3
        str=sprintf('HuffmanTree: %s must be a length three vector.',opts{k});
        disp(str);
        return;
    end

    if max(vals{k}>1)==1 || max(vals{k}<0)==1
        str=sprintf('HuffmanTree: The values of %s must be in the interval [0,1].',opts{k});
        disp(str);
        return;
    end
end

for k=3:4
    if vals{k}<=0
        str=sprintf('HuffmanTree: %s must be a positive integer.',opts{k});
        disp(str);
        return;
    end
end

for k=5:6
    if length(vals{k})~=3
        str=sprintf('HuffmanTree: %s must be a length three vector.',opts{k});
        disp(str);
        return;
    end

    if max(vals{k}>1)==1 || max(vals{k}<0)==1
        str=sprintf('HuffmanTree: The values of %s must be in the interval [0,1].',opts{k});
        disp(str);
        return;
    end
end

if ~ischar(vals{7})
    vals{7}='';
end

lvls=max(cellfun(@length,codes))+1;
N=2^lvls-1;
v=zeros(1,N);
lbls=cell(1,N);
p=zeros(1,N);
for k=1:length(codes)
    t=length(codes{k});
    s=0;
    for j=t-1:-1:0
        s=s+2^j*(codes{k}(t-j)-48);
    end
    v(s+2^t)=s+2^t;
    lbls{s+2^t}=sprintf('  %s\n%3.2f',cell2mat(uniq(k)),round(100*freq(k))/100);
    p(s+2^t)=freq(k);
end

for k=N-1:-2:1
    if v(k)~=0
        v(k/2)=k/2;
        p(k/2)=p(k)+p(k+1);
        lbls{k/2}=sprintf('%3.2f',round(100*p(k/2))/100);
    end
end

v(1)=-1;
nz=find(v);

nodes=zeros(1,length(nz));
txt=cell(1,length(nz));

nodes(1)=v(1);
txt{1}='1.00';
for k=2:length(nz)
    nodes(k)=v(nz(k));
    txt{k}=lbls{nz(k)};
end

for k=2:2:length(nz)
    if nodes(k)==k
        continue;
    else
        idx=find(nodes==nodes(k)/2);
        if nodes(idx)==idx
            continue
        else
            nodes(k)=2*idx;
            nodes(k+1)=2*idx+1;
        end
    end
end

nodes=floor(nodes/2);
nodes(1)=0;
treeplot(nodes);
[x,y] = treelayout(nodes);
hdl=findall(gcf, 'type', 'line');
set(hdl(2),'MarkerSize',vals{3},'MarkerFaceColor',vals{1},'MarkerEdgeColor',vals{2});
set(hdl(1),'Color',vals{6});
title(vals{7});
for k=1:length(nodes)
    offset=x(k)-.015;
    text(offset,y(k),txt{k},'FontSize',vals{4},'Color',vals{5});
end

for k=2:length(nodes)
    m=(y(k)-y(nodes(k)))/(x(k)-x(nodes(k)));
    xloc=(x(k)+x(nodes(k)))/2;
    yloc=(y(k)+y(nodes(k)))/2;
    if m<0
        b='1';
        xoff=.02;
    else
        b='0';
        xoff=-.02;
    end
    text(xloc+xoff,yloc,b,'FontSize',vals{4},'Color',vals{5});
end

