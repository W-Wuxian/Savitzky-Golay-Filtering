%order = 5
%framelen = 7

%[B, G] = SavitzkyGolayFIR(order, framelen)

%display(B)
%display(G)

%s = fliplr(vander(0.5*(1-framelen):0.5*(framelen-1)));
%display(s)
%S = s(:,framelen:-1:framelen-order)
%display(S)

%S = s(:,1:order)
%display(S)

function [FIRFiltersCoeff, MatrixOfDiffFilter] = SavitzkyGolayFIR(order, framelen)
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

% Get frame half lenght and Vandermonde(-frame_half_len:frame_half_len)
%fliptype = 'fliplr';
fliptype = 'none';
[frame_half_len, vander_obj] = GetVander(framelen, fliptype);
display(fliptype);
display(order)
display(framelen);
disp("size(vander_obj):");
display(size(vander_obj));
VanderMatrix = vander_obj(:,framelen:-1:framelen-order);
disp("size(VanderMatrix):");
display(size(VanderMatrix))

% Compute (B)FIRFiltersCoeff  and (G)MatrixOfDiffFilter
[~,R] = qr(VanderMatrix,0);
disp("R:");
display(size(R));
FIRFiltersCoeff = (R'*R)\VanderMatrix';
%FIRFiltersCoeff = R'\R\VanderMatrix'; % R^(-T)R^(-1)H^(T)
                                    % OTHER = vander_obj\R\R';
                                    % display(OTHER):
                                    %FIRFiltersCoeff = VanderMatrix\R\R';
disp("FIRFiltersCoeff:");
display(size(FIRFiltersCoeff));
MatrixOfDiffFilter = VanderMatrix * FIRFiltersCoeff;
%MatrixOfDiffFilter = FIRFiltersCoeff * VanderMatrix;
disp("MatrixOfDiffFilter:");
display(size(MatrixOfDiffFilter))
end

function [frame_half_len, vander_obj] = GetVander(framelen, fliptype)
    arguments
        framelen (1,1) double {mustBeNumeric, mustBeReal, mustBePositive, mustBeGreaterThan(framelen,1)}
        fliptype (1,:) char {mustBeMember(fliptype,{'none','fliplr'})} = 'none'
    end
    frame_half_len = (framelen - 1) / 2;
    if strcmp(fliptype,'fliplr')
        vander_obj = fliplr(vander(-frame_half_len:frame_half_len));
    else
        vander_obj = vander(-frame_half_len:frame_half_len);
    end
end