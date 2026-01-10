<?php

return [

    /*
    |--------------------------------------------------------------------------
    | Default Filesystem Disk
    |--------------------------------------------------------------------------
    |
    | Here you may specify the default filesystem disk that should be used
    | by the framework. The "local" disk, as well as a variety of cloud
    | based disks are available to your application.
    |
    */

    'default' => env('FILESYSTEM_DRIVER', 'local'),

    /*
    |--------------------------------------------------------------------------
    | Filesystem Disks
    |--------------------------------------------------------------------------
    |
    | Here you may configure as many filesystem "disks" as you wish, and you
    | may even configure multiple disks of the same driver. Defaults have
    | been setup for each driver as an example of the required options.
    |
    | Supported Drivers: "local", "ftp", "sftp", "s3"
    |
    */

    'disks' => [

        'local' => [
            'driver' => 'local',
            'root' => storage_path('app'),
        ],

        'public' => [
            'driver' => 'local',
            'root' => storage_path('app/public'),
            'url' => env('APP_URL').'/storage',
            'visibility' => 'public',
        ],

        's3' => [
            'driver' => 's3',
            'key' => env('AWS_ACCESS_KEY_ID'),
            'secret' => env('AWS_SECRET_ACCESS_KEY'),
            'region' => env('AWS_DEFAULT_REGION'),
            'bucket' => env('AWS_BUCKET'),
            'url' => env('AWS_URL'),
            'endpoint' => env('AWS_ENDPOINT'),
            'use_path_style_endpoint' => env('AWS_USE_PATH_STYLE_ENDPOINT', false),
            'throw' => false,
        ],

        // Configuração para o drive de rede (Z: ou \\192.168.50.11\captação)
        'captacao_network_drive' => [
            'driver' => 'local', // Usamos 'local' pois o Laravel acessará via caminho de sistema de arquivos
            'root' => '//192.168.50.11/captação', // Caminho UNC para o drive de rede
            'url' => env('APP_URL').'/storage/captacao', // URL para acesso público (se aplicável)
            'visibility' => 'public', // Ou 'private', dependendo da necessidade
            // Para Windows, pode ser necessário configurar o PHP para acessar caminhos UNC
            // ou montar o drive de rede no ambiente do container Docker do Laravel.
            // Exemplo de montagem no docker-compose.yaml para o backend:
            // volumes:
            //   - /mnt/captacao:/mnt/captacao # Mapear o drive de rede do host para o container
            // E então, 'root' => '/mnt/captacao'
        ],

    ],

    /*
    |--------------------------------------------------------------------------
    | Symbolic Links
    |--------------------------------------------------------------------------
    |
    | Here you may configure the symbolic links that should be created when the
    | `storage:link` Artisan command is executed. The array keys should be the
    | locations of the links and the values should be their targets.
    |
    */

    'links' => [
        public_path('storage') => storage_path('app/public'),
    ],

];
