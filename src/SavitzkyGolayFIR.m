function [FIRFiltersCoeff, MatrixOfDiffFilter, frame_half_len] = SavitzkyGolayFIR(order, framelen)
% designs a Savitzky-Golay Finite Impulse Response (FIR) smothing filter with polynomial order order and frame lenght framelen.
% INPUTS:
% order -- polynomial order positive odd integer
% framelen -- Frame lenght, specified as a positive odd integer. it Must be greater than order.
%
% OUTPUTS:
% b -- Time-varying FIR filter coefficiants (matrix)
% g -- Matrix of differentiation filters (matrix)
% f -- frame half lenght
arguments
    order (1,1) double {mustBeNumeric, mustBeReal, mustBePositive, mustBeGreaterThanOrEqual(order,0)}
    framelen (1,1) double {mustBeNumeric, mustBeReal, mustBePositive, mustBeGreaterThan(framelen,order)}
end

% framelen rounding case
if mod( framelen,1) ~= 0
    framelen = round( framelen);
    warning("framelen was rounded to the nearest integer.");
end

% framelen must be odd
if mod( framelen,2) ~= 1
    warning("framelen must be odd, provided framelen was not odd. Continuing with framelen = framelen + 1");
    framelen = framelen + 1;
end

% order rounding case
if mod( order,1) ~= 0
    order = round(order);
    warning("order was rounded to the nearest integer.");
end

% Get frame half lenght and Vandermonde(-frame_half_len:frame_half_len)
%fliptype = 'fliplr';
fliptype = 'none';
[frame_half_len, vander_obj] = GetVander( framelen, fliptype);

VanderMatrix = vander_obj( :,framelen:-1:framelen - order);

% Compute (B)FIRFiltersCoeff  and (G)MatrixOfDiffFilter
[~,R] = qr( VanderMatrix,0);

MatrixOfDiffFilter = (R'*R)\VanderMatrix';

MatrixOfDiffFilter = VanderMatrix/R/R';

FIRFiltersCoeff = MatrixOfDiffFilter * VanderMatrix';
end

function [frame_half_len, vander_obj] = GetVander( framelen, fliptype)
    arguments
        framelen (1,1) double {mustBeNumeric, mustBeReal, mustBePositive, mustBeGreaterThan(framelen,1)}
        fliptype (1,:) char {mustBeMember(fliptype,{'none','fliplr'})} = 'none'
    end
    frame_half_len = ( framelen - 1) / 2;
    if strcmp( fliptype,'fliplr')
        vander_obj = fliplr( vander( -frame_half_len:frame_half_len));
    else
        vander_obj = vander( -frame_half_len:frame_half_len);
    end
end
