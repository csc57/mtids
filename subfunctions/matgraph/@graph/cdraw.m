function cdraw(g,dir,coloring,line_style,color_matrix)
% cdraw(g,dir,coloring) -- draw g with a given vertex coloring
% If no coloring is specified, the default is 'greedy'. If "dir" is not
% set, the graph will be treated as undirected.
%
% cdraw(g,dir,coloring,line_style) --- lines have given line_style. If this is
% not given, the style '-' is used (solid lines). Try ':' for dotted lines.
%
% cdraw(g,dir,coloring,line_style,color_matrix) --- specify the colors for the
% vertices. color_matrix is an nc-by-3 matrix of RGB values where nc is the
% number of colors in the coloring. The default is hsv(nc). 
%
% color_matrix can also be a string of MATLAB color specifiers, e.g., 
% cdraw(g,color(g),'-','kwrgb') will draw vertices in color class 1 with
% color 'k' (black), vertices in color class 2 'w' (white), etc. 
%
% In either case (matrix or letter string) the user must make sure the
% matrix contains sufficiently many colors.
% 
% See also draw, ldraw, and ndraw.
%
% Original author: Brian Towne; modifications by ERS.

edge_color = 'k';
vertex_color = 'k';
r = 0.15;

if nargin < 4
    line_style = '-';    
end

if nargin < 3
    coloring = color(g,'greedy');
end

if nargin < 2
    dir = 0; 
end

n = nv(g);
n2 = nv(coloring);

if nargin < 5
    color_matrix = hsv(np(coloring));
end

%step: needed for non-line connection between nodes
step = 0.15;
%min_dist: needed to avoid improper quadratic interpolation parametrization
min_dist = 0.05;
%set arrow parameters
arrLength = 0.10;
arrWidth = 0.08;
arrPos = 92/100; %percent of the length between outgoing and incoming node
%ellSample; iteration steps for drawing the ellipse
ellSteps = 100;

if ~(n==n2)
    error('Graph and coloring must have equal number of vertices.')
end

if ~hasxy(g)
    embed(g);
end

xy = getxy(g);

% first draw the edges
elist = edges(g,dir);
if dir == 0 %interpret graph as undirected
    for j=1:ne(g)
        u = elist(j,1); %from u ...
        v = elist(j,2); % ... to v
        x = xy([u,v],1);
        y = xy([u,v],2);
        line(x,y,'Color', edge_color,'LineStyle',line_style);
    end
end

if dir == 1 % interpret graph as directed
    for j=1:ne(g,dir)
        u = elist(j,1); %from u ...
        v = elist(j,2); % ... to v

        %prepare start and end coordinates
        from = xy(u,:)';
        to = xy(v,:)';
        %vector from outgoing vertex to incoming vertex
        ft = xy(v,:)'-xy(u,:)';
        %prepare the orthogonal of the line connection between both vertices
        ftT = [-ft(2); ft(1)]/norm([-ft(2); ft(1)]);
        %angle of direction vector pointing from outoing to incoming vertex
        ftAngle = atan2(ft(2),ft(1))/pi*180;
        %prepare middle of line connection between both vertices
        middle = 0.5*(xy(u,:)'+xy(v,:)');        
        %line from "from" to "to"
        xlin = linspace(from(1),to(1));
        ylin = linspace(from(2),to(2));
        
        for i = 1:length(xlin)
            alpha = pi/length(xlin)*i;
            temp = step*sin(alpha)*ftT;
            xlin(i) = xlin(i) + temp(1);
            ylin(i) = ylin(i) + temp(2);
        end
        
        line(xlin,ylin,'Color', edge_color,'LineStyle',line_style);
                
        %approximate slope vector for orientation of arrow
        arrVec = (to - [xlin(length(xlin)/2);ylin(length(xlin)/2)])/...
            norm(to - [xlin(length(xlin)/2);ylin(length(xlin)/2)]);       
        %get point of curve, on which the arrow should lie
        atop = [xlin(length(xlin)*arrPos);ylin(length(xlin)*arrPos)];
        
        %first rotation matrix with angle phi
        phi = 5*pi/6;
        R=[cos(phi) -sin(phi); sin(phi) cos(phi)];
        %compute endpoint of one arrow cathetus
        end_point1 = R*arrVec;
        line([atop(1),atop(1)+arrLength*end_point1(1)],...
            [atop(2),atop(2)+arrLength*end_point1(2)],'Color',...
            edge_color,'LineStyle',line_style,'LineWidth',arrWidth);
        %second rotation matrix with angle phi
        phi = -5*pi/6;
        R=[cos(phi) -sin(phi); sin(phi) cos(phi)];
        %compute endpoint of one arrow cathetus
        end_point1 = R*arrVec;
        line([atop(1),atop(1)+arrLength*end_point1(1)],...
            [atop(2),atop(2)+arrLength*end_point1(2)],'Color',...
            edge_color,'LineStyle',line_style,'LineWidth',arrWidth);

    end       
end


% Now draw the vertices by color class
color_classes = parts(coloring);
num_colors = np(coloring);

for i=1:num_colors
    color_class_size = size(color_classes{i},2);
    if ischar(color_matrix)
        vertex_fill = color_matrix(i) ;
    else
        vertex_fill = color_matrix(i,:);
    end
    for j=1:color_class_size
        v = color_classes{i}(j);
        x = xy(v,1);
        y = xy(v,2);
        rectangle('Position', [x-r/2, y-r/2, r, r],...
                  'Curvature', [1 1], ...
                  'EdgeColor', vertex_color, ...
                  'FaceColor', vertex_fill);    
    end
end    

axis equal
axis off
