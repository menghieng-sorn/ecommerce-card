<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Session;

class CartPageController extends Controller
{
    function index(){

        //$products = Session::get('cart', []);

        //convert to obj
        $products = collect(Session::get('cart', []))
        ->map(fn ($product) => (object) $product);

        // $products = array_map(function ($product) {
        //     return (object) $product;
        // }, $products);
       return view('pages.cart', compact('products'));
    }
}
