<?php

namespace App\Http\Controllers;

use App\Http\Requests\ProductStoreRequest;
use App\Http\Requests\ProductUpdateRequest;
use App\Models\Product;
use App\Models\ProductColor;
use App\Models\ProductImage;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\File;

class ProductController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index() {
        $products = Product::all();
        return view('admin.dashboard',compact('products'));
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        return view('admin.product.create');
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(ProductStoreRequest $request)
    {
        $product = new Product();
        //Insert Product Single Image
        if ($request->hasFile('images')) {
            $image = $request->file('image');
            $fileName = $image->store('', 'public');
            $filePath = 'uploads/' . $fileName;
            $product->image = $filePath;
        }
        //Insert Product Items
        $product->name = $request->name;
        $product->price = $request->price;
        $product->short_description = $request->short_description;
        $product->qty = $request->qty;
        $product->sku = $request->sku;
        $product->description = $request->description;
        $product->save();

        //Insert Product Color
        if ($request->has('colors') && $request->filled('colors')) {
            foreach ($request->colors as $color) {
                ProductColor::create([
                    'product_id' => $product->id,
                    'name' => $color
                ]);
            }
        }
        //Insert Product Multi Images
        if ($request->hasFile('images')) {
            foreach ($request->file('images') as $image) {
                //store image
                $fileName = $image->store('', 'public');
                $filePath = 'uploads/' . $fileName;

                ProductImage::create([
                    'product_id' => $product->id,
                    'path' => $filePath
                ]);
            }
        }
        return redirect()->back();
    }
    /**
     * Display the specified resource.
     */
    public function show(Product $product)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
        $product = Product::with('colors','images')->findOrFail($id);
        $colors = $product->colors->pluck('name')->toArray();
        return view('admin.product.edit',compact('product','colors'));
    }
    /**
     * Update the specified resource in storage.
     */
    public function update(ProductUpdateRequest $request, string $id)
    {
        $product = Product::findOrFail($id);
        //Insert Product Single Image
        if ($request->hasFile('image')) {
            //Delete Image
            File::delete(public_path($product->image));

            $image = $request->file('image');
            $fileName = $image->store('', 'public');
            $filePath = 'uploads/' . $fileName;
            $product->image = $filePath;
        }
        //Insert Product Items
        $product->name = $request->name;
        $product->price = $request->price;
        $product->short_description = $request->short_description;
        $product->qty = $request->qty;
        $product->sku = $request->sku;
        $product->description = $request->description;
        $product->save();


        //Insert Product Color
        if ($request->has('colors') && $request->filled('colors')) {
            //Delete Colors
            foreach($product->colors as $color){
                $color->delete();
            }

            foreach ($request->colors as $color) {
                ProductColor::create([
                    'product_id' => $product->id,
                    'name' => $color
                ]);
            }
        }
        //Insert Product Multi Images
        if ($request->hasFile('images')) {
            //Delete Images
            foreach($product->images as $image){
                File::delete(public_path($image->path));
            }
            $product->images()->delete();

            foreach ($request->file('images') as $image) {
                //store image
                $fileName = $image->store('', 'public');
                $filePath = 'uploads/' . $fileName;

                ProductImage::create([
                    'product_id' => $product->id,
                    'path' => $filePath
                ]);
            }
        }
        return redirect()->back();
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        $product = Product::findOrFail($id);
        $product->colors()->delete();
        File::delete(public_path($product->image));
        foreach($product->images as $image){
            File::delete(public_path($image->path));
        }
        $product->delete();
        return redirect()->back();
    }
}
