#!/bin/bash

# Verifica que se pase al menos un parámetro
if [ $# -lt 1 ]; then
    echo "Uso: $0 {mount|unmount|sync|push} [--path /ruta/a/usar]"
    exit 1
fi

# Inicializa las variables
COMMAND=$1
PATH_PARAM=""

# Verifica y procesa el parámetro path (solo si se usa con sync)
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        --path)
            PATH_PARAM=$2
            shift 2
            ;;
        *)
            shift
            ;;
    esac
done

# Funciones
mount_rclone() {
    echo "Montando con rclone..."
    rclone mount GoogleDrive: /home/caballero/Workspace/GoogleDrive/.GoogleDrive/ --daemon
    echo "Montaje completado."
}

unmount_rclone() {
    echo "Desmontando con rclone..."
    fusermount -u /home/caballero/Workspace/GoogleDrive/.GoogleDrive/
    echo "Desmontaje completado."
}

sync_rclone() {
    if [ -z "$PATH_PARAM" ]; then
        echo "Sincronizando todo con rclone..."
        rclone sync GoogleDrive: /home/caballero/Workspace/GoogleDrive/
    else
        echo "Sincronizando solo la carpeta $PATH_PARAM con rclone..."
        rclone sync GoogleDrive:/"$PATH_PARAM" /home/caballero/Workspace/GoogleDrive/"$PATH_PARAM" 
    fi
    echo "Sincronización completada."
}

push_rclone() {
    if [ -z "$PATH_PARAM" ]; then
        echo "Subiendo todo a Google Drive con rclone..."
        rclone sync /home/caballero/Workspace/GoogleDrive/ GoogleDrive:
    else
        echo "Subiendo solo la carpeta $PATH_PARAM a Google Drive con rclone..."
        rclone sync /home/caballero/Workspace/GoogleDrive/"$PATH_PARAM" GoogleDrive:/"$PATH_PARAM"
    fi
    echo "Subida completada."
}

# Switch para manejar los parámetros
case "$COMMAND" in
    mount)
        mount_rclone
        ;;
    unmount)
        unmount_rclone
        ;;
    sync)
        sync_rclone
        ;;
    push)
        push_rclone
        ;;
    *)
        echo "Parámetro inválido. Uso: $0 {mount|unmount|sync} [--path /ruta/a/usar]"
        exit 1
        ;;
esac
