function PlotComparedSurfaceFeatures(features1, features2, features1names, surfacename)
%function PlotComparedSurfaceFeatures(features1, features2, features1names, surfacename)
%  DESCRIPTION
%    This function display the comparison between 2 sets of extracted
%    features for a surface. The number of axis and features for both sets
%    of features, as well as the number of features names must match.
%  INPUT
%    features1: First set of features to compare.
%    features2: Second set of features to compare.
%    features1names: The names of the features to compare.
%    surfacename: [Optional] The name of the surface for both set of features.
%  OUTPUT
%    N/A

    AXIS = ['X', 'Y', 'Z'];

    if (size(features1, 2) ~= size(features2, 2)      || ...
        size(features1, 3) ~= size(features2, 3)      || ...
        size(features2, 2) ~= size(features1names, 1) || ...
        size(features2, 3) ~= size(features1names, 2))
      error('PlotComparedFeatures: features1, features2 and featurenames data sizes do not agree.');
    end

    if (nargin < 4)
        figure(1);
    else
        figure('Name', ['Surface Features: ', surfacename], 'NumberTitle', 'off');
    end
    clf;

    pos = 1;
    for axis = 1 : size(features1, 2)
        for feature = 1 : size(features1, 3)
            [nf1, xf1] = hist(features1(:, axis, feature));
            [nf2, xf2] = hist(features2(:, axis, feature));
            subplot(3, 8, pos);
            plot(xf1, nf1, '-r');
            hold on
            plot(xf2, nf2, '-g');

            if (axis == 1)
                title(sprintf('%s\n', string(features1names(axis, feature))), 'FontSize', 8);
            end
            if (feature == 1)
                ylabel(sprintf('%s     ', AXIS(axis)), 'FontSize', 14,'Rotation', 0);
            end
            
            pos = pos + 1;
        end
    end
end
