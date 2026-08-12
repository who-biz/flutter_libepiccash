import 'dart:ffi';
import 'dart:io' as io;

import 'package:ffi/ffi.dart';

final DynamicLibrary epicCashNative = io.Platform.isWindows
    ? DynamicLibrary.open("libepic_cash_wallet.dll")
    : io.Platform.environment.containsKey('FLUTTER_TEST')
        ? DynamicLibrary.open(
            'crypto_plugins/flutter_libepiccash/scripts/linux/build/libepic_cash_wallet.so')
        : io.Platform.isAndroid || io.Platform.isLinux
            ? DynamicLibrary.open('libepic_cash_wallet.so')
            : DynamicLibrary.process();

typedef RustStringFree = Void Function(Pointer<Utf8>);
typedef RustStringFreeFFI = void Function(Pointer<Utf8>);

final RustStringFreeFFI _rustStringFree = epicCashNative
    .lookup<NativeFunction<RustStringFree>>(
      'rust_string_free',
    )
    .asFunction();

String takeRustString(Pointer<Utf8> ptr) {
  if (ptr == nullptr) {
    throw StateError('Rust returned a null string');
  }

  try {
    return ptr.toDartString();
  } finally {
    _rustStringFree(ptr);
  }
}

typedef WalletMnemonic = Pointer<Utf8> Function();
typedef WalletMnemonicFFI = Pointer<Utf8> Function();

typedef WalletInit = Pointer<Utf8> Function(
    Pointer<Utf8>, Pointer<Utf8>, Pointer<Utf8>, Pointer<Utf8>);
typedef WalletInitFFI = Pointer<Utf8> Function(
    Pointer<Utf8>, Pointer<Utf8>, Pointer<Utf8>, Pointer<Utf8>);

typedef WalletInfo = Pointer<Utf8> Function(
    Pointer<Utf8>, Pointer<Int8>, Pointer<Int8>);
typedef WalletInfoFFI = Pointer<Utf8> Function(
    Pointer<Utf8>, Pointer<Int8>, Pointer<Int8>);

typedef RecoverWallet = Pointer<Utf8> Function(
    Pointer<Utf8>, Pointer<Utf8>, Pointer<Utf8>, Pointer<Utf8>);
typedef RecoverWalletFFI = Pointer<Utf8> Function(
    Pointer<Utf8>, Pointer<Utf8>, Pointer<Utf8>, Pointer<Utf8>);

typedef WalletPhrase = Pointer<Utf8> Function(Pointer<Utf8>, Pointer<Utf8>);
typedef WalletPhraseFFI = Pointer<Utf8> Function(Pointer<Utf8>, Pointer<Utf8>);

typedef ScanOutPuts = Pointer<Utf8> Function(
    Pointer<Utf8>, Pointer<Int8>, Pointer<Int8>);
typedef ScanOutPutsFFI = Pointer<Utf8> Function(
    Pointer<Utf8>, Pointer<Int8>, Pointer<Int8>);

typedef CreateTransaction = Pointer<Utf8> Function(
  Pointer<Utf8>, // wallet
  Pointer<Int8>, // amount
  Pointer<Utf8>, // to_address
  Pointer<Int8>, // secret_key_index
  Pointer<Utf8>, // epicbox_config
  Pointer<Int8>, // confirmations
  Pointer<Utf8>, // note
  Pointer<Int8>, // return_slate_flag
);
typedef CreateTransactionFFI = Pointer<Utf8> Function(
  Pointer<Utf8>,
  Pointer<Int8>,
  Pointer<Utf8>,
  Pointer<Int8>,
  Pointer<Utf8>,
  Pointer<Int8>,
  Pointer<Utf8>,
  Pointer<Int8>, // return_slate_flag
);

typedef EpicboxListenerStart = Pointer<Void> Function(
    Pointer<Utf8>, Pointer<Utf8>);
typedef EpicboxListenerStartFFI = Pointer<Void> Function(
    Pointer<Utf8>, Pointer<Utf8>);

typedef EpicboxListenerStop = Pointer<Utf8> Function(Pointer<Void>);
typedef EpicboxListenerStopFFI = Pointer<Utf8> Function(Pointer<Void>);

typedef EpicboxListenerIsRunning = Pointer<Utf8> Function(Pointer<Void>);
typedef EpicboxListenerIsRunningFFI = Pointer<Utf8> Function(Pointer<Void>);

typedef GetTransactions = Pointer<Utf8> Function(Pointer<Utf8>, Pointer<Int8>);
typedef GetTransactionsFFI = Pointer<Utf8> Function(
    Pointer<Utf8>, Pointer<Int8>);

typedef CancelEpicboxTransaction = Pointer<Utf8> Function(
  Pointer<Utf8>, // wallet
  Pointer<Int8>, // method_is_epicbox
  Pointer<Utf8>, // epicbox_config
  Pointer<Int8>, // tx_id
  Pointer<Utf8>, // tx_slate_id
  Pointer<Utf8>, // epicbox_msg_id
);
typedef CancelEpicboxTransactionFFI = Pointer<Utf8> Function(
  Pointer<Utf8>,
  Pointer<Int8>,
  Pointer<Utf8>,
  Pointer<Int8>,
  Pointer<Utf8>,
  Pointer<Utf8>,
);

typedef GetChainHeight = Pointer<Utf8> Function(Pointer<Utf8>);
typedef GetChainHeightFFI = Pointer<Utf8> Function(Pointer<Utf8>);

typedef AddressInfo = Pointer<Utf8> Function(
    Pointer<Utf8>, Pointer<Int8>, Pointer<Utf8>);
typedef AddressInfoFFI = Pointer<Utf8> Function(
    Pointer<Utf8>, Pointer<Int8>, Pointer<Utf8>);

typedef ValidateAddress = Pointer<Utf8> Function(Pointer<Utf8>);
typedef ValidateAddressFFI = Pointer<Utf8> Function(Pointer<Utf8>);

typedef TransactionFees = Pointer<Utf8> Function(
    Pointer<Utf8>, Pointer<Int8>, Pointer<Int8>);
typedef TransactionFeesFFI = Pointer<Utf8> Function(
    Pointer<Utf8>, Pointer<Int8>, Pointer<Int8>);

typedef DeleteWallet = Pointer<Utf8> Function(Pointer<Utf8>, Pointer<Utf8>);
typedef DeleteWalletFFI = Pointer<Utf8> Function(Pointer<Utf8>, Pointer<Utf8>);

typedef OpenWallet = Pointer<Utf8> Function(Pointer<Utf8>, Pointer<Utf8>);
typedef OpenWalletFFI = Pointer<Utf8> Function(Pointer<Utf8>, Pointer<Utf8>);

typedef TxHttpSend = Pointer<Utf8> Function(Pointer<Utf8>, Pointer<Int8>,
    Pointer<Int8>, Pointer<Utf8>, Pointer<Int8>, Pointer<Utf8>);
typedef TxHttpSendFFI = Pointer<Utf8> Function(Pointer<Utf8>, Pointer<Int8>,
    Pointer<Int8>, Pointer<Utf8>, Pointer<Int8>, Pointer<Utf8>);

final WalletMnemonic _walletMnemonic = epicCashNative
    .lookup<NativeFunction<WalletMnemonicFFI>>("get_mnemonic")
    .asFunction();

String walletMnemonic() {
  final ptr = _walletMnemonic();
  return takeRustString(ptr);
}

final WalletInit _initWallet = epicCashNative
    .lookup<NativeFunction<WalletInitFFI>>("wallet_init")
    .asFunction();

String initWallet(
  String config,
  String mnemonic,
  String password,
  String name,
) {
  final configPtr = config.toNativeUtf8();
  final mnemonicPtr = mnemonic.toNativeUtf8();
  final passwordPtr = password.toNativeUtf8();
  final namePtr = name.toNativeUtf8();

  try {
    final resultPtr = _initWallet(
      configPtr,
      mnemonicPtr,
      passwordPtr,
      namePtr,
    );

    return takeRustString(resultPtr);
  } finally {
    malloc.free(configPtr);
    malloc.free(mnemonicPtr);
    malloc.free(passwordPtr);
    malloc.free(namePtr);
  }
}

final WalletInfo _walletInfo = epicCashNative
    .lookup<NativeFunction<WalletInfoFFI>>("rust_wallet_balances")
    .asFunction();

Future<String> getWalletInfo(
  String wallet,
  int refreshFromNode,
  int min_confirmations,
) async {
  final walletPtr = wallet.toNativeUtf8();
  final refreshFromNodePtr =
      refreshFromNode.toString().toNativeUtf8().cast<Int8>();
  final minConfPtr = min_confirmations.toString().toNativeUtf8().cast<Int8>();

  try {
    final resultPtr = _walletInfo(
      walletPtr,
      refreshFromNodePtr,
      minConfPtr,
    );

    return takeRustString(resultPtr);
  } finally {
    malloc.free(walletPtr);
    malloc.free(refreshFromNodePtr);
    malloc.free(minConfPtr);
  }
}

final RecoverWallet _recoverWallet = epicCashNative
    .lookup<NativeFunction<RecoverWalletFFI>>("rust_recover_from_mnemonic")
    .asFunction();

String recoverWallet(
  String config,
  String password,
  String mnemonic,
  String name,
) {
  final configPtr = config.toNativeUtf8();
  final passwordPtr = password.toNativeUtf8();
  final mnemonicPtr = mnemonic.toNativeUtf8();
  final namePtr = name.toNativeUtf8();

  try {
    final resultPtr = _recoverWallet(configPtr, passwordPtr, mnemonicPtr, namePtr);

    return takeRustString(resultPtr);
  } finally {
    malloc.free(configPtr);
    malloc.free(passwordPtr);
    malloc.free(mnemonicPtr);
    malloc.free(namePtr);
  }
}

final ScanOutPuts _scanOutPuts = epicCashNative
    .lookup<NativeFunction<ScanOutPutsFFI>>("rust_wallet_scan_outputs")
    .asFunction();

Future<String> scanOutPuts(
  String wallet,
  int startHeight,
  int numberOfBlocks,
) async {
  final walletPtr = wallet.toNativeUtf8();
  final startHeightPtr = startHeight.toString().toNativeUtf8().cast<Int8>();
  final numberOfBlocksPtr =
      numberOfBlocks.toString().toNativeUtf8().cast<Int8>();

  try {
    final resultPtr = _scanOutPuts(
      walletPtr,
      startHeightPtr,
      numberOfBlocksPtr,
    );

    return takeRustString(resultPtr);
  } finally {
    malloc.free(walletPtr);
    malloc.free(startHeightPtr);
    malloc.free(numberOfBlocksPtr);
  }
}

final EpicboxListenerStart _epicboxListenerStart = epicCashNative
    .lookup<NativeFunction<EpicboxListenerStartFFI>>(
        "rust_epicbox_listener_start")
    .asFunction();

Pointer<Void> epicboxListenerStart(
  String wallet,
  String epicboxConfig,
) {
  final walletPtr = wallet.toNativeUtf8();
  final epicboxConfigPtr = epicboxConfig.toNativeUtf8();

  try {
    final result =
        _epicboxListenerStart(walletPtr, epicboxConfigPtr);

    if (result == nullptr) {
      throw StateError(
        'rust_epicbox_listener_start returned null',
      );
    }

    return result;
  } finally {
    malloc.free(walletPtr);
    malloc.free(epicboxConfigPtr);
  }
}

final EpicboxListenerStop _epicboxListenerStop = epicCashNative
    .lookup<NativeFunction<EpicboxListenerStopFFI>>("_listener_cancel")
    .asFunction();

bool epicboxListenerStop(Pointer<Void> handler) {
  if (handler == nullptr) {
    return false;
  }

  try {
    final ptr = _epicboxListenerStop(handler);
    return takeRustString(ptr) == "true";
  } catch (_) {
    return false;
  }
}

final EpicboxListenerIsRunning _epicboxListenerIsRunning = epicCashNative
    .lookup<NativeFunction<EpicboxListenerIsRunningFFI>>("_listener_is_running")
    .asFunction();

/// Check if the epicbox listener is still running.
/// Returns true if the listener is alive, false if it has stopped or handler is null.
bool epicboxListenerIsRunning(Pointer<Void> handler) {
  if (handler == nullptr) {
    return false;
  }

  try {
    final resultPtr = _epicboxListenerIsRunning(handler);
    return takeRustString(resultPtr) == "true";
  } catch (_) {
    return false;
  }
}

final CreateTransaction _createTransaction = epicCashNative
    .lookup<NativeFunction<CreateTransactionFFI>>("rust_create_tx")
    .asFunction();

Future<String> createTransaction(
  String wallet,
  int amount,
  String address,
  int secretKey,
  String epicboxConfig,
  int minimumConfirmations,
  String note, {
  bool returnSlate = false,
}) async {
  final walletPtr = wallet.toNativeUtf8();
  final amountPtr = amount.toString().toNativeUtf8().cast<Int8>();
  final addressPtr = address.toNativeUtf8();
  final secretKeyPtr = secretKey.toString().toNativeUtf8().cast<Int8>();
  final epicboxConfigPtr = epicboxConfig.toNativeUtf8();
  final minConfPtr =
      minimumConfirmations.toString().toNativeUtf8().cast<Int8>();
  final notePtr = note.toNativeUtf8();
  final returnSlatePtr = (returnSlate ? '1' : '0').toNativeUtf8().cast<Int8>();

  try {
    final resultPtr = _createTransaction(
      walletPtr,
      amountPtr,
      addressPtr,
      secretKeyPtr,
      epicboxConfigPtr,
      minConfPtr,
      notePtr,
      returnSlatePtr,
    );
    return takeRustString(resultPtr);
  } finally {
    malloc.free(walletPtr);
    malloc.free(amountPtr);
    malloc.free(addressPtr);
    malloc.free(secretKeyPtr);
    malloc.free(epicboxConfigPtr);
    malloc.free(minConfPtr);
    malloc.free(notePtr);
    malloc.free(returnSlatePtr);
  }
}

final GetTransactions _getTransactions = epicCashNative
    .lookup<NativeFunction<GetTransactionsFFI>>("rust_txs_get")
    .asFunction();

Future<String> getTransactions(String wallet, int refreshFromNode) async {
  final walletPtr = wallet.toNativeUtf8();
  final refreshFromNodePtr =
      refreshFromNode.toString().toNativeUtf8().cast<Int8>();

  try {
    final resultPtr = _getTransactions(walletPtr, refreshFromNodePtr);
    return takeRustString(resultPtr);
  } finally {
    malloc.free(walletPtr);
    malloc.free(refreshFromNodePtr);
  }
}

final CancelEpicboxTransaction _cancelEpicboxTransaction = epicCashNative
    .lookup<NativeFunction<CancelEpicboxTransactionFFI>>(
        "rust_epicbox_tx_cancel")
    .asFunction();

String cancelEpicboxTransaction(
  String wallet,
  bool methodIsEpicbox,
  String? epicboxConfig,
  int? txId,
  String? txSlateId,
  String? txEpicboxId,
) {
  final walletPtr = wallet.toNativeUtf8();
  final methodIsEpicboxPtr =
      (methodIsEpicbox ? '1' : '0').toNativeUtf8().cast<Int8>();
  final epicboxConfigPtr = (epicboxConfig ?? '').toNativeUtf8();
  final txIdPtr = (txId?.toString() ?? '').toNativeUtf8().cast<Int8>();
  final txSlateIdPtr = (txSlateId ?? '').toNativeUtf8();
  final txEpicboxIdPtr = (txEpicboxId ?? '').toNativeUtf8();

  try {
    final resultPtr = _cancelEpicboxTransaction(
      walletPtr,
      methodIsEpicboxPtr,
      epicboxConfigPtr,
      txIdPtr,
      txSlateIdPtr,
      txEpicboxIdPtr,
    );
    return takeRustString(resultPtr);
  } finally {
    malloc.free(walletPtr);
    malloc.free(methodIsEpicboxPtr);
    malloc.free(epicboxConfigPtr);
    malloc.free(txIdPtr);
    malloc.free(txSlateIdPtr);
    malloc.free(txEpicboxIdPtr);
  }
}

final GetChainHeight _getChainHeight = epicCashNative
    .lookup<NativeFunction<GetChainHeightFFI>>("rust_get_chain_height")
    .asFunction();

int getChainHeight(String config) {
  final configPtr = config.toNativeUtf8();

  try {
    final resultPtr = _getChainHeight(configPtr);
    final latestHeight = takeRustString(resultPtr);

    return int.parse(latestHeight);
  } finally {
    malloc.free(configPtr);
  }
}

final AddressInfo _addressInfo = epicCashNative
    .lookup<NativeFunction<AddressInfoFFI>>("rust_get_wallet_address")
    .asFunction();

String getAddressInfo(String wallet, int index, String epicboxConfig) {
  final walletPtr = wallet.toNativeUtf8();
  final indexPtr = index.toString().toNativeUtf8().cast<Int8>();
  final epicboxConfigPtr = epicboxConfig.toNativeUtf8();

  try {
    final resultPtr = _addressInfo(walletPtr, indexPtr, epicboxConfigPtr);
    return takeRustString(resultPtr);
  } finally {
    malloc.free(walletPtr);
    malloc.free(indexPtr);
    malloc.free(epicboxConfigPtr);
  }
}

final ValidateAddress _validateSendAddress = epicCashNative
    .lookup<NativeFunction<ValidateAddressFFI>>("rust_validate_address")
    .asFunction();

String validateSendAddress(String address) {
  final addressPtr = address.toNativeUtf8();

  try {
    final resultPtr = _validateSendAddress(addressPtr);
    return takeRustString(resultPtr);
  } finally {
    malloc.free(addressPtr);
  }
}

final TransactionFees _transactionFees = epicCashNative
    .lookup<NativeFunction<TransactionFeesFFI>>("rust_get_tx_fees")
    .asFunction();

Future<String> getTransactionFees(
  String wallet,
  int amount,
  int minimumConfirmations,
) async {
  final walletPtr = wallet.toNativeUtf8();
  final amountPtr = amount.toString().toNativeUtf8();
  final minConfPtr = minimumConfirmations.toString().toNativeUtf8();

  try {
    final resultPtr = _transactionFees(
        walletPtr, amountPtr.cast<Int8>(), minConfPtr.cast<Int8>());
    return takeRustString(resultPtr);
  } finally {
    malloc.free(walletPtr);
    malloc.free(amountPtr);
    malloc.free(minConfPtr);
  }
}

final DeleteWallet _deleteWallet = epicCashNative
    .lookup<NativeFunction<DeleteWalletFFI>>("rust_delete_wallet")
    .asFunction();

Future<String> deleteWallet(String wallet, String config) async {
  final configPtr = config.toNativeUtf8();
  final walletPtr = wallet.toNativeUtf8();
  try {
    final resultPtr = _deleteWallet(walletPtr, configPtr);
    return takeRustString(resultPtr);
  } finally {
    malloc.free(configPtr);
    malloc.free(walletPtr);
  }
}

final OpenWallet _openWallet = epicCashNative
    .lookup<NativeFunction<OpenWalletFFI>>("rust_open_wallet")
    .asFunction();

String openWallet(String config, String password) {
  final configPtr = config.toNativeUtf8();
  final pwPtr = password.toNativeUtf8();
  try {
    final resultPtr = _openWallet(configPtr, pwPtr);
    return takeRustString(resultPtr);
  } finally {
    malloc.free(configPtr);
    malloc.free(pwPtr);
  }
}

final TxHttpSend _txHttpSend = epicCashNative
    .lookup<NativeFunction<TxHttpSendFFI>>("rust_tx_send_http")
    .asFunction();

Future<String> txHttpSend(
  String wallet,
  int selectionStrategyIsAll,
  int minimumConfirmations,
  String message,
  int amount,
  String address,
) async {

  final walletPtr = wallet.toNativeUtf8();
  final stratPtr =
      selectionStrategyIsAll.toString().toNativeUtf8().cast<Int8>();
  final minConfsPtr =
      minimumConfirmations.toString().toNativeUtf8().cast<Int8>();
  final messagePtr = message.toNativeUtf8();
  final amountPtr = amount.toString().toNativeUtf8().cast<Int8>();
  final addressPtr = address.toNativeUtf8();

  try {
    final resultPtr = _txHttpSend(
      walletPtr,
      stratPtr,
      minConfsPtr,
      messagePtr,
      amountPtr,
      addressPtr,
    );

    return takeRustString(resultPtr);
  } finally {
    malloc.free(walletPtr);
    malloc.free(stratPtr);
    malloc.free(minConfsPtr);
    malloc.free(messagePtr);
    malloc.free(amountPtr);
    malloc.free(addressPtr);
  }
}

// Typedef for tx_receive FFI.
typedef TxReceive = Pointer<Utf8> Function(Pointer<Utf8>, Pointer<Utf8>);
typedef TxReceiveFFI = Pointer<Utf8> Function(Pointer<Utf8>, Pointer<Utf8>);

final TxReceive _txReceive = epicCashNative
    .lookup<NativeFunction<TxReceiveFFI>>("rust_tx_receive")
    .asFunction();

/// Receive a slate (step 2 of 3-part transaction).
///
/// The receiver opens an incoming slate, adds its output and partial signature,
/// then returns the updated slate.
String txReceive(String wallet, String slateJson) {
  final walletPtr = wallet.toNativeUtf8();
  final slateJsonPtr = slateJson.toNativeUtf8();

  try {
    final resultPtr = _txReceive(walletPtr, slateJsonPtr);
    return takeRustString(resultPtr);
  } finally {
    malloc.free(walletPtr);
    malloc.free(slateJsonPtr);
  }
}

// Typedef for tx_finalize FFI.
typedef TxFinalize = Pointer<Utf8> Function(Pointer<Utf8>, Pointer<Utf8>);
typedef TxFinalizeFFI = Pointer<Utf8> Function(Pointer<Utf8>, Pointer<Utf8>);

final TxFinalize _txFinalize = epicCashNative
    .lookup<NativeFunction<TxFinalizeFFI>>("rust_tx_finalize")
    .asFunction();

/// Finalize a slate (step 3 of 3-part transaction).
///
/// The original sender finalizes the transaction with the receiver's response
/// and broadcasts it to the network.
String txFinalize(String wallet, String slateJson) {
  final walletPtr = wallet.toNativeUtf8();
  final slateJsonPtr = slateJson.toNativeUtf8();

  try {
    final resultPtr = _txFinalize(walletPtr, slateJsonPtr);
    return takeRustString(resultPtr);
  } finally {
    malloc.free(walletPtr);
    malloc.free(slateJsonPtr);
  }
}
