import 'package:dio/dio.dart';
import 'package:flutter_best_practices/mixins/copy_with.dart';
import 'package:flutter_best_practices/mock_data.dart';
import 'package:flutter_best_practices/models/product.dart';
import 'package:flutter_best_practices/services/api_service.dart';
import 'package:flutter_best_practices/utils/logging.dart';

class ProductService extends ApiService with Logging {
  Future<List<Product>> getAll() async {
    final response = await baseGet(path: 'Products');
    final results = response.data['results'] as List<dynamic>;
    final products = [
      for (final map in results) Product.fromMap(map),
    ];
    log('Got ${products.length} Products');
    return products;
  }

  Future<Product> save(
    Product product, {
    CancelToken? cancelToken,
  }) async {
    final bool posting = product.id == null;
    final String path = posting ? 'products' : 'products/${product.id}';
    Response response;
    final dataMap = product.toMap();
    if (posting) {
      response = await basePost(
        path: path,
        cancelToken: cancelToken ?? CancelToken(),
        data: dataMap,
      );
    } else {
      response = await basePut(
        path: path,
        cancelToken: cancelToken ?? CancelToken(),
        data: dataMap,
      );
    }
    if (response.data is Map) {
      return Product.fromMap(response.data);
    }
    throw Exception(
      'Unexpected response format: ${response.data.runtimeType} from $path',
    );
  }

  Future<bool> delete({
    required int productId,
    CancelToken? cancelToken,
  }) async {
    final String path = 'products/$productId';
    final response = await baseDelete(
      path: path,
      cancelToken: cancelToken ?? CancelToken(),
    );

    return response.statusCode == 200 || response.statusCode == 204;
  }
}

class MockProductService extends ProductService {
  @override
  Future<List<Product>> getAll() async {
    await Future.delayed(const Duration(milliseconds: 750));
    final products = List<Product>.from(MockData.products);
    log('Got ${products.length} products');
    return products;
  }

  @override
  Future<Product> save(
    Product product, {
    CancelToken? cancelToken,
  }) async {
    log('Saving product');
    checkNetworkConnectivity();
    await Future.delayed(const Duration(milliseconds: 750));

    final posting = product.id == null;

    if (posting) {
      int maxId = 0;
      for (final existingProduct in MockData.products) {
        if (existingProduct.id != null && existingProduct.id! > maxId) {
          maxId = existingProduct.id!;
        }
      }
      final newPrice = product.copyWith(
        id: NullableValue(maxId + 1),
      );
      MockData.products.add(newPrice);
      return newPrice;
    } else {
      final index = MockData.products.indexWhere(
        (p) => p.id == product.id,
      );
      if (index == -1) {
        throw DioException(
          requestOptions: RequestOptions(
            path: 'products/${product.id}',
          ),
          error: 'Product not found',
          type: DioExceptionType.badResponse,
          response: Response(
            statusCode: 404,
            requestOptions: RequestOptions(
              path: 'products/${product.id}',
            ),
          ),
        );
      }
      MockData.products[index] = product.copy();
      return product;
    }
  }

  @override
  Future<bool> delete({
    required int productId,
    CancelToken? cancelToken,
  }) async {
    log(
      'Deleting product: id=$productId',
    );
    checkNetworkConnectivity();
    await Future.delayed(const Duration(milliseconds: 750));

    final index = MockData.products.indexWhere(
      (p) => p.id == productId,
    );

    if (index == -1) {
      throw DioException(
        requestOptions: RequestOptions(
          path: 'products/$productId',
        ),
        error: 'Product not found',
        type: DioExceptionType.badResponse,
        response: Response(
          statusCode: 404,
          requestOptions: RequestOptions(
            path: 'products/$productId',
          ),
        ),
      );
    }

    MockData.products.removeAt(index);
    return true;
  }
}
