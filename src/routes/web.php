<?php

use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\Response;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    return view('welcome');
});

Route::get('/health', function () {
    $content = file_get_contents("/var/app/public/info.txt", true);
    $logs = array_filter(explode("\n", $content), function($log) {
        return !empty($log);
    });
    return Response::json([ "status" => "ok", "logs" => $logs ]);
});
