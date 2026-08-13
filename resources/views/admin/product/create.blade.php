<x-app-layout>
    <section class="wsus__product mt_145 pb_100">
        <div class="container">
            <h4 class="pb-3 fw-normal fs-4">Dashboard</h4>
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5>All Products</h5>
                    <a href="{{ route('dashboard') }}" class="btn btn-primary">Back</a>
                </div>
                <div class="card-body">
                    <div class="form-group mb-3">
                        <label class="form-label" for="">Images</label>
                        <x-text-input type='file' class="form-control" name="images" />
                    </div>
                    <div class="form-group mb-3">
                        <dev for="" class="form-label">Name</dev>
                        <x-text-input type="text" name="name" class="form-control" />
                    </div>
                    <div class="form-group mb-3">
                        <dev for="" class="form-label">Price</dev>
                        <x-text-input type="text" name="price" class="form-control" />
                    </div>
                    <div class="form-group mb-3">
                        <dev for="" class="form-label">Colors</dev>
                        <x-text-input type="text" name="colors" class="form-control" />
                    </div>
                    <div class="form-group mb-3">
                        <dev for="" class="form-label">Short Description</dev>
                        <x-text-input type="text" name="short-description" class="form-control" />
                    </div>
                    <div class="form-group mb-3">
                        <dev for="" class="form-label">Qty</dev>
                        <x-text-input type="text" name="qty" class="form-control" />
                    </div>
                    <div class="form-group mb-3">
                        <dev for="" class="form-label">Sku</dev>
                        <x-text-input type="text" name="sku" class="form-control" />
                    </div>
                    <div class="form-group mb-3">
                        <dev for="" class="form-label">Decription</dev>
                        <textarea name="name" class="form-control" id="editor" cols="10" rows="30"></textarea>
                    </div>
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
