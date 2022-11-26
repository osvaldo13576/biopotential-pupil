% carga los datos EEG
function data = loadEEG(directorio_archivo,timestamp)
    data = readmatrix(directorio_archivo,'NumHeaderLines',1);
    % convertir a char: char(datos.Var4(1))
    data(:,1) = data(:,1) + timestamp; % actualizamos el valor del tiempo
end
