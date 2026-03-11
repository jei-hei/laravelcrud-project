<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\EventController;

Route::prefix('events')->group(function () {
    // Define the route for creating a new event (POST)
    Route::post('/', [EventController::class, 'store']);

    // Define the route for getting all events (GET)
    Route::get('/', [EventController::class, 'index']);

    // Define the route for getting a single event by ID (GET)
    Route::get('{event}', [EventController::class, 'show']);

    // Define the route for updating an event (PUT/PATCH)
    Route::put('{event}', [EventController::class, 'update']);

    // Define the route for deleting an event (DELETE)
    Route::delete('{event}', [EventController::class, 'destroy']);
});
