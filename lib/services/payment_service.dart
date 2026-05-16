import 'package:flutter/foundation.dart';

/// Payment method enum
enum PaymentMethod { mobileMoney, creditCard, bankTransfer }

/// Payment result
class PaymentResult {
  final bool success;
  final String? transactionId;
  final String? errorMessage;
  final PaymentMethod method;

  PaymentResult({
    required this.success,
    this.transactionId,
    this.errorMessage,
    required this.method,
  });
}

/// Mobile money provider enum
enum MobileMoneyProvider { mtnMoMo, airtelMoney, vodafoneCash, orangeMoney }

/// Abstract payment service
abstract class PaymentService {
  Future<void> initialize();
  Future<PaymentResult> processPayment({
    required double amount,
    required String currency,
    required String phoneNumber,
    required MobileMoneyProvider provider,
    required String orderId,
  });
  Future<PaymentResult> verifyPayment(String transactionId);
  Future<void> refundPayment(String transactionId, double amount);
  Stream<PaymentResult> get paymentUpdates;
  bool get isInitialized;
}

/// Factory to create appropriate payment service
class PaymentServiceFactory {
  static PaymentService create() {
    if (kIsWeb) {
      return WebPaymentService();
    } else {
      return MobilePaymentService();
    }
  }
}

/// Mobile payment implementation
class MobilePaymentService implements PaymentService {
  @override
  Future<void> initialize() async {
    // TODO: Initialize payment SDKs (Stripe, Mobile Money)
    debugPrint('Mobile Payment Service initialized');
  }

  @override
  Future<PaymentResult> processPayment({
    required double amount,
    required String currency,
    required String phoneNumber,
    required MobileMoneyProvider provider,
    required String orderId,
  }) async {
    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 2));

    // Simulate success (90% success rate for demo)
    if (DateTime.now().millisecond % 10 != 0) {
      final transactionId = 'TXN-${DateTime.now().millisecondsSinceEpoch}';
      debugPrint('Payment successful: $transactionId');
      return PaymentResult(
        success: true,
        transactionId: transactionId,
        method: PaymentMethod.mobileMoney,
      );
    } else {
      return PaymentResult(
        success: false,
        errorMessage: 'Payment failed. Please try again.',
        method: PaymentMethod.mobileMoney,
      );
    }
  }

  @override
  Future<PaymentResult> verifyPayment(String transactionId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return PaymentResult(
      success: true,
      transactionId: transactionId,
      method: PaymentMethod.mobileMoney,
    );
  }

  @override
  Future<void> refundPayment(String transactionId, double amount) async {
    await Future.delayed(const Duration(milliseconds: 500));
    debugPrint(
      'Refund processed for transaction: $transactionId, amount: $amount',
    );
  }

  @override
  Stream<PaymentResult> get paymentUpdates {
    return const Stream.empty();
  }

  @override
  bool get isInitialized => true;
}

/// Web payment implementation (mock)
class WebPaymentService implements PaymentService {
  @override
  Future<void> initialize() async {
    debugPrint('Web Payment Service initialized (demo mode)');
  }

  @override
  Future<PaymentResult> processPayment({
    required double amount,
    required String currency,
    required String phoneNumber,
    required MobileMoneyProvider provider,
    required String orderId,
  }) async {
    // Simulate mobile money payment
    await Future.delayed(const Duration(seconds: 2));

    // Simulate success
    final transactionId = 'WEB-TXN-${DateTime.now().millisecondsSinceEpoch}';
    debugPrint('Web Payment processed: $transactionId for $currency $amount');

    return PaymentResult(
      success: true,
      transactionId: transactionId,
      method: PaymentMethod.mobileMoney,
    );
  }

  @override
  Future<PaymentResult> verifyPayment(String transactionId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return PaymentResult(
      success: true,
      transactionId: transactionId,
      method: PaymentMethod.mobileMoney,
    );
  }

  @override
  Future<void> refundPayment(String transactionId, double amount) async {
    debugPrint('Web refund: $transactionId, amount: $amount');
  }

  @override
  Stream<PaymentResult> get paymentUpdates {
    return const Stream.empty();
  }

  @override
  bool get isInitialized => true;
}
