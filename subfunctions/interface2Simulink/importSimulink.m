function[A, nverts, nedges, xy, labs ] = importSimulink(model)

% importSimulink.m :  
% Authors: Jose Rivera, Francisco Llobet 
% Project: MTIDS
% Created: 27/5/2011
% 
%                        input: modelName as a string 'model'
%                     output: A: Adjacense matrix,
%                             nverts: Number of vertices (Nodes)
%                             nedges: Number of edges (branches/links)
%                             xy: Position of the nodes
%                             
% 
% This function extract the data needed from mtids of a simulink model.
% The model has to contain only subsystem blocks on the first layer.
% As graphs in mtids are undirected, each link are two connection between subsystems.
% Example: model with two Subsystems: Subsystem1 and Subsystem2.
% We want a link between both subsystems. For this the output of Subsystem1 has to go into the 
% input1 of Subsystem2 and the output of Subsystem2 has to go into input2 of Subsystem1. 


%% get subsystem handles of open model 
%sys=model;
load_system(model);
subsystemBlk = find_system(model, 'regexp', 'on', 'blocktype', 'SubSystem');
subsystemBlk = find_system(subsystemBlk,'parent',model);
% number of vertices
nverts = length(subsystemBlk); % vertices

% sorting cell array
temp= subsystemBlk(1:2) ;
for i=1:floor(nverts/10-1)
   if i== floor(nverts/10-1)
       temp={temp{:} subsystemBlk{2+i+i*10 :end}};
   else
    temp={temp{:} subsystemBlk{2+i+i*10}};
   end
    
end

for i=1:length(subsystemBlk)
    
    new= subsystemBlk{i};
    if all(strcmp(new,temp)==0)
        
   temp={temp{:}   subsystemBlk{i}};
    end
    
end

% end of sorting the array 
subsystemBlk=temp;
 nameList= get_param(subsystemBlk,'Name') ;
 labs=nameList';

%% getting connection information of each port, name and position
% a connects to b
nedges= 0 ;
xy=zeros(nverts,2);


A=zeros(length(subsystemBlk),length(subsystemBlk));

for i=1: length(subsystemBlk)
  
   
     xy(i,:) = blockPos( get_param(subsystemBlk{i},'position') );

    
conPort=get_param(subsystemBlk{i},'PortConnectivity');


for j= 1: length(conPort)

    if(j~=i )
               
        if conPort(j).SrcBlock ~=-1  % if Block destination Block is not empty..we got a connection
           nedges= nedges + 1 ;
           
          fromBlock=    get_param(conPort(j).SrcBlock,'Name') ; 
          
         k = find( strcmp(fromBlock,labs)==1) ;

                  A(i,k)=1;
               
          
            
        end
      
    end


end
end
nedges= nedges/2;
close_system(model,0);


