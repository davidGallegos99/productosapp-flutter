import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:productos_app/services/push_notification_service.dart';
import 'package:productos_app/widgets/dialog.dart';
import 'package:productos_app/widgets/flow_menu.dart';

import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:productos_app/models/product.dart';
import 'package:productos_app/providers/product_from_provider.dart';
import 'package:productos_app/services/product_service.dart';
import 'package:productos_app/widgets/widgets.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final ProductsService productS = Provider.of<ProductsService>(context);
    final Product selected = productS.selectedProduct;
    final Size size = MediaQuery.of(context).size;
    final pillDecoration = BoxDecoration(boxShadow: const [
      BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 8))
    ], borderRadius: BorderRadius.circular(35));

    return ChangeNotifierProvider(
        create: ((context) => ProductFormProvider(productS.selectedProduct)),
        child: _ProductsBody(
            pillDecoration: pillDecoration, selected: selected, size: size));
  }
}

class _ProductsBody extends StatelessWidget {
  const _ProductsBody({
    Key? key,
    required this.pillDecoration,
    required this.selected,
    required this.size,
  }) : super(key: key);

  final BoxDecoration pillDecoration;
  final Product selected;
  final Size size;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductFormProvider>(context);
    final service = Provider.of<ProductsService>(context);

    goBack() {
      Navigator.pop(context);
    }

    // Crear o actualizar producto
    upload() async {
      final product = provider.product;
      if (!provider.isValidForm()) return;
      final imgUrl = await service.uploadImg();

      if (imgUrl != null) {
        product.picture = imgUrl;
      }
      await service.updateOrCreate(product);
      goBack();
    }

    // Eliminar un producto de firebase y la lista
    deleteProduct() async {
      final String id = service.selectedProduct.id ?? '';
      await service.delete(id);
      goBack();
    }

    //  Lista para mapear en el flow menu
    List<Map<String, dynamic>> iconos = <Map<String, dynamic>>[
      {'nombre': 'menu', 'icon': Icons.menu},
      {
        'nombre': 'home',
        'icon': Icons.home,
        'method': () => Navigator.pop(context)
      },
      {'nombre': 'save', 'icon': Icons.save, 'method': upload},
      {
        'nombre': 'delete_forever',
        'icon': Icons.delete_forever,
        'method': deleteProduct
      }
    ];

    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          margin: const EdgeInsets.only(top: 75),
          decoration: pillDecoration,
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: _ProductCard(
                    bgImage: selected.getFullImg(),
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: _ProductForm(selected: selected, size: size),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: service.isLoading
          ? FloatingActionButton(
              onPressed: () {},
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            )
          : FlowMenu(lista: iconos),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    Key? key,
    required this.bgImage,
  }) : super(key: key);

  final String bgImage;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductsService>(context);
    return Stack(
      children: [
        BackgroundCard(
          takenImage: provider.selectedImage,
          image: bgImage,
        ),
        const _ProductHeaderIcons()
      ],
    );
  }
}

class _ProductHeaderIcons extends StatelessWidget {
  const _ProductHeaderIcons({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductsService>(context);

    // Elegir imgen
    Future selectImg() async {
      await showModal(context);
      if (provider.imgOpt == '') return;
      final XFile? photo;
      if (provider.imgOpt == 'camara') {
        final ImagePicker picker = ImagePicker();

        photo = await picker.pickImage(
            source: ImageSource.camera, imageQuality: 100);
      } else {
        final ImagePicker picker = ImagePicker();

        photo = await picker.pickImage(
            source: ImageSource.gallery, imageQuality: 100);
      }
      if (photo == null) {
        return;
      }
      provider.updateSelectedImage(photo.path);
    }

    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              Provider.of<ProductsService>(context, listen: false)
                  .selectedImage = null;

              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new),
            color: Colors.white,
            iconSize: 40,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              onPressed: () async {
                await selectImg();
              },
              icon: const Icon(Icons.camera_alt_outlined),
              color: Colors.white,
              iconSize: 40,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductForm extends StatelessWidget {
  const _ProductForm({
    Key? key,
    required this.size,
    required this.selected,
  }) : super(key: key);

  final Size size;
  final Product selected;

  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    final product = productForm.product;
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(35),
              bottomRight: Radius.circular(35))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
        child: Form(
          key: productForm.formKey,
          child: Column(
            children: [
              CustomFormField(
                  validators: (val) {
                    if (val.length < 4) {
                      return 'El nombre debe contener al menos 4 letras';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (va) => product.name = va,
                  initialValue: selected.name,
                  labelText: 'Nombre:',
                  type: TextInputType.name),
              const SizedBox(
                height: 15,
              ),
              CustomFormField(
                onChanged: (va) {
                  if (double.tryParse(va) != null) {
                    product.price = double.parse(va);
                  }
                },
                initialValue: '${selected.price}',
                labelText: 'Precio:',
                type: TextInputType.number,
                validators: (val) {
                  if (double.tryParse(val) == null) {
                    return 'Solo se permiten numeros';
                  } else if (double.tryParse(val)! < 1) {
                    return 'El precio no puede ser \$0.00';
                  } else {
                    return null;
                  }
                },
                formatter: FilteringTextInputFormatter.allow(
                    RegExp(r'^(\d+)?\.?\d{0,2}')),
              ),
              ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  leading: Text(
                    'Disponible',
                    style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  trailing: CupertinoSwitch(
                      activeColor: Colors.indigo,
                      value: selected.available,
                      onChanged: productForm.updateavailability))
            ],
          ),
        ),
      ),
    );
  }
}
