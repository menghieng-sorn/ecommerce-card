<?php

namespace App\Http\Controllers;

use App\Models\Product;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Session;

class ProductPageController extends Controller
{
    function index(){
        $products = Product::all();
        return view('pages.home',compact('products'));
    }
    function show(string $id){

        $product = Product::findOrFail($id);
        return view('pages.product-detail',compact('product'));
    }
}
