function PlotSelectedSurfaceFeatures(features, featurenames, varargin)
%function PlotSelectedSurfaceFeatures(features, featurenames, varargin)
%  DESCRIPTION
%    This function displays a 2D or 3D diagram for the selected surface
%    features for all surfaces.
%  INPUT
%    features: The extracted features for all surfaces.
%    featurenames: The names of the extracted features.
%    varargin: 'Name', value
%              where 'Name' and value are:
%                'Name' = 'axis';     value range = 1 : 3; default = 2
%                  (It relates to the acceleration data axis X, Y, or Z.)
%                'Name' = 'ndims';    value range = 2 : 3; default = 3
%                  (Number of Surface Features to display. 2 or 3 dims.)
%                'Name' = 'feature1'; value range = 1 : 8; default = 2
%                  (1 of 8 Surface Features to display in dimension 1.)
%                'Name' = 'feature2'; value range = 1 : 8; default = 5
%                  (1 of 8 Surface Features to display in dimension 2.)
%                'Name' = 'feature3'; value range = 1 : 8; default = 7
%                  (1 of 8 Surface Features to display in dimension 2.)
%  OUTPUT
%    N/A

    AXIS = ['X', 'Y', 'Z'];

    if (size(features{1}, 2) ~= size(featurenames{1}, 1) || ...
        size(features{1}, 3) ~= size(featurenames{1}, 2))
      error('PlotSelectedSurfaceFeatures: features and featurenames data sizes do not agree.');
    end

    axis = 2;
    ndims = 3;
    feature1 = 2;
    feature2 = 5;
    feature3 = 7;
    if (length(varargin) > 1)
        for argin = 1 : 2 : length(varargin) - 1
            if (strcmp('axis', varargin{argin}))
                axis = varargin{argin + 1};
            elseif (strcmp('ndims', varargin{argin}))
                ndims = varargin{argin + 1};
            elseif (strcmp('feature1', varargin{argin}))
                feature1 = varargin{argin + 1};
            elseif (strcmp('feature2', varargin{argin}))
                feature2 = varargin{argin + 1};
            elseif (strcmp('feature3', varargin{argin}))
                feature3 = varargin{argin + 1};
            end
        end
    end

    i = 1;
    for hue = 0 : 2.0 / (size(features, 2) + 1) : 1.0
        for sat = 1.0 : -0.5 : 0.5
            colors{i} = hsv2rgb([hue, sat, 1]);
            i = i + 1;
        end
    end

    figure('Name', 'Selected Features', 'NumberTitle', 'off');
    for surface = 1 : size(features, 2)
        if (ndims < 3)
            plot(features{surface}(:, axis, feature1), ...
                 features{surface}(:, axis, feature2), ...
                 '.', 'MarkerEdgeColor', colors{surface});
        else
            plot3(features{surface}(:, axis, feature1), ...
                  features{surface}(:, axis, feature2), ...
                  features{surface}(:, axis, feature3), ...
                  '.', 'MarkerEdgeColor', colors{surface});
        end
        hold on;
    end

    title(['Selected Features of axis ', AXIS(axis), ' for all surfaces']);
    xlabel(featurenames{1}(axis, feature1));
    ylabel(featurenames{1}(axis, feature2));
    zlabel(featurenames{1}(axis, feature3));
end
