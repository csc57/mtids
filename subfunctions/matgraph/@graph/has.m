function yn = has(g,u,v,dir)
% has --- check if the graph has a particular vertex or edge
% has(g,u) --- check if g contains the vertex u
% has(g,u,v) --- check if g contains the edge uv
% has(g,u,v,dir) -- treats 'g' as directed

global GRAPH_MAGIC;

if nargin < 4
    dir = 0;
end

n = nv(g);

if (nargin==2)
    yn = (u>0) & (u<=n);
elseif nargin == 3
    if (u<0) || (u>n) || (v<0) || (v>n) || (u==v)
        yn = 0;
    else
        yn = GRAPH_MAGIC.graphs{g.idx}.array(u,v);
    end
elseif (nargin == 4 && dir == 1) %it's useless, the function works well for directed graphs too
    if (u<0) || (u>n) || (v<0) || (v>n) || (u==v)
        yn = 0;
    else
        yn = GRAPH_MAGIC.graphs{g.idx}.array(u,v);
    end
end
