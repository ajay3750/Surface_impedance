clc;
clear all;

% Air filled waveguide impedance value
Z0 = 377;
xd = 0:0.1:20;

% Input values
data1 = readmatrix('C:\Users\AJAY MAURYA\Documents\project\S11_data.txt');
data2 = readmatrix('C:\Users\AJAY MAURYA\Documents\project\S21_data.txt');

% Parameters
frequency = data1(:,1);
gamma = data1(:,2); % Reflection coefficient
T = data2(:,2); % Transmission coefficient

% Components of waveguide propagation constants
Kt = 0.000139;
Km = 2 * pi * frequency * sqrt(2);
Kz = sqrt(Km.^2 - Kt^2);

% Thickness of substrate
d = 3.2 * 10^-3;
permitivity_freespace = 4 * pi * 10^7;
Zm = 2 * pi * permitivity_freespace;
Zm_value = Zm / Kz;
Zm_square = Zm_value.^2;
Z0_square = Z0^2;

% Input impedance calculation
Num_Zin = (Z0 + 1i .* Zm_value .* tan(Kz .* d));
Den_Zin = Zm_value + 1i * Z0 * tan(Kz * d);
Zin_final = Zm_value * (Num_Zin ./ Den_Zin);

% Surface impedance calculation
Num_Zs = (-Z0 .* Zin_final .* (1 + gamma));
Den_Zs = (Zin_final .* gamma + Z0 .* gamma - Zin_final + Z0);
Zs_R = Num_Zs ./ Den_Zs;

% When thickness is less than the wavelength
Zs_R1 = -(Z0 .* (1 + gamma)) ./ (2 .* gamma);

% At the output side Zs_T
Zs_T_nu = -T .* Z0 .* Zm_value .* ((Z0 .* cos(Kz .* d)) + 1i .* (Zm_value .* sin(Kz .* d)));
Zs_T_den = 2 * Z0 .* Zm_value .* (T .* cos(Kz .* d) - 1) + 1i .* (Zm_square + Z0_square) .* T .* sin(Kz .* d);
Zs_T = Zs_T_nu ./ Zs_T_den;

% When thickness is less than lambda
Zs_T1 = (T .* Z0) ./ (2 .* (1 - T)); % S11=1-S21

% Create figures with titles and legends
figure
hold on
plot(frequency, abs(Zs_R1), 'b','Marker','o','MarkerIndices',1:9:length(xd))
plot(frequency, abs(Zs_T1), 'g','Marker','+','MarkerIndices',1:9:length(xd))
legend('Magnitude of Zs\_R1', 'Magnitude of Zs\_T1', 'Location', 'Northwest')
xlabel('Frequency (GHz)');
ylabel('Real Surface Impedance Magnitude (\Omega)');
title('Magnitude of Surface Impedance vs. Frequency (d < λ)')
hold off

figure
hold on
plot(frequency, abs(Zs_R), 'b','Marker','o','MarkerIndices',1:9:length(xd))
plot(frequency, abs(Zs_T), 'g','Marker','+','MarkerIndices',1:9:length(xd))
legend('Magnitude of Real(Zs\_R)', 'Location', 'Northwest')
xlabel('Frequency (GHz)');
ylabel('Real Surface Impedance Magnitude (\Omega)');
title('Magnitude of Surface Impedance vs. Frequency')
hold off

figure
hold on
plot(frequency, imag(Zs_R), 'b','Marker','o','MarkerIndices',1:9:length(xd))
plot(frequency, imag(Zs_T), 'g','Marker','+','MarkerIndices',1:9:length(xd))
legend('Imaginary(Zs\_R)', 'Location', 'Northwest')
xlabel('Frequency (GHz)');
ylabel('Imaginary Surface Impedance (\Omega)');
title('Imaginary Part of Surface Impedance vs. Frequency')
hold off

figure
hold on
plot(frequency, imag(Zs_R1), 'b','Marker','o','MarkerIndices',1:9:length(xd))
plot(frequency, imag(Zs_T1), 'g','Marker','+','MarkerIndices',1:9:length(xd))
legend('Imaginary(Zs\_R1)', 'Imaginary(Zs\_T1)', 'Location', 'Northwest')
xlabel('Frequency (GHz)');
ylabel('Imaginary Surface Impedance (\Omega)');
title('Imaginary Part of Surface Impedance vs. Frequency (d < λ)')
hold off
