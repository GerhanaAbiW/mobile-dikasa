// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$NewOrderViewModel on NewOrderViewModelBase, Store {
  Computed<List<Product>>? _$_productsInGroupComputed;

  @override
  List<Product> get _productsInGroup =>
      (_$_productsInGroupComputed ??= Computed<List<Product>>(
        () => super._productsInGroup,
        name: 'NewOrderViewModelBase._productsInGroup',
      )).value;
  Computed<List<String>>? _$categoriesComputed;

  @override
  List<String> get categories =>
      (_$categoriesComputed ??= Computed<List<String>>(
        () => super.categories,
        name: 'NewOrderViewModelBase.categories',
      )).value;
  Computed<List<Product>>? _$visibleProductsComputed;

  @override
  List<Product> get visibleProducts =>
      (_$visibleProductsComputed ??= Computed<List<Product>>(
        () => super.visibleProducts,
        name: 'NewOrderViewModelBase.visibleProducts',
      )).value;
  Computed<bool>? _$hasOrderItemsComputed;

  @override
  bool get hasOrderItems => (_$hasOrderItemsComputed ??= Computed<bool>(
    () => super.hasOrderItems,
    name: 'NewOrderViewModelBase.hasOrderItems',
  )).value;
  Computed<int>? _$totalQuantityComputed;

  @override
  int get totalQuantity => (_$totalQuantityComputed ??= Computed<int>(
    () => super.totalQuantity,
    name: 'NewOrderViewModelBase.totalQuantity',
  )).value;
  Computed<int>? _$totalPriceComputed;

  @override
  int get totalPrice => (_$totalPriceComputed ??= Computed<int>(
    () => super.totalPrice,
    name: 'NewOrderViewModelBase.totalPrice',
  )).value;

  late final _$productsAtom = Atom(
    name: 'NewOrderViewModelBase.products',
    context: context,
  );

  @override
  ObservableList<Product> get products {
    _$productsAtom.reportRead();
    return super.products;
  }

  @override
  set products(ObservableList<Product> value) {
    _$productsAtom.reportWrite(value, super.products, () {
      super.products = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: 'NewOrderViewModelBase.isLoading',
    context: context,
  );

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: 'NewOrderViewModelBase.errorMessage',
    context: context,
  );

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$selectedGroupAtom = Atom(
    name: 'NewOrderViewModelBase.selectedGroup',
    context: context,
  );

  @override
  ProductGroup get selectedGroup {
    _$selectedGroupAtom.reportRead();
    return super.selectedGroup;
  }

  @override
  set selectedGroup(ProductGroup value) {
    _$selectedGroupAtom.reportWrite(value, super.selectedGroup, () {
      super.selectedGroup = value;
    });
  }

  late final _$selectedCategoryAtom = Atom(
    name: 'NewOrderViewModelBase.selectedCategory',
    context: context,
  );

  @override
  String get selectedCategory {
    _$selectedCategoryAtom.reportRead();
    return super.selectedCategory;
  }

  @override
  set selectedCategory(String value) {
    _$selectedCategoryAtom.reportWrite(value, super.selectedCategory, () {
      super.selectedCategory = value;
    });
  }

  late final _$searchQueryAtom = Atom(
    name: 'NewOrderViewModelBase.searchQuery',
    context: context,
  );

  @override
  String get searchQuery {
    _$searchQueryAtom.reportRead();
    return super.searchQuery;
  }

  @override
  set searchQuery(String value) {
    _$searchQueryAtom.reportWrite(value, super.searchQuery, () {
      super.searchQuery = value;
    });
  }

  late final _$orderItemsAtom = Atom(
    name: 'NewOrderViewModelBase.orderItems',
    context: context,
  );

  @override
  ObservableList<OrderItem> get orderItems {
    _$orderItemsAtom.reportRead();
    return super.orderItems;
  }

  @override
  set orderItems(ObservableList<OrderItem> value) {
    _$orderItemsAtom.reportWrite(value, super.orderItems, () {
      super.orderItems = value;
    });
  }

  late final _$orderTypeAtom = Atom(
    name: 'NewOrderViewModelBase.orderType',
    context: context,
  );

  @override
  OrderType? get orderType {
    _$orderTypeAtom.reportRead();
    return super.orderType;
  }

  @override
  set orderType(OrderType? value) {
    _$orderTypeAtom.reportWrite(value, super.orderType, () {
      super.orderType = value;
    });
  }

  late final _$openingCashAtom = Atom(
    name: 'NewOrderViewModelBase.openingCash',
    context: context,
  );

  @override
  int? get openingCash {
    _$openingCashAtom.reportRead();
    return super.openingCash;
  }

  @override
  set openingCash(int? value) {
    _$openingCashAtom.reportWrite(value, super.openingCash, () {
      super.openingCash = value;
    });
  }

  late final _$isOpeningCashResolvedAtom = Atom(
    name: 'NewOrderViewModelBase.isOpeningCashResolved',
    context: context,
  );

  @override
  bool get isOpeningCashResolved {
    _$isOpeningCashResolvedAtom.reportRead();
    return super.isOpeningCashResolved;
  }

  @override
  set isOpeningCashResolved(bool value) {
    _$isOpeningCashResolvedAtom.reportWrite(
      value,
      super.isOpeningCashResolved,
      () {
        super.isOpeningCashResolved = value;
      },
    );
  }

  late final _$loadProductsAsyncAction = AsyncAction(
    'NewOrderViewModelBase.loadProducts',
    context: context,
  );

  @override
  Future<void> loadProducts({bool forceRefresh = false}) {
    return _$loadProductsAsyncAction.run(
      () => super.loadProducts(forceRefresh: forceRefresh),
    );
  }

  late final _$NewOrderViewModelBaseActionController = ActionController(
    name: 'NewOrderViewModelBase',
    context: context,
  );

  @override
  void selectGroup(ProductGroup group) {
    final _$actionInfo = _$NewOrderViewModelBaseActionController.startAction(
      name: 'NewOrderViewModelBase.selectGroup',
    );
    try {
      return super.selectGroup(group);
    } finally {
      _$NewOrderViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void selectCategory(String category) {
    final _$actionInfo = _$NewOrderViewModelBaseActionController.startAction(
      name: 'NewOrderViewModelBase.selectCategory',
    );
    try {
      return super.selectCategory(category);
    } finally {
      _$NewOrderViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onSearchChanged(String value) {
    final _$actionInfo = _$NewOrderViewModelBaseActionController.startAction(
      name: 'NewOrderViewModelBase.onSearchChanged',
    );
    try {
      return super.onSearchChanged(value);
    } finally {
      _$NewOrderViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void selectOrderType(OrderType type) {
    final _$actionInfo = _$NewOrderViewModelBaseActionController.startAction(
      name: 'NewOrderViewModelBase.selectOrderType',
    );
    try {
      return super.selectOrderType(type);
    } finally {
      _$NewOrderViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addProduct(Product product) {
    final _$actionInfo = _$NewOrderViewModelBaseActionController.startAction(
      name: 'NewOrderViewModelBase.addProduct',
    );
    try {
      return super.addProduct(product);
    } finally {
      _$NewOrderViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void decreaseProduct(Product product) {
    final _$actionInfo = _$NewOrderViewModelBaseActionController.startAction(
      name: 'NewOrderViewModelBase.decreaseProduct',
    );
    try {
      return super.decreaseProduct(product);
    } finally {
      _$NewOrderViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearOrder() {
    final _$actionInfo = _$NewOrderViewModelBaseActionController.startAction(
      name: 'NewOrderViewModelBase.clearOrder',
    );
    try {
      return super.clearOrder();
    } finally {
      _$NewOrderViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void confirmOpeningCash(int? amount) {
    final _$actionInfo = _$NewOrderViewModelBaseActionController.startAction(
      name: 'NewOrderViewModelBase.confirmOpeningCash',
    );
    try {
      return super.confirmOpeningCash(amount);
    } finally {
      _$NewOrderViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
products: ${products},
isLoading: ${isLoading},
errorMessage: ${errorMessage},
selectedGroup: ${selectedGroup},
selectedCategory: ${selectedCategory},
searchQuery: ${searchQuery},
orderItems: ${orderItems},
orderType: ${orderType},
openingCash: ${openingCash},
isOpeningCashResolved: ${isOpeningCashResolved},
categories: ${categories},
visibleProducts: ${visibleProducts},
hasOrderItems: ${hasOrderItems},
totalQuantity: ${totalQuantity},
totalPrice: ${totalPrice}
    ''';
  }
}
