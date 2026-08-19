<x-app-layout>
    <section class="wsus__product mt_145 pb_100">
        <div class="container">
            @if ($errors->any())
                @foreach ($errors->all() as $error)
                    <div class="alert alert-danger">{{ $error }}</div>
                @endforeach
            @endif
            <h4 class="pb-3 fw-normal fs-4">Dashboard</h4>
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5>Create New Products</h5>
                    <a href="{{ route('product.index') }}" class="btn btn-primary">Back</a>
                </div>
                <div class="card-body">
                    <form action="{{ route('product.edit') }}" method="POST" enctype="multipart/form-data">
                        @csrf
                        <div class="form-group mb-3">
                            <label class="form-label" for="">Image</label>
                            <x-text-input type='file' class="form-control" name="image"/>
                        </div>
                        <div class="form-group mb-3">
                            <label class="form-label" for="">Images</label>
                            <x-text-input type='file' class="form-control" name="images[]" multiple/>
                        </div>
                        <div class="form-group mb-3">
                            <div for="" class="form-label">Name</div>
                            <x-text-input type="text" name="name" class="form-control" value="{{ $product->name }}"/>
                        </div>
                        <div class="form-group mb-3">
                            <div for="" class="form-label">Price</div>
                            <x-text-input type="text" name="price" class="form-control" value="{{ $product->price }}/>
                        </div>
                        <div class="form-group mb-3">
                            <div for="" class="form-label">Colors</div>
                            <x-select-input name="color[]" multiple>
                                <option value="">Select</option>
                                <option value="black">Black</option>
                                <option value="green">Green</option>
                                <option value="red">Red</option>
                            </x-select-input>
                        </div>
                        <div class="form-group mb-3">
                            <div for="" class="form-label">Short Description</div>
                            <x-text-input type="text" name="short_description" class="form-control" value="{{ $product->short_desctiption }}/>
                        </div>
                        <div class="form-group mb-3">
                            <div for="" class="form-label">Qty</div>
                            <x-text-input type="text" name="qty" class="form-control" value="{{ $product->qty }}/>
                        </div>
                        <div class="form-group mb-3">
                            <div for="" class="form-label">Sku</div>
                            <x-text-input type="text" name="sku" class="form-control" value="{{ $product->sku }}/>
                        </div>
                        <div class="form-group mb-3">
                            <div for="" class="form-label">Decription</div>
                            <textarea name="description" class="form-control" id="editor" cols="10" rows="30">{!! $product->description !!}</textarea>
                        </div>
                        <button class="btn-primary btn" type="submit">Submit</button>
                    </form>
                </div>
            </div>
        </div>
    </section>
    <x-slot name="scripts">
        <script>
            tinymce.init({
                selector: 'textarea#editor',
                license_key: 'gpl',
                height: 500,
                plugins: [
                    'advlist', 'autolink', 'lists', 'link', 'image', 'charmap', 'preview',
                    'anchor', 'searchreplace', 'visualblocks', 'code', 'fullscreen',
                    'insertdatetime', 'media', 'table', 'help', 'wordcount',
                    /* Premium plugins for demo purposes only */
                    'mediaembed',
                ],
                toolbar: 'undo redo | blocks | ' +
                    'bold italic backcolor | alignleft aligncenter ' +
                    'alignright alignjustify | bullist numlist outdent indent | ' +
                    'removeformat | help',
                content_style: 'body { font-family:Helvetica,Arial,sans-serif; font-size:16px }'
            });
        </script>
    </x-slot>
</x-app-layout>
