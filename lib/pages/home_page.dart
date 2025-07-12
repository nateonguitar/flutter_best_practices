import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_best_practices/dialogs/confirm_dialog.dart';
import 'package:flutter_best_practices/dialogs/create_edit_product_dialog.dart';
import 'package:flutter_best_practices/models/product.dart';
import 'package:flutter_best_practices/provider.dart';
import 'package:flutter_best_practices/services/product_service.dart';
import 'package:flutter_best_practices/themes/core_theme.dart';
import 'package:flutter_best_practices/utils/logging.dart';
import 'package:flutter_best_practices/widgets/error_banner.dart';

enum _ProductPopupMenuChoice {
  edit(
    label: 'Edit',
  ),
  remove(
    label: 'Delete',
  );

  final String label;
  const _ProductPopupMenuChoice({
    required this.label,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with Logging {
  late ThemeData _theme;
  final _productService = Provider.get<ProductService>();

  bool _loadingProducts = false;
  List<Product> _products = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    logWidgetMounted();
    _getProducts();
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    return Scaffold(
      appBar: _appBar(),
      body: _bodyWidget(),
      floatingActionButton: _createProductButton(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text('Home Page'),
      actions: [
        if (Platform.isWindows || Platform.isLinux || Platform.isMacOS)
          // This icon is here because pull-to-refresh
          // does not work on desktop platforms.
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _getProducts(),
            tooltip: 'Refresh Products',
          ),
      ],
    );
  }

  Widget _bodyWidget() {
    if (_loadingProducts) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return _errorBanner();
    }
    if (_products.isEmpty) {
      return const Center(
        child: Text('No products available.'),
      );
    }
    return RefreshIndicator(
      onRefresh: () => _getProducts(),
      child: ListView.builder(
        padding: CoreTheme.listPadding,
        itemCount: _products.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Center(
              child: Text(
                'Total Products: ${_products.length}',
                style: _theme.textTheme.titleMedium,
              ),
            );
          }
          final product = _products[index - 1];
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: CoreTheme.pageContentMaxWidth,
              ),
              child: _productListTile(product),
            ),
          );
        },
      ),
    );
  }

  Widget _createProductButton() {
    return FloatingActionButton(
      onPressed: () => _showCreateEditProductDialog(null),
      tooltip: 'Create Product',
      child: const Icon(Icons.add),
    );
  }

  Widget _errorBanner() {
    if (_error == null) {
      return const SizedBox.shrink();
    }
    return ErrorBanner(
      message: _error!,
      onDismissed: () {
        _error = null;
        setState(() {});
      },
    );
  }

  Widget _productListTile(Product product) {
    return ListTile(
      title: Text(product.name),
      subtitle: Text(product.description),
      trailing: PopupMenuButton<_ProductPopupMenuChoice>(
        itemBuilder: (context) {
          return [
            for (final choice in _ProductPopupMenuChoice.values)
              PopupMenuItem(
                value: choice,
                child: Text(
                  choice.label,
                ),
              ),
          ];
        },
        onSelected: (_ProductPopupMenuChoice value) {
          switch (value) {
            case _ProductPopupMenuChoice.edit:
              _showCreateEditProductDialog(product);
              break;
            case _ProductPopupMenuChoice.remove:
              _deleteProduct(product);
              break;
          }
        },
      ),
    );
  }

  Future<void> _showCreateEditProductDialog(Product? product) async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return CreateEditProductDialog(
          product: product,
        );
      },
    );
    if (mounted) {
      if (result is Product) {
        _products = [];
        _getProducts();
      }
    }
  }

  Future<void> _deleteProduct(Product product) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return ConfirmDialog(
          title: const Text('Delete Product'),
          body: Text('Are you sure you want to delete "${product.name}"?'),
          cancelText: 'Cancel',
          confirmText: 'Delete',
          onConfirmPressed: () async {
            try {
              await _productService.delete(productId: product.id!);
            } catch (e) {
              _error = 'Error deleting product';
              return;
            } finally {
              if (mounted) {
                setState(() {});
              }
            }
            _products = [];
            await _getProducts();
          },
        );
      },
    );
    if (confirmed == true) {
      try {
        await _productService.delete(productId: product.id!);
        _products.removeWhere((p) => p.id == product.id);
        setState(() {});
      } catch (e) {
        log('Error deleting product: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting product: $e')),
          );
        }
      }
    }
  }

  Future<void> _getProducts() async {
    _loadingProducts = true;
    setState(() {});
    try {
      _products = await _productService.getAll();
    } on DioException {
      log('Network error while fetching products');
      _error = 'Network error';
    } catch (e, stackTrace) {
      log(
        'Error fetching products',
        error: e,
        stackTrace: stackTrace,
      );
      _error = 'Something went wrong getting products';
    } finally {
      _loadingProducts = false;
      if (mounted) {
        setState(() {});
      }
    }
  }
}
