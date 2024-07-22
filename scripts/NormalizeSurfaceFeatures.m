function normalizedfeatures = NormalizeSurfaceFeatures(features, factors)
%function normalizedfeatures = NormalizeSurfaceFeatures(features, factors)
%  DESCRIPTION
%    This function normalizes given features using the given normalization
%    factors.
%  INPUT
%    features: The features to normalize.
%    factors: The features' normalization factors.
%  OUTPUT
%    normalizedfeatures: The normalized features.
    normalizedfeatures = features .* (ones(size(features, 1), 1) * factors);
end
