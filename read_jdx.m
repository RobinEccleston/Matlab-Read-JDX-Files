%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Filename: read_jdx.m
% Version: 1.0
% Date: 12.12.2016
% Author: Robin Eccleston
%
% Description: Function to read in jdx files and return the data in a
%              matrix for use by other functions. Written and tested using
%              MATLAB R2012a.
%
% Arguments:
%       file_name - Full location of the file to read, required
%       delimiter - delimiter character between measurements, optional but
%                   assumes space character if not set.
%       number_of_measurements - the number of transmission measurements for
%                   each scan. If not set this assumes 5 values. The code
%                   will still read files with less data, but will fill the
%                   remaining entries with zeros, which could effect the
%                   average transmission calculation
% 
% Outputs:
%       wave_numbers - The wavenumbers for each measurement
%       transmission_values - A matrix with each value holding another matrix
%                   with all of the measurement values at that wavenumber
%       header_data - A structure holding all of the data from the header file
%                   as variables. Variable names are all lower case characters.
%       avg_transmission - The average transmission at each wave number,
%                   calculated using the parameter "number_of_measurements"
%       wavelengths - The wavelengths calculated in um.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [wave_numbers, transmission_values, header_data, avg_transmission, wavelengths]=read_jdx(file_name, delimiter, number_of_measurements)

    %check if the number of measurements was set, if not, assume 5.
    if ~exist('number_of_measurements','var')
        number_of_measurements=5;
    end

    %check if delimiter was set, if not, assume space character.
    if ~exist('delimiter','var')
        delimiter=' ' ;
    end

    %initialise variables used in loop
    wave_numbers=[];
    transmission_values=[];
    avg_transmission=[];
    wavelengths=[];


    try
        fid = fopen(file_name, 'r'); 
    catch
        fprintf('Error when trying to open the following file: %s\n', file_name);
        return
    end


    %run through each line in the file
    while feof(fid) == 0

        line = fgets(fid); 
        %fprintf('%s', line);

        
        
        
        %check if the line contains a comment/parameter
        if line(1:2)=='##'

            %find where the equals sign is
            eq_pos = strfind(line,'=');

            %check this isn't the last line
            if isempty(strfind(line,'##END='));

                %get the line contents on the left side of the equals, make it lower case
                var_name=line(3:eq_pos-1);
				var_name=lower(var_name);

                %try and convert the remaining string on the other side to a
                %number
                var_value=str2double(line(eq_pos+1:end-1));

                %check if we got a valid number, if not just take the string as
                %the value
                if isnan(var_value)
                    var_value=line(eq_pos+1:end-1);
                end

                %create a new variable name and assign the value
                header_data.(genvarname(var_name)) = var_value;
            end

            
            
            
        else
            %we should have the transmission data

            %split the string by the delimiter
            split_str=strread(line, '%s', 'delimiter', delimiter);

            %convert to double, first value should be wavenumber
            wave_number=str2double(split_str(1));

            %check if we got a number or not
            if(~isnan(wave_number))

                %we have a number so should be okay to process line.

                %append the wave number onto our list
                wave_numbers=[wave_numbers; wave_number];
                this_wavelength=10000/wave_number;
                wavelengths=[wavelengths; this_wavelength];

                %get the number of measurement points and make an empty array
                num_meas=size(split_str,1)-1;
                this_wn_values=zeros(1, number_of_measurements);

                for i=2:num_meas+1 %first value is the wavenumber, skip this

                    this_value=str2double(split_str(i));

                    %if we didn't get a real value, change it to zero.
                    if(isnan(this_value))
                        this_value=0;
                    end

                    this_wn_values(i-1)=this_value;
                end

                %append the transmission values from this wavenumber to the
                %larger matrix.
                transmission_values=[transmission_values; [this_wn_values]];
                
                %calculate average transmission
                this_avg_transmission=mean(this_wn_values);
                
                avg_transmission=[avg_transmission; this_avg_transmission];


            end

        end

    end

    fclose(fid);

end