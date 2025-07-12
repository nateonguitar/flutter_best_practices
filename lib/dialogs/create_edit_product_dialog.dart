import 'package:flutter/material.dart';
import 'package:flutter_best_practices/enums/form_mode.dart';
import 'package:flutter_best_practices/models/product.dart';
import 'package:flutter_best_practices/provider.dart';
import 'package:flutter_best_practices/services/product_service.dart';
import 'package:flutter_best_practices/themes/core_theme.dart';
import 'package:flutter_best_practices/utils/logging.dart';
import 'package:flutter_best_practices/widgets/error_banner.dart';
import 'package:go_router/go_router.dart';

class _Controllers {
  final name = TextEditingController();
  final description = TextEditingController();

  void initFromProduct(Product product) {
    name.text = product.name;
    description.text = product.description;
  }

  void dispose() {
    name.dispose();
    description.dispose();
  }

  void trimAll() {
    name.text = name.text.trim();
    description.text = description.text.trim();
  }
}

class CreateEditProductDialog extends StatefulWidget {
  final Product? product;
  const CreateEditProductDialog({
    super.key,
    this.product,
  });

  @override
  State<CreateEditProductDialog> createState() =>
      _CreateEditProductDialogState();
}

class _CreateEditProductDialogState extends State<CreateEditProductDialog>
    with Logging {
  final _productService = Provider.get<ProductService>();
  final _controllers = _Controllers();
  final _formKey = GlobalKey<FormState>();
  late FormMode _mode;

  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    logWidgetMounted();
    _mode = widget.product == null ? FormMode.create : FormMode.edit;
    switch (_mode) {
      case FormMode.create:
        break;
      case FormMode.edit:
        _controllers.initFromProduct(widget.product!);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      titlePadding: CoreTheme.dialogTitlePadding,
      contentPadding: CoreTheme.dialogContentPadding,
      title: Text(switch (_mode) {
        FormMode.create => 'Create Product',
        FormMode.edit => 'Edit Product',
      }),
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: CoreTheme.formFieldSpacing.height,
            children: [
              _nameField(),
              _descriptionField(),
              if (_error != null) _errorBanner(),
              Row(
                spacing: 8,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _cancelButton(),
                  _saveButton(),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _nameField() {
    return TextFormField(
      controller: _controllers.name,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        labelText: 'Name',
      ),
      enabled: !_saving,
      validator: (value) {
        value = (value ?? '').trim();
        if (value.isEmpty) {
          return 'Required';
        }
        return null;
      },
    );
  }

  Widget _descriptionField() {
    return TextFormField(
      controller: _controllers.description,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        labelText: 'Description',
        floatingLabelAlignment: FloatingLabelAlignment.start,
      ),
      enabled: !_saving,
      maxLines: 3,
      minLines: 3,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.done,
      validator: (value) {
        value = (value ?? '').trim();
        if (value.isEmpty) {
          return 'Required';
        }
        return null;
      },
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

  Widget _cancelButton() {
    return TextButton(
      onPressed: _saving ? null : () => context.pop(),
      child: const Text('Cancel'),
    );
  }

  Widget _saveButton() {
    return ElevatedButton(
      onPressed: _saving ? null : _save,
      child: Text(
        switch (_mode) {
          FormMode.create => 'Create',
          FormMode.edit => 'Edit',
        },
      ),
    );
  }

  Future<void> _save() async {
    _controllers.trimAll();
    final bool formValid = _formKey.currentState?.validate() ?? false;
    if (!formValid) {
      _error = 'Please fix any errors in the form';
      setState(() {});
      return;
    }

    _saving = true;
    setState(() {});
    try {
      final Product dto;
      switch (_mode) {
        case FormMode.create:
          dto = Product(
            id: null,
            name: _controllers.name.text,
            description: _controllers.description.text,
          );
          break;
        case FormMode.edit:
          if (widget.product == null) {
            throw Exception('Widget product is null in edit mode');
          }
          dto = widget.product!.copyWith(
            name: _controllers.name.text,
            description: _controllers.description.text,
          );
          break;
      }
      final newProduct = await _productService.save(dto);
      if (mounted) {
        Navigator.of(context).pop(newProduct);
      }
    } catch (e, stackTrace) {
      log(
        'Failed to save paint sheen price',
        error: e,
        stackTrace: stackTrace,
      );
      _error = 'Something went wrong while saving the product';
    } finally {
      _saving = false;
      if (mounted) {
        setState(() {});
      }
    }
  }
}
