function [argout] = initPlotParams( dim )
%INITPLOTPARAMS
% -- this function initializes the plot parameters for a node
% output is a (1+n) element struct containing six elements, where
%n is the amount of internal states to plot. At start of mtids, n=1 for
%each node
for kk = 1:dim
    plotParams(kk).lineWidth = '1.0'; %#ok<*AGROW>
    plotParams(kk).lineStyle = '-';
    plotParams(kk).marker = 'none';
    plotParams(kk).lineColor = [0 0 1];
    plotParams(kk).edgeColor = [0 0 1];
    plotParams(kk).faceColor = [0 0 1];
end
%at start of mtids, no int. states should be plotted, thus no 2nd struct
%exists
argout = plotParams;