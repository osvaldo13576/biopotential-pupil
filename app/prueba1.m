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














