class UpdateBankDetails {
  int? status;
  String? msg;
  int? success;
  BankData? data;

  UpdateBankDetails({this.status, this.msg, this.success, this.data});

  UpdateBankDetails.fromJson(Map<String, dynamic> json) {
    status = _toInt(json['status']);
    msg = json['msg']?.toString();
    success = _toInt(json['success']);
    data = json['data'] != null ? BankData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'msg': msg,
      'success': success,
      if (data != null) 'data': data!.toJson(),
    };
  }
}

class GetBankDetails {
  int? status;
  String? msg;
  int? success;
  BankData? data;

  GetBankDetails({this.status, this.msg, this.success, this.data});

  GetBankDetails.fromJson(Map<String, dynamic> json) {
    status = _toInt(json['status']);
    msg = json['msg']?.toString();
    success = _toInt(json['success']);
    data = json['data'] != null ? BankData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'msg': msg,
      'success': success,
      if (data != null) 'data': data!.toJson(),
    };
  }
}

class BankData {
  dynamic bankName;
  dynamic ifscCode;
  dynamic accountNo;
  dynamic accountHolderName;

  int stripeAvailable = 0;
  String stripePublishableKey = '';
  String stripeCurrency = '';
  String stripeCountry = '';
  double stripeCommissionPercent = 0;
  String stripeAccountId = '';
  String stripeAccountStatus = 'not_connected';
  int detailsSubmitted = 0;
  int chargesEnabled = 0;
  int payoutsEnabled = 0;
  int onboardingRequired = 1;
  String onboardingUrl = '';

  BankData({
    this.bankName,
    this.ifscCode,
    this.accountNo,
    this.accountHolderName,
    this.stripeAvailable = 0,
    this.stripePublishableKey = '',
    this.stripeCurrency = '',
    this.stripeCountry = '',
    this.stripeCommissionPercent = 0,
    this.stripeAccountId = '',
    this.stripeAccountStatus = 'not_connected',
    this.detailsSubmitted = 0,
    this.chargesEnabled = 0,
    this.payoutsEnabled = 0,
    this.onboardingRequired = 1,
    this.onboardingUrl = '',
  });

  BankData.fromJson(Map<String, dynamic> json) {
    bankName = json['bank_name'];
    ifscCode = json['ifsc_code'];
    accountNo = json['account_no'];
    accountHolderName = json['account_holder_name'];

    stripeAvailable = _toInt(json['stripe_available']);
    stripePublishableKey = json['stripe_publishable_key']?.toString() ?? '';
    stripeCurrency = json['stripe_currency']?.toString() ?? '';
    stripeCountry = json['stripe_country']?.toString() ?? '';
    stripeCommissionPercent = _toDouble(json['stripe_commission_percent']);
    stripeAccountId = json['stripe_account_id']?.toString() ?? '';
    stripeAccountStatus =
        json['stripe_account_status']?.toString() ?? 'not_connected';
    detailsSubmitted = _toInt(json['details_submitted']);
    chargesEnabled = _toInt(json['charges_enabled']);
    payoutsEnabled = _toInt(json['payouts_enabled']);
    onboardingRequired = _toInt(json['onboarding_required']);
    onboardingUrl = json['onboarding_url']?.toString() ?? '';
  }

  bool get isStripeActive =>
      stripeAccountStatus == 'active' &&
      chargesEnabled == 1 &&
      payoutsEnabled == 1;

  bool get needsOnboarding => onboardingRequired == 1 || !isStripeActive;

  Map<String, dynamic> toJson() {
    return {
      'bank_name': bankName,
      'ifsc_code': ifscCode,
      'account_no': accountNo,
      'account_holder_name': accountHolderName,
      'stripe_available': stripeAvailable,
      'stripe_publishable_key': stripePublishableKey,
      'stripe_currency': stripeCurrency,
      'stripe_country': stripeCountry,
      'stripe_commission_percent': stripeCommissionPercent,
      'stripe_account_id': stripeAccountId,
      'stripe_account_status': stripeAccountStatus,
      'details_submitted': detailsSubmitted,
      'charges_enabled': chargesEnabled,
      'payouts_enabled': payoutsEnabled,
      'onboarding_required': onboardingRequired,
      'onboarding_url': onboardingUrl,
    };
  }
}

int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is bool) return value ? 1 : 0;
  return int.tryParse(value.toString()) ?? 0;
}

double _toDouble(dynamic value) {
  if (value == null) return 0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0;
}
