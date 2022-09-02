%% abriendo pupil positions
directorio = '/home/osvaldo13576/Documentos/Servicio/pupil_data/2022_06_03/000/exports/000/pupil_positions.csv';
datos = readtable(directorio);
%% vamos a leer un video
video_eye_dir = ['/home/osvaldo13576/Documentos/Servicio/pupil_data/2022_06_03/000/exports/003/world.mp4'];
vid_eye0 = VideoReader(video_eye_dir);
fra = vid_eye0.NumFrames
%%
frames = read(vid_eye0,2);
imagen = imshow(frames);
%%
vid_frames = zeros(12438,1);
for k = 1:12438/2
    vid_frames(2*(k-1)+1) = k;
    vid_frames(2*(k-1)+2) = k;
end
%%
directorio_blink = '/home/osvaldo13576/Documentos/Servicio/pupil_data/2022_06_03/000/exports/003/blinks.csv';
datos = readtable(directorio_blink);
datos_var = ones(1513,1);
len_datos = length(datos.start_frame_index);
for k = 1:len_datos
    datos_var(datos.start_frame_index(k):datos.end_frame_index(k)) = 0;
end
%%
pupil_dir = '/home/osvaldo13576/Documentos/Servicio/pupil_data/2022_06_03/000/exports/003/pupil_positions.csv';
data = readtable(pupil_dir);
datos_frame = data.world_index+1;
tiempo = data.pupil_timestamp - data.pupil_timestamp(1);
%%
value = 10;
for k = 1:1000
    value*k
    pause(1)
end

%% 
dir = '/home/osvaldo13576/Documentos/Servicio/pupil_data/2022_06_03/000/exports/001/world_timestamps.csv';
tabla =readtable(dir);
%dat=tabla.c;
%%
x = 0:360;
y = sind(x);
% Only show one marker, at the x value where the xline is located
s = plot(x, y, 'o-', 'MarkerIndices', 1);
h = xline(x(1));
% Use the title to show where the xline is located
t = title("Sine curve with xline at x = " + x(1));
for k = 2:numel(x)
    h.Value = x(k);
    % 'move' the marker along the sine curve
    s.MarkerIndices = k;
    % Update the title string
    t.String = "Sine curve with xline at x = " + x(k);
    % Let's go a little faster
    pause(1/36);
end
%% vista de la variable generada por csv_to_binary_blinks
archivo = '/home/osvaldo13576/Documentos/Servicio/pupil_data/2022_06_03/000/exports/003/blinks.csv';
archivo2 = '/home/osvaldo13576/Documentos/Servicio/pupil_data/2022_06_03/000/exports/003/world_timestamps.csv';
num_datos = num_csv(archivo2);

datos = csv_to_binary_blinks(archivo,num_datos);

%% read hdf5
archivo = 'file.hdf5';
file_hdf5 = h5disp(archivo)  



