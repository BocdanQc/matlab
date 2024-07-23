function PlotSelectedSurfaceFeatures(features, featurenames, varargin)
%function PlotSelectedSurfaceFeatures(features, featurenames, varargin)
%  DESCRIPTION
%    This function extracts all 8 surface features
%  INPUT
%    features: The extracted features for all surfaces.
%    featurenames: The names of the extracted features.
%    varargin: 'Name', value
%              where 'Name' and value are:
%              'Name' = 'axis';     value range = 1:3
%              'Name' = 'featurex'; value range = 1:8
%              'Name' = 'featurey'; value range = 1:8
%              'Name' = 'featurez'; value range = 1:8
%  OUTPUT

% Line Style = - : solid line, -- : dashed line, : : Dotted line, -. : Dash-dot line
% Colors     = y : yellow, m : magenta, c : cyan, r : red, g : green, b : blue, w : white, k : black
% Markers    = o : circle, + : plus sign, * : asterisk, . : point, x : cross, s : square, d : diamond,
%              ^ : upward triangle, v : downward triangle, > : right triangle, < : left triangle
%              p : pentagram, h : hexagram
    SYMBOLS = {'r+', 'g+', 'b+', 'y+', 'm+', 'c+' ...
               'ro', 'go', 'bo', 'yo', 'mo', 'co' ...
               'rx', 'gx', 'bx', 'yx', 'mx', 'cx' ...
               'r*', 'g*', 'b*', 'y*', 'm*', 'c*' ...
               'rs', 'gs', 'bs', 'ys', 'ms', 'cs' ...
               'rd', 'gd', 'bd', 'yd', 'md', 'cd'};
    AXIS = ['X', 'Y', 'Z'];

    if (size(features{1}, 2) ~= size(featurenames{1}, 1) || ...
        size(features{1}, 3) ~= size(featurenames{1}, 2))
      error('PlotSelectedSurfaceFeatures: features and featurenames data sizes do not agree.');
    end

    axis = 2;
    featurex = 1;
    featurey = 2;
    featurez = 8;
    for argin = 1 : 2 : length(varargin) - 1
        if (strcmp('axis', varargin{argin}))
            axis = varargin{argin + 1};
        elseif (strcmp('featurex', varargin{argin}))
            featurex = varargin{argin + 1};
        elseif (strcmp('featurey', varargin{argin}))
            featurey = varargin{argin + 1};
        elseif (strcmp('featurez', varargin{argin}))
            featurez = varargin{argin + 1};
        end
    end
    
    figure('Name', 'Selected Features', 'NumberTitle', 'off');
    for surface = 1 : size(features, 2)
        plot3(features{surface}(:, axis, featurex), features{surface}(:, axis, featurey), features{surface}(:, axis, featurez), SYMBOLS{surface});
        hold on;
    end
    title(['Selected Features of axis ', AXIS(axis), ' for all surfaces']);
    xlabel(featurenames{1}(axis, featurex));
    ylabel(featurenames{1}(axis, featurey));
    zlabel(featurenames{1}(axis, featurez));
end
