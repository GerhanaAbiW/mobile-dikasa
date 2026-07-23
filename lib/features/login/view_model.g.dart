// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LoginViewModel on LoginViewModelBase, Store {
  late final _$usernameAtom = Atom(
    name: 'LoginViewModelBase.username',
    context: context,
  );

  @override
  String get username {
    _$usernameAtom.reportRead();
    return super.username;
  }

  @override
  set username(String value) {
    _$usernameAtom.reportWrite(value, super.username, () {
      super.username = value;
    });
  }

  late final _$passwordAtom = Atom(
    name: 'LoginViewModelBase.password',
    context: context,
  );

  @override
  String get password {
    _$passwordAtom.reportRead();
    return super.password;
  }

  @override
  set password(String value) {
    _$passwordAtom.reportWrite(value, super.password, () {
      super.password = value;
    });
  }

  late final _$isPasswordHiddenAtom = Atom(
    name: 'LoginViewModelBase.isPasswordHidden',
    context: context,
  );

  @override
  bool get isPasswordHidden {
    _$isPasswordHiddenAtom.reportRead();
    return super.isPasswordHidden;
  }

  @override
  set isPasswordHidden(bool value) {
    _$isPasswordHiddenAtom.reportWrite(value, super.isPasswordHidden, () {
      super.isPasswordHidden = value;
    });
  }

  late final _$isSubmittingAtom = Atom(
    name: 'LoginViewModelBase.isSubmitting',
    context: context,
  );

  @override
  bool get isSubmitting {
    _$isSubmittingAtom.reportRead();
    return super.isSubmitting;
  }

  @override
  set isSubmitting(bool value) {
    _$isSubmittingAtom.reportWrite(value, super.isSubmitting, () {
      super.isSubmitting = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: 'LoginViewModelBase.errorMessage',
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

  late final _$loggedInUserAtom = Atom(
    name: 'LoginViewModelBase.loggedInUser',
    context: context,
  );

  @override
  User? get loggedInUser {
    _$loggedInUserAtom.reportRead();
    return super.loggedInUser;
  }

  @override
  set loggedInUser(User? value) {
    _$loggedInUserAtom.reportWrite(value, super.loggedInUser, () {
      super.loggedInUser = value;
    });
  }

  late final _$submitAsyncAction = AsyncAction(
    'LoginViewModelBase.submit',
    context: context,
  );

  @override
  Future<bool> submit() {
    return _$submitAsyncAction.run(() => super.submit());
  }

  late final _$LoginViewModelBaseActionController = ActionController(
    name: 'LoginViewModelBase',
    context: context,
  );

  @override
  void onUsernameChanged(String value) {
    final _$actionInfo = _$LoginViewModelBaseActionController.startAction(
      name: 'LoginViewModelBase.onUsernameChanged',
    );
    try {
      return super.onUsernameChanged(value);
    } finally {
      _$LoginViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onPasswordChanged(String value) {
    final _$actionInfo = _$LoginViewModelBaseActionController.startAction(
      name: 'LoginViewModelBase.onPasswordChanged',
    );
    try {
      return super.onPasswordChanged(value);
    } finally {
      _$LoginViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void togglePasswordVisibility() {
    final _$actionInfo = _$LoginViewModelBaseActionController.startAction(
      name: 'LoginViewModelBase.togglePasswordVisibility',
    );
    try {
      return super.togglePasswordVisibility();
    } finally {
      _$LoginViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void reset() {
    final _$actionInfo = _$LoginViewModelBaseActionController.startAction(
      name: 'LoginViewModelBase.reset',
    );
    try {
      return super.reset();
    } finally {
      _$LoginViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _clearError() {
    final _$actionInfo = _$LoginViewModelBaseActionController.startAction(
      name: 'LoginViewModelBase._clearError',
    );
    try {
      return super._clearError();
    } finally {
      _$LoginViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
username: ${username},
password: ${password},
isPasswordHidden: ${isPasswordHidden},
isSubmitting: ${isSubmitting},
errorMessage: ${errorMessage},
loggedInUser: ${loggedInUser}
    ''';
  }
}
