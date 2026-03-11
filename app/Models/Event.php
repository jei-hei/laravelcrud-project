<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Event extends Model
{
    // Allow these fields to be mass-assigned
    protected $fillable = ['name', 'description', 'date', 'location'];
}
