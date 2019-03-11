# MATLAB Read JDX Files

Version: 1.0
Date: 12.12.2016
Author: Robin Eccleston

## Description

Function to read in jdx files and return the data in a matrix for use by other functions. Written and tested using MATLAB R2012a. The work is done in read_jdx.m in the function read_jdx.

## Arguments


* **file_name** - Full location of the file to read, required
* **delimiter** - delimiter character between measurements, optional but assumes space character if not set.
* **number_of_measurements** - the number of transmission measurements for each scan. If not set this assumes 5 values. The code will still read files with less data, but will fill the remaining entries with zeros, which could effect the average transmission calculation
 
## Outputs

* **wave_numbers** - The wavenumbers for each measurement
* **transmission_values** - A matrix with each value holding another matrix with all of the measurement values at that wavenumber
* **header_data** - A structure holding all of the data from the header file as variables. Variable names are all lower case characters.
* **avg_transmission** - The average transmission at each wave number, calculated using the parameter "number_of_measurements"
* **wavelengths** - The wavelengths calculated in um.
