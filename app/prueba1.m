%%
%%
dir_dato = '/home/osvaldo13576/Documents/pupil_data/2022_10_14/002/exports/005/surfaces/gaze_positions_on_surface_Surface 1.csv';
datos = readtable(dir_dato,'Delimiter', ',');

xnorm = datos.x_norm;
ynorm = datos.y_norm;
%%
plot(xnorm,ynorm,'.')
%%
X = [xnorm,ynorm];
h = histogram2(xnorm,ynorm,'DisplayStyle','tile','ShowEmptyBins','off');
h.NumBins = [50 50];
%%c
d = [xnorm,ynorm];
p.xylim=[-100 -100 100 100];
p.alpha=1;

var=gkde2(d);

figure
heatmap(var)
colormap(jet)
hold on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
%%
eye_t_data = readtable('/home/osvaldo13576/Documents/pupil_data/2022_10_24/000/exports/001/pupil_positions.csv');
timestamps = eye_t_data.pupil_timestamp;
%%
timestamps_real = 1666642611.7519805-854240.913328+timestamps;
offset = 0/1000;%15644=854289.50879;1663
minimos =  timestamps_real - (1666637983866/1000);
[M,I]=min(minimos)
%% 
bmpdir = 'C:\Users\HP\Documents\c3 data\BMPfiles';
loadEmoFlechasVar =  loadEmoFlechas('C:\Users\HP\Documents\c3 data\ROCELIA_ID_0000013\eeg_tarea\Prueba_Oficial.data.2023-01-20--18-20.txt');
BMPnames = loadEmoFlechasVar.Var4;
sync_data = sync_EEG_EF(loadEEG('C:\Users\HP\Documents\c3 data\ROCELIA_ID_0000013\eeg_tarea\0000012_data.txt',1674236937.8652451),loadEmoFlechasVar);
EEG_data = loadEEG('C:\Users\HP\Documents\c3 data\ROCELIA_ID_0000013\eeg_tarea\0000012_data.txt',1674236937.8652451);%variabletemporal
dat1= EEG_data(sync_data(1,1):sync_data(end,2),1);

pupil_data=readmatrix('C:\Users\HP\Documents\c3 data\ROCELIA_ID_0000013\exports\001\surfaces\gaze_positions_on_surface_Surface 1.csv','NumHeaderLines',1);
pupil_time = pupil_data(:,1) + 1674236948.5751748-5526.315733;
index_pupil = zeros(length(dat1),1);
    for i = 1:length(dat1)
            [~,I] = min(abs(pupil_time-dat1(i)));
            index_pupil(i) = I; 
    end

 gaze_positions_on_surface_index = sync_EEG_pupil(dat1, ...
    'C:\Users\HP\Documents\c3 data\ROCELIA_ID_0000013\exports\001\surfaces\gaze_positions_on_surface_Surface 1.csv',1674236948.5751748-5526.315733);
    





