%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Filename: read_jdx_test.m
% Version: 1.0
% Date: 12.12.2016
% Author: Robin Eccleston
%
% Description: Code to test "read_jdx.m" function, and plot results.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;

file_to_read='7732-18-5-IR_water.jdx';

[wave_numbers, transmission_values, header_data, avg_transmission, wavelengths]=read_jdx(file_to_read);


figure(1);
clf(1);

subplot(2,1,1);
%plot wavenumbers
plot(wave_numbers, transmission_values);
title(header_data.title());
xlabel('Wavenumbers (1/cm)');
ylabel('Transmission');
set(gca, 'XDir', 'reverse') %flip the xaxis

subplot(2,1,2);
%plot wavelengths
plot(wavelengths, transmission_values);
title(header_data.title());
xlabel('Wavelength (um)');
ylabel('Transmission');


figure(2);
clf(2);

subplot(2,1,1);
%plot wavenumbers
plot(wave_numbers, avg_transmission);
title(header_data.title());
xlabel('Wavenumbers (1/cm)');
ylabel('Transmission');
set(gca, 'XDir', 'reverse') %flip the xaxis

subplot(2,1,2);
%plot wavelengths
plot(wavelengths, avg_transmission);
title(header_data.title());
xlabel('Wavelength (um)');
ylabel('Transmission');