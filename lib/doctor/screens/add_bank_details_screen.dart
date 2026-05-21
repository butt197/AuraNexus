import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/doctor/utils/doctor_imports.dart';

class BankDetailScreen extends GetView<BankDetailController> {
  final BankDetailController detailController = Get.put(BankDetailController());

  BankDetailScreen({super.key});

  String _statusText(BankData? data) {
    final status = data?.stripeAccountStatus ?? 'not_connected';

    if (status == 'active') return 'Active';
    if (status == 'pending_verification') return 'Pending Verification';
    if (status == 'pending_onboarding') return 'Pending Onboarding';
    return 'Not Connected';
  }

  Color _statusColor(BankData? data) {
    final status = data?.stripeAccountStatus ?? 'not_connected';

    if (status == 'active') return Colors.green;
    if (status == 'pending_verification') return Colors.orange;
    if (status == 'pending_onboarding') return Colors.deepOrange;
    return Colors.redAccent;
  }

  String _mainButtonText(BankData? data) {
    if (data?.isStripeActive == true) {
      return 'Stripe Connected';
    }

    final status = data?.stripeAccountStatus ?? 'not_connected';

    if (status == 'pending_onboarding' || status == 'pending_verification') {
      return 'Continue Stripe Setup';
    }

    return 'Connect Stripe';
  }

  Widget _infoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: AppFontStyleTextStrings.regular,
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: AppFontStyleTextStrings.medium,
                fontSize: 13,
                color: valueColor ?? Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(BankData? data) {
    final color = _statusColor(data);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        _statusText(data),
        style: TextStyle(
          fontFamily: AppFontStyleTextStrings.medium,
          fontSize: 12,
          color: color,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.LIGHT_GREY_SCREEN_BACKGROUND,
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: CustomAppBar(
          onPressed: () => Get.back(),
          isBackArrow: true,
          title: 'Payout Setup',
          textStyle: Theme.of(context).textTheme.headlineSmall!.apply(
            color: Theme.of(context).scaffoldBackgroundColor,
            fontWeightDelta: 5,
          ),
        ),
        leading: Container(),
      ),
      body: Obx(
        () => detailController.isError.value
            ? Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off_rounded,
                      size: 90,
                      color: AppColors.LIGHT_GREY_TEXT,
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'unable_to_load_data'.tr,
                      style: const TextStyle(
                        fontFamily: AppFontStyleTextStrings.regular,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: CustomButton(
                        onTap: detailController.refreshStripeStatus,
                        btnText: 'Retry',
                      ),
                    ),
                  ],
                ),
              )
            : detailController.isLoaded.value
            ? Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: AppColors.WHITE,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(11),
                                        decoration: BoxDecoration(
                                          color: AppColors.AMBER.withOpacity(
                                            0.12,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.account_balance_wallet,
                                          color: AppColors.AMBER,
                                          size: 26,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Stripe Payout Setup',
                                              style: TextStyle(
                                                fontFamily:
                                                    AppFontStyleTextStrings
                                                        .bold,
                                                fontSize: 18,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              'Connect your Stripe account to receive appointment payouts automatically.',
                                              style: TextStyle(
                                                fontFamily:
                                                    AppFontStyleTextStrings
                                                        .regular,
                                                fontSize: 12,
                                                color:
                                                    AppColors.LIGHT_GREY_TEXT,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      _statusChip(detailController.payoutData),
                                    ],
                                  ),
                                  const SizedBox(height: 18),
                                  Divider(
                                    color: AppColors.grey,
                                    thickness: 0.7,
                                  ),
                                  const SizedBox(height: 8),
                                  _infoRow(
                                    'Status',
                                    _statusText(detailController.payoutData),
                                    valueColor: _statusColor(
                                      detailController.payoutData,
                                    ),
                                  ),
                                  _infoRow(
                                    'Charges Enabled',
                                    detailController
                                                .payoutData
                                                ?.chargesEnabled ==
                                            1
                                        ? 'Yes'
                                        : 'No',
                                  ),
                                  _infoRow(
                                    'Payouts Enabled',
                                    detailController
                                                .payoutData
                                                ?.payoutsEnabled ==
                                            1
                                        ? 'Yes'
                                        : 'No',
                                  ),
                                  _infoRow(
                                    'Details Submitted',
                                    detailController
                                                .payoutData
                                                ?.detailsSubmitted ==
                                            1
                                        ? 'Yes'
                                        : 'No',
                                  ),
                                  _infoRow(
                                    'Commission',
                                    '${detailController.payoutData?.stripeCommissionPercent.toStringAsFixed(0) ?? '0'}%',
                                  ),
                                  if ((detailController
                                              .payoutData
                                              ?.stripeAccountId ??
                                          '')
                                      .isNotEmpty)
                                    _infoRow(
                                      'Stripe Account',
                                      detailController
                                              .payoutData
                                              ?.stripeAccountId ??
                                          '-',
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.WHITE,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                'Bank and identity details are collected securely by Stripe. AuraNexus does not store your full payout bank information in the app.',
                                style: TextStyle(
                                  fontFamily: AppFontStyleTextStrings.regular,
                                  fontSize: 12,
                                  height: 1.4,
                                  color: AppColors.LIGHT_GREY_TEXT,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    CustomButton(
                      onTap: detailController.payoutData?.isStripeActive == true
                          ? () {}
                          : () {
                              FocusScope.of(context).unfocus();
                              detailController
                                  .startOrContinueStripeOnboarding();
                            },
                      btnText: _mainButtonText(detailController.payoutData),
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: detailController.refreshStripeStatus,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'Refresh Status',
                          style: TextStyle(
                            fontFamily: AppFontStyleTextStrings.medium,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
