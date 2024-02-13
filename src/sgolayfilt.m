function smoothed_data = sgolayfilt(input_data, order, framelen, mode, trst, cval)
% designs a Savitzky-Golay Finite Impulse Response (FIR) smothing filter with polynomial order order and frame lenght framelen.
% INPUTS:
% input_data -- data to be smoothed
% order -- polynomial order positive odd integer
% framelen -- Frame lenght, specified as a positive odd integer. it Must be greater than order.
% mode -- 'mirror'   Repeats the values at the edges in reverse order. The value closest to the edge is not included.
%      -- 'nearest'  The extension contains the nearest input value.
%      -- 'constant' The extension contains the value given by the cval argument.
%      -- 'wrap'     The extension contains the values from the other end of the array.
%      -- 'classic'  Use transient for edges, steady at frame_half_len
%      -- 'default'  Use of transient for edges, steady at frame_half_len+1
% trst -- transient "yes" or "no" wether to use transient reconstruction for edges at begin and end for mode != classic and default. default "yes".
% cval Value to fill past the edges of the input if mode is ‘constant’. Default is 0.0.
% OUTPUTS:
% smoothed_data -- filtered data
    arguments
        input_data {mustBeNumeric, mustBeReal}
        order    (1,1) double {mustBeNumeric, mustBeReal, mustBePositive, mustBeGreaterThanOrEqual(order,0)}
        framelen (1,1) double {mustBeNumeric, mustBeReal, mustBePositive, mustBeGreaterThan(framelen,order)}
        mode     (1,:) char   {mustBeMember(mode,{'mirror','constant','nearest','wrap','classic','default'})} = 'default'
        trst     (1,:) char   {mustBeMember(trst,{'yes','no'})} = 'yes'
        cval     (1,1) double {mustBeNumeric, mustBeReal} = 0.
    end
    
    [FIRFiltersCoeff, MatrixOfDiffFilter, frame_half_len] = SavitzkyGolayFIR( order, framelen);
    if length(size(input_data)>1)
        if size(input_data,1)<size(input_data,2)
            padded_data = input_data';
        else
            padded_data = input_data;
        end
    else
        padded_data = input_data;
    end
    begin = 1;
    if ~strcmp(mode, 'default') & ~strcmp(mode, 'classic') %if mode!='default'
        switch mode
          case 'mirror'
            nb = input_data( begin + 1);
            ne = input_data( end - 1);
          case 'constant'
            nb = cval;
            ne = cval;
          case 'nearest'
            nb = input_data( begin);
            ne = input_data( end);
          case 'wrap'
            nb = input_data( end - 1 + 1);
            ne = input_data( begin + 1 - 1);
        end
        for i = 2:frame_half_len
            switch mode
              case 'mirror'
                nb = [input_data( begin + i); nb];
                ne = [ne; input_data( end - i)];
              case 'constant'
                nb = [cval; nb];
                ne = [ne; cval];
              case 'nearest'
                nb = [input_data( begin); nb];
                ne = [ne; input_data( end)];
              case 'wrap'
                nb = [input_data( end - i + 1); nb];
                ne = [ne; input_data( begin + i - 1)];
            end
        end
        padded_data = [nb; padded_data; ne];
        switch trst
          case 'no'
            smoothed_data = conv( padded_data, FIRFiltersCoeff( frame_half_len+1, :), 'valid');
          case 'yes'
            steady = conv( padded_data, FIRFiltersCoeff( frame_half_len+1, :), 'valid');
            ybeg = FIRFiltersCoeff( begin:frame_half_len,:) * padded_data( begin:framelen);
            yend = FIRFiltersCoeff( framelen - frame_half_len + 1:framelen, :) * padded_data(end - framelen + 1: end);
            smoothed_data = steady;
            smoothed_data( begin:frame_half_len) = ybeg;
            smoothed_data( end - frame_half_len +1:end) = yend;
        end
    else
        a = 0;
        if strcmp(mode, 'default')
            a = 1;
        end
        steady = conv( padded_data, FIRFiltersCoeff( frame_half_len+a, :), 'same');
        ybeg = FIRFiltersCoeff( begin:frame_half_len,:) * padded_data( begin:framelen);
        yend = FIRFiltersCoeff( framelen - frame_half_len + 1:framelen, :) * padded_data(end - framelen + 1: end);
        smoothed_data = steady;
        smoothed_data( begin:frame_half_len) = ybeg;
        smoothed_data( end - frame_half_len +1:end) = yend;
    end %end if mode!='default'
end
