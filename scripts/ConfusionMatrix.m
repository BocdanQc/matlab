function cm = ConfusionMatrix(actual, predicted, option)
%function cm = ConfusionMatrix(actual, predicted, option)
%  DESCRIPTION
%    This function will return the confusion matrix either in percentile or
%    in counts based on the given option.
%  INPUT
%    actual: The actual classes.
%    predicted: The predicted classes.
%    option: Either 'percentile' or 'count' to format the content of the
%            confusion matrix.
%  INPUT
%    cm: The confusion matrix.

    if (nargin < 3 || ~strcmp(option, 'count'))
        option ='percentile';
    end
    test = size(predicted);
    if (size(predicted) ~= size(actual))
      size(predicted)
      size(actual)
      error('ConfusionMatrix: actual and predicted data sizes do not agree.');
    end
  
    sizecm = max(max(predicted), max(actual));
    cm = zeros(sizecm, sizecm);
    for index = 1 : size(actual, 2)
        cm(actual(index), predicted(index)) = cm(actual(index), predicted(index)) + 1;
    end
    
    if (strcmp(option, 'percentile'))
        for index = 1 : sizecm
          cc(index) = 1 / sum(actual == index);
          cm(index, :) = cm(index, :) .* cc(index);
        end
    end
end
