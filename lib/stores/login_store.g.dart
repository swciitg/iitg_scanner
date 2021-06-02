// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$LoginStore on LoginStoreBase, Store {
  final _$firebaseUserAtom = Atom(name: 'LoginStoreBase.firebaseUser');

  @override
  User get firebaseUser {
    _$firebaseUserAtom.reportRead();
    return super.firebaseUser;
  }

  @override
  set firebaseUser(User value) {
    _$firebaseUserAtom.reportWrite(value, super.firebaseUser, () {
      super.firebaseUser = value;
    });
  }

  final _$userDataAtom = Atom(name: 'LoginStoreBase.userData');

  @override
  Map<String, String> get userData {
    _$userDataAtom.reportRead();
    return super.userData;
  }

  @override
  set userData(Map<String, String> value) {
    _$userDataAtom.reportWrite(value, super.userData, () {
      super.userData = value;
    });
  }

  final _$isAlreadyAuthenticatedAsyncAction =
  AsyncAction('LoginStoreBase.isAlreadyAuthenticated');

  @override
  Future<bool> isAlreadyAuthenticated() {
    return _$isAlreadyAuthenticatedAsyncAction
        .run(() => super.isAlreadyAuthenticated());
  }

  final _$signInWithMicrosoftAsyncAction =
  AsyncAction('LoginStoreBase.signInWithMicrosoft');

  @override
  Future<void> signInWithMicrosoft(BuildContext context) {
    return _$signInWithMicrosoftAsyncAction
        .run(() => super.signInWithMicrosoft(context));
  }

  final _$signOutAsyncAction = AsyncAction('LoginStoreBase.signOut');

  @override
  Future<void> signOut(BuildContext context) {
    return _$signOutAsyncAction.run(() => super.signOut(context));
  }

  @override
  String toString() {
    return '''
firebaseUser: ${firebaseUser},
userData: ${userData}
    ''';
  }
}