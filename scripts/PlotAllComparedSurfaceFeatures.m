function PlotAllComparedSurfaceFeatures(features1, features2, features1names, surfacenames, isdocked)
%function PlotAllComparedSurfaceFeatures(features1, features2, features1names, surfacenames, isdocked)
%  DESCRIPTION
%    This function displays the 2D representation of each acceleration axis
%    in time and the 3D representation of the 3 acceleration axis together
%  INPUT
%    surfaces: An array of 1 x N surfaces data (accelerations) to display.
%    samplesize: The number of acceleration samples to display.
%    surfacename: An array of 1 x N names of the surfaces.
%    isdocked: [Optional] If true, it will dock all the figures in the
%              figures window. The default value is true.
%  OUTPUT
%    N/A

    if (size(features1, 2) ~= size(features2, 2) || ...
        size(features2, 2) ~= size(features1names, 2))
      error('PlotAllComparedSurfaceFeatures: features1, features2 and featurenames data sizes do not agree.');
    end

    oldstyle = get(0, 'DefaultFigureWindowStyle');
    if (nargin < 5 || isdocked)
        set(0, 'DefaultFigureWindowStyle', 'docked');
        newstyle = 'docked';
    else
        set(0, 'DefaultFigureWindowStyle', 'normal');
        newstyle = 'normal';
    end

    if (~exist('surfacenames','var') || isempty(surfacenames) || size(features1, 2) ~= size(surfacenames, 2))
        for surface = 1 : size(features1, 2)
            PlotComparedSurfaceFeatures(features1{surface}, features2{surface}, features1names{surface});
        end
    else
        for surface = 1 : size(features1, 2)
            PlotComparedSurfaceFeatures(features1{surface}, features2{surface}, features1names{surface}, surfacenames{surface})
        end
    end
    if (~strcmp(oldstyle, newstyle))
        set(0, 'DefaultFigureWindowStyle', oldstyle);
    end
end
