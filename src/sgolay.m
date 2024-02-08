order = 5
framelen = 7
[vander_obj, frame_half_len] = savgolay(order, framelen)
display(vander_obj)
display(frame_half_len)
s = fliplr(vander(0.5*(1-framelen):0.5*(framelen-1)));
display(s)

S = s(:,framelen:-1:framelen-order)
display(S)

S = s(:,1:order)
display(S)

function [vander_obj, frame_half_len] = savgolay(order, framelen)
% designs a Savitzky-Golay Finite Impulse Response (FIR) smothing filter with polynomial order order and frame lenght framelen.
% INPUTS:
% order -- polynomial order positive odd integer
% framelen -- Frame lenght, specified as a positive odd integer. it Must be greater than order.
%
% OUTPUTS:
% b -- Time-varying FIR filter coefficiants (matrix)
% g -- Matrix of differentiation filters (matrix)
arguments
    order (1,1) double {mustBeNumeric, mustBeReal, mustBePositive, mustBeGreaterThanOrEqual(order,0)}
    framelen (1,1) double {mustBeNumeric, mustBeReal, mustBePositive, mustBeGreaterThan(framelen,order)}
end

% framelen rounding case
if mod(framelen,1) ~= 0
    framelen = round(framelen);
    warning("framelen was rounded to the nearest integer.");
end

% framelen must be odd
if mod(framelen,2) ~= 1
    warning("framelen must be odd, provided framelen was not odd. Continuing with framelen = framelen + 1");
    framelen = framelen + 1;
end

% order rounding case
if mod(order,1) ~= 0
    order = round(order);
    warning("order was rounded to the nearest integer.");
end

% Getting frame half lenght
frame_half_len = (framelen - 1) / 2;
% Creating Vandermonde Matrix
vander_obj = fliplr(vander(-frame_half_len:frame_half_len));
frame_half_len;
end
