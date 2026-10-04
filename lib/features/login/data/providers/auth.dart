import 'dart:developer';
import 'package:calender/core/services/info_service.dart';
import 'package:calender/features/dashboard/presentation/dashboard.dart';
import 'package:calender/features/main_page/presentation/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/enums/constants_enums.dart';
import '../../../../core/helper/help_functions.dart';
import '../../../../core/local_services/local_storage.dart';
import '../../presentation/login.dart';
import '../models/user_model.dart';
import '../repository/user_repository.dart';
import '../repository/user_repository_impl.dart';
import 'save_user.dart';
part 'generated/auth.g.dart';

@riverpod
class Auth extends _$Auth {
  late FirebaseAuth _auth;
  late UserRepository _userRepository;
  GoogleSignIn googleSignIn = GoogleSignIn.instance;

  @override
  AuthState build() {
    _auth = FirebaseAuth.instance;
    _userRepository = UserRepositoryImpl.instance;
    _googleInit();
    return AuthState();
  }

  void _googleInit() async {
    if (kIsWeb) {
      await googleSignIn.initialize();
      return;
    }
    await googleSignIn.initialize(
      serverClientId:
          '1018474349122-t61b39e8nbvqcbdqjfc85h75c5k7oa93.apps.googleusercontent.com',
    );
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    // Check if context is still mounted before starting
    if (!context.mounted) return;

    state = state.copyWith(isLoading: true);
    try {
      UserCredential userCredential;
      if (kIsWeb) {
        // 🚀 Web popup login (account picker)
        final googleProvider = GoogleAuthProvider();
        userCredential = await _auth.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount googleUser =
            await googleSignIn.authenticate();

        final GoogleSignInAuthentication googleSignInAuthentication =
            googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
        );

        userCredential = await _auth.signInWithCredential(credential);
        if (!ref.mounted) return;
      }
      if (userCredential.user == null) {
        state = state.copyWith(isLoading: false);
        return;
      }

      final User? user = userCredential.user;

      final UserModel userModel = UserModel(
        id: user?.uid ?? '',
        email: user?.email ?? '',
        avatar: user?.photoURL ?? '',
        name: user?.displayName ?? '',
        phone: user?.phoneNumber ?? '',
        deviceId: await DeviceInfoService().getDeviceId(),
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
        isVerified: false,
        isBlocked: false,
      );
      await _userRepository.addUser(userModel);
      if (context.mounted) {
        if (kIsWeb) {
          final userDoc = await _userRepository.getUserById(userModel.id ?? '');
          if (userDoc?.isVerified == true) {
            if (!context.mounted) return;
            context.go(DashboardPage.routeName);
          } else {
            if (!context.mounted) return;
            showSnackBar(
              message: 'Please wait verify your account',
              width: 300,
            );
          }
        } else {
          context.go(MainPage.routeName);
        }
      }
      await LocalStorage.instance.add(Constants.loginKey.name, true);

      state = state.copyWith(isLoading: false, user: userModel);
    } on GoogleSignInException catch (e) {
      log('on FirebaseAuthException catch ($e)');
      if (context.mounted) {
        showSnackBar(
          message: e.description ?? 'Something went wrong',
          width: 600,
        );
      }
      // Check if provider is still mounted before updating state
      if (!ref.mounted) return;

      state = state.copyWith(isLoading: false);
    } catch (e) {
      log('catch ($e)');
      if (context.mounted) {
        showSnackBar(message: e.toString(), width: 700);
      }
      // Check if provider is still mounted before updating state
      if (!ref.mounted) return;
      state = state.copyWith(isLoading: false);
    } finally {
      if (ref.mounted) {
        state = state.copyWith(isLoading: false);
      }
    }
  }

  Future<void> updateUser(UserModel userModel) async {
    state = state.copyWith(isLoading: true);
    try {
      if (_auth.currentUser?.uid == null) {
        state = state.copyWith(isLoading: false);
        return;
      }
      await _userRepository.updateUser(userModel);
      if (!ref.mounted) return;

      state = state.copyWith(isLoading: false, user: userModel);
    } catch (e) {
      log('Error updating user data: $e');

      state = state.copyWith(isLoading: false, user: null, error: e.toString());
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      await googleSignIn.signOut();
      await SaveUser.instance.deleteUserData();
      if (context.mounted) {
        context.go(LoginPage.routeName);
      }
      // Check if provider is still mounted before updating state
      if (!ref.mounted) return;

      state = state.copyWith(isLoading: false, user: null);
    } catch (e) {
      log('Error signing out: $e');
      // Check if provider is still mounted before updating state
      if (!context.mounted) return;
      showSnackBar(message: e.toString());
      if (!ref.mounted) return;
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> deleteAccount(BuildContext context) async {
    try {
      await _auth.currentUser?.reload();
      await _userRepository.deleteUser(_auth.currentUser?.uid ?? '');
      if (!kIsWeb) {
        await _auth.currentUser?.delete();
      }

      await googleSignIn.signOut();
      await googleSignIn.disconnect();
      await _auth.signOut();
      await LocalStorage.instance.delete(Constants.loginKey.name);
      if (context.mounted) {
        context.go(LoginPage.routeName);
      }
      // Check if provider is still mounted before updating state
      if (!ref.mounted) return;

      state = state.copyWith(isLoading: false, user: null);
    } catch (e) {
      log('Error delete account: $e');
      // Check if provider is still mounted before updating state
      if (!context.mounted) return;
      showSnackBar(message: e.toString());
      if (!ref.mounted) return;
      state = state.copyWith(isLoading: false);
    }
  }
}

class AuthState {
  bool? isLoading;
  UserModel? user;
  String? error;

  AuthState({this.isLoading, this.user, this.error});

  AuthState copyWith({bool? isLoading, UserModel? user, String? error}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }
}
