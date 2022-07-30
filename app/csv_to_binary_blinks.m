%crea un vector binario de parpadeos
% 1 si se cierra el ojo
% 0 si se mantiene abierto
function vector_ = csv_to_binary_blinks(direc_archivo,longitud)
    data = readtable(direc_archivo);
    vector_ = zeros(longitud,1);
    len_data = length(data.start_frame_index);
    for k = 1:len_data
        vector_(data.start_frame_index(k):data.end_frame_index(k)) = 1;
    end
end