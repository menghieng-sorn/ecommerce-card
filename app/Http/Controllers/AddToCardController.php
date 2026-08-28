<?php

namespace App\Http\Controllers;

use App\Models\Product;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Session;

class AddToCardController extends Controller
{
    public $cart = [];

    function __construct()
    {
        $this->cart = Session::get('cart',[]);
    }

    public function store(Request $request, string $id)
    {
        $product = Product::findOrFail($id);
        $this->cart[$product->id] = [
            'id'=> $product->id,
            'image'=> $product->image,
            'name'=> $product->name,
            'price'=> $product->price,
            'color'=> $product->color,
            'qty'=> $product->qty,
        ];
        Session::put('cart',$this->cart);

        return response([
            'status'=>'ok',
            'message'=>'Product added to cart',
            'cart_count'=>count($this->cart)
        ]);
    }
}
