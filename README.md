# Savitzky-Golay-Filtering
A Savitzky–Golay filter is a digital filter that can be applied to a set of digital data points for the purpose of smoothing the data, that is, to increase the precision of the data without distorting the signal tendency.
Reference implementation used:
- [wikipedia](https://fr.wikipedia.org/wiki/Algorithme_de_Savitzky-Golay)
- [matlab](https://www.mathworks.com/help/signal/ref/sgolay.html)
- [horcher](https://github.com/horchler/sgolayfilt/blob/master/sgolayfilt.m)
- [burelant](https://github.com/burelant/sgolay_robust/blob/main/sgolay_robust.m)
- [SciPy](https://docs.scipy.org/doc/scipy/reference/generated/scipy.signal.savgol_filter.html)

# Usage
We defined two public functions, respectively at src/SavitzkyGolayFIR.m and src/sgolayfilt.m.
## src/SavitzkyGolayFIR
The function __SavitzkyGolayFIR()__ is designed as the following:
```bash
function [FIRFiltersCoeff, MatrixOfDiffFilter, frame_half_len] = SavitzkyGolayFIR(order, framelen)
% Designs a Savitzky-Golay Finite Impulse Response (FIR) smothing filter with polynomial order order and frame lenght framelen.
% INPUTS:
% order    -- polynomial order positive odd integer
% framelen -- Frame lenght, specified as a positive odd integer. it Must be greater than order.
%
% OUTPUTS:
% FIRFiltersCoeff    -- Time-varying FIR filter coefficiants (matrix)
% MatrixOfDiffFilter -- Matrix of differentiation filters (matrix)
% frame_half_len     -- frame half lenght
arguments
    order (1,1) double {mustBeNumeric, mustBeReal, mustBePositive, mustBeGreaterThanOrEqual(order,0)}
    framelen (1,1) double {mustBeNumeric, mustBeReal, mustBePositive, mustBeGreaterThan(framelen,order)}
end
```
Computing __FIRFiltersCoeff__ will allow us to __smooth a signal__, and the __MatrixOfDiffFilter__ is used to compute __avitzky-Golay Derivative Estimates__.

## src/sgolayfilt
The function sgolay() is design to smooth a signal as the following:
```bash
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
```
__We expect users to use "classic" or "default" mode.__
__Other modes can lead to weird behavior at edges, if it is, set trst="no".__

# Validation
We develop th following tests to ensure out implementation was correct:

The following tests are based on [MATLAB-sgolay](https://www.mathworks.com/help/signal/ref/sgolay.html) and [MATLAB-sgolayfilt](https://www.mathworks.com/help/signal/ref/sgolayfilt.html)
-  SGolay_SmoothingOfNoisySinusoid
-  SGolay_Differentiation
-  SteadyStateAndTransientSGFilters
-  UsingSgolayfilt_SteadyStateAndTransientSGFilters
-  SGolay_FilteringSpeechSignal.m

The next two tests are based on our own data:
- test_cutx
- test_signal_zlens



# Tips
if you are running MATLAB from shell mode (like inside emacs M-x: matlab-shell), do the following:
```matlab
>>addpath /path/to/Savitzky-Golay-Filtering/test
>>addpath("/path/to/Savitzky-Golay-Filtering/src","-end")
>>addpath("/path/to/Savitzky-Golay-Filtering/data/output/signal_zlens","-end")
```
Afterwards, inside a matlab-shell you can call file as the following:
```matlab
test_signal_zlens
```
and open figures with:
```matlab
openfig("figure inside data/output/signal_zlens/")
```