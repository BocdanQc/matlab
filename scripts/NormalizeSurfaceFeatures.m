function [normfeatures, normfeaturelabels, normfactors] = NormalizeSurfaceFeatures(features, featurenames, normfactors)
%function [normfeatures, normfeaturelabels, normfactors] = NormalizeSurfaceFeatures(features, featurenames, normfactors)
%  DESCRIPTION
%    This function normalizes given features for classification.
%  INPUT
%    features : An array of N extracted surface features.
%    featurenames: An array of N surface feature names based on the features above.
%    normfactors: [optional] The normalization factors used to normalize the features data.
%                 If not given, new normalization factors will be computed.
%  OUTPUT
%    normfeatures: A N x 21 (7 features x 3 axis) matrix of normalized features
%                  for all the given surfaces. The 'Mean' is not kept to avoid angle
%                  bias between disk sampling.
%    normfeatureslabels: The N ground truth labels for features data above.
%    normfactors: The normalization factors used to normalize the features data.

    %% Concatenate the same feature across all surfaces and compute the normalization factors for each feature
    featureindex = 1;
    for axis = 1 : size(features{1}, 2)
        % Feature 1 is the mean and must be removed to avoid angle bias between disk sampling.
        for feature = 2 : size(features{1}, 3)
            disp(['Concatenating the ', featurenames{axis}{feature}, ' of axis ', num2str(axis), ' for all surfaces']);
            concatenatedfeatures = [];
            % Concatenate the same feature by axis across all surfaces
            for surface = 1 : size(features, 2)
                concatenatedfeatures = [concatenatedfeatures features{surface}(:, axis, feature)'];
            end

            % Compute a normalization factor over the whole set
            disp(['Computing the ', featurenames{axis}{feature}, ' normalization factor of axis ', num2str(axis), ' for all surfaces']);
            factor = 1 ./ std(concatenatedfeatures);

            normfeatures(:, featureindex) = concatenatedfeatures;
            factors(featureindex) = factor;
            featureindex = featureindex + 1;
        end
    end
    if (nargin < 3)
        normfactors = factors;
    end
    disp('Features normalization');
    normfeatures = normfeatures .* (ones(size(normfeatures, 1), 1) * normfactors);
    
    %% Ground Truth information for the samples
    normfeaturelabels = [];
    for surface = 1 : size(features, 2)
        normfeaturelabels = [normfeaturelabels (surface * ones(1, size(features{surface}, 1)))];
    end
end
