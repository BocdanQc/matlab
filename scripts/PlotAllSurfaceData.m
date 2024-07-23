function PlotAllSurfaceData(surfaces, samplesize, surfacenames, isdocked)
%function PlotAllSurfaceData(surfaces, samplesize, surfacenames, isdocked)
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

    oldstyle = get(0, 'DefaultFigureWindowStyle');
    if (nargin < 4 || isdocked)
        set(0, 'DefaultFigureWindowStyle', 'docked');
        newstyle = 'docked';
    else
        set(0, 'DefaultFigureWindowStyle', 'normal');
        newstyle = 'normal';
    end

    if (~exist('surfacenames','var') || isempty(surfacenames) || size(surfaces, 2) ~= size(surfacenames, 2))
        for surface = 1 : size(surfaces, 2)
            PlotSurfaceData(surfaces{surface}, samplesize);
        end
    else
        for surface = 1 : size(surfaces, 2)
            PlotSurfaceData(surfaces{surface}, samplesize, surfacenames{surface});
        end
    end
    if (~strcmp(oldstyle, newstyle))
        set(0, 'DefaultFigureWindowStyle', oldstyle);
    end
end
