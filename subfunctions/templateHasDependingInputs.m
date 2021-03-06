function varargout = templateHasDependingInputs( varargin )
%TEMPLATEHASDEPENDINGINPUTS checks node template for input depending parameters
%
% This function returns if a given template obtains input parameters, which depend
% on the number of input signals and/or input signal size.
%
% INPUT:    (1) Index of node in mtids
%           (2) mtids structure 'data'
%
% OUTPUT:   (2) Boolean: true (1) or false (0)
%
% Author: Ferdinand Trommsdorff (f.trommsdorff@gmail.com)
% Project: MTIDS (http://code.google.com/p/mtids/)

nodeIDX     = varargin{1}; %#ok<NASGU>
template    = varargin{2};

%Tests not only Linear depending INPUT parameters, but also Linear
%depending OUTPUT parameters (PDK)

if any( ~cellfun( @isempty, template{ 1,2 }.inputSpec.Vars ) )
    varargout{1} = 1;
elseif any( ~cellfun( @isempty, template{ 1,2 }.inputSpec.VarsOutput ) )
    varargout{1} = 1;
else
    varargout{1} = 0;
end