function svmmodel = TrainSVMWithSurfaceFeatures(features, featureslabels, varargin)
%function svmmodel = TrainSVMWithSurfaceFeatures(features, featureslabels)
%  DESCRIPTION
%    This function will first do a refined Grid Search for the parameters C
%    and Gamma with 10-fold Cross Validation to determine the best values to
%    used to train libsvm. It will also do another 10-fold Cross validation
%    with the current best C parameter and with Gamma = 1 / number of
%    features. It will then use these results to create a model to do
%    predictions based on the training data.
%    
%    The refined Grid Search will be with these value range:
%       C = 2^2 to 2^4 with an exponent increment of 0.25
%       Gamma = 2^-6 to 2^-4 with an exponent increment of 0.25
%    where
%       C:     Regularization Parameter
%              It controls the trade-off between misclassification of training
%              examples and the simplicity of the decision surface.
%              * A small value of C allows the SVM to find a larger-margin
%                separating hyperplane, even if it means some misclassifications
%                in the training data (high bias, low variance).
%              * A large value of C aims to classify all training examples
%                correctly, potentially leading to a smaller-margin hyperplane
%                (low bias, high variance), which may overfit the training data
%                and perform poorly on unseen data.
%       Gamma: Kernel Parameter -> Radial Basis Function (RBF) kernel function
%                          K(x, x') = exp(-Gamma ||x - x'||^2)
%              It controls the influence of individual training examples on the
%              decision boundary
%              * A low value of Gamma means a large radius for the decision
%                boundary, resulting in a smoother, less complex decision surface.
%                This can lead to underfitting if the value is too low.
%              * A high value of Gamma creates a decision boundary that is more
%                sensitive to individual data points, leading to a more complex
%                decision surface. This can result in overfitting if the value
%                is too high.
%
%    Note: A coarse Grid Search was previously tested with C = 2^-5 to 2^15
%          and Gamma = 2^-15 to 2^3, both with an exponent increment of 1).
%    
%  INPUT
%    features: The features used to train libsvm
%    featureslabels: The labels (classes) of the features used to train
%                    libsvm.
%    varargin: 'Name', value
%              where 'Name' and value are:
%                'Name' = 'C';     value range = 2^-5 to 2^15; default = 0
%                  (If 0, the best C value will be searched)
%                'Name' = 'Gamma'; value range = 2^-15 to 2^3; default = 0
%                  (If 0, the best Gamma value will be searched)
%  OUTPUT
%    svmmodel: The model provided by libsvm based on the given features.

    %% Ensures the labels are in the right format for svmtrain of libsvm
    if (size(featureslabels, 1) == 1)
        featureslabels = featureslabels';
    end

    bestc = 0;
    bestgamma = 0;
    %% Validate the variable inputs
    if (length(varargin) > 1)
        for argin = 1 : 2 : length(varargin) - 1
            if (strcmp('C', varargin{argin}))
                bestc = varargin{argin + 1};
            elseif (strcmp('Gamma', varargin{argin}))
                bestgamma = varargin{argin + 1};
            end
        end
    end
    
    %% Refined Grid Search for C and Gamma with 10-fold Cross Validation
    bestrate = 0.0;
    if (bestc == 0 && bestgamma == 0)
        disp('--- Refined Grid Search for C and Gamma with 10-fold Cross Validation ---');
        for i = 2 : 0.25 : 4
            c = 2 ^ i;
            for j = -6 : 0.25 : -4
                gamma = 2 ^ j;
                disp('Validating:')
                fprintf('\tC     = %-.5f\n', c);
                fprintf('\tGamma = %-.5f\n', gamma);
                rate = svmtrain(featureslabels, features, ['-v 10 -c ', num2str(c), ' -g ', num2str(gamma)]);
                disp('****************************************');
                % It is better to get the smallest Gamma possible in the case of equal best rate.
                if (rate > bestrate || (rate == bestrate && gamma < bestgamma))
                    bestrate = rate;
                    bestc = c;
                    bestgamma = gamma;
                end
            end
        end
    elseif (bestgamma == 0)
        disp('--- Refined Grid Search for Gamma only with 10-fold Cross Validation ---');
        for j = -6 : 0.25 : -4
            gamma = 2 ^ j;
            disp('Validating:')
            fprintf('\tC     = %-.5f\n', bestc);
            fprintf('\tGamma = %-.5f\n', gamma);
            rate = svmtrain(featureslabels, features, ['-v 10 -c ', num2str(bestc), ' -g ', num2str(gamma)]);
            disp('****************************************');
            if (rate > bestrate)
                bestrate = rate;
                bestgamma = gamma;
            end
        end
    elseif (bestc == 0)
        disp('--- Refined Grid Search for C only with 10-fold Cross Validation ---');
        for i = 2 : 0.25 : 4
            c = 2 ^ i;
            disp('Validating:')
            fprintf('\tC     = %-.5f\n', c);
            fprintf('\tGamma = %-.5f\n', bestgamma);
            rate = svmtrain(featureslabels, features, ['-v 10 -c ', num2str(c), ' -g ', num2str(bestgamma)]);
            disp('****************************************');
            if (rate > bestrate)
                bestrate = rate;
                bestc = c;
            end
        end
    end
    
    %% Creating the SVM model based on the best C and Gamma found
    disp('--- Applying the values of C and Gamma to the full data set through the SVM trainer ---')
    disp('The values are:');
    fprintf('\tC     = %-.5f\n', bestc);
    fprintf('\tGamma = %-.5f\n', bestgamma);
    svmmodel = svmtrain(featureslabels, features, ['-c ', num2str(bestc), ' -g ', num2str(bestgamma)]);
    disp('****************************************');
end
