<x-app-layout>
    <section class="wsus__product mt_145 pb_100">
        <div class="container">
            <h4 class="pb-3 fw-normal fs-4">Dashboard</h4>
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5>All Products</h5>
                    <a href="{{ route('product.create') }}" class="btn btn-primary">Create New</a>
                </div>
                <div class="card-body">
                    <table class="table align-middle text-center">
                    <thead>
                        <tr>
                            <th scope="col">#</th>
                            <th scope="col">Image</th>
                            <th scope="col">Name</th>
                            <th scope="col">Price</th>
                            <th scope="col">QTY</th>
                            <th scope="col">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        @foreach($products as $product)
                        <tr >
                            <th scope="row">{{ $loop->iteration }}</th>
                            <td><img class="d-block mx-auto" style="width: 100px !important;" src="{{ asset($product->image) }}" alt="" width="100" height="100"/></td>
                            <td>{{ $product->name }}</td>
                            <td>{{ $product->price }}</td>
                            <td>{{ $product->qty }}</td>
                            <td>
                                <div class="d-flex justify-content-center align-items-center gap-2">
                                    <a class="btn btn-primary" href="{{ route('product.edit',$product->id) }}" aria-label="">Edit</a>
                                    <form action="{{ route('product.destroy',$product->id) }}" method="POST">
                                        @csrf
                                        @method('DELETE')
                                        <button type="submit" class="btn btn-danger">Delete</button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                        @endforeach
                    </tbody>
                </table>
                </div>
            </div>
        </div>
    </section>
</x-app-layout>
