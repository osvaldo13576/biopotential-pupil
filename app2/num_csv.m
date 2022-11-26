% lee un archivo csv y regresa el numero de datos colectados
function num_datos = num_csv(directorio_archivo)
    data = readmatrix(directorio_archivo);
    num_datos = length(data);
end