import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/doctor/utils/doctor_imports.dart';

class SubscriptionListScreen extends GetView<SubscriptionListController> {
  final SubscriptionListController listController = Get.put(
    SubscriptionListController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.LIGHT_GREY_SCREEN_BACKGROUND,
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: CustomAppBar(
          onPressed: () => Get.back(),
          isBackArrow: true,
          title: 'subscription_list'.tr,
          textStyle: Theme.of(context).textTheme.headlineSmall!.apply(
            color: Theme.of(context).scaffoldBackgroundColor,
            fontWeightDelta: 5,
          ),
        ),
        leading: Container(),
      ),
      body: Obx(
        () => listController.isErrorInLoading.value
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.color1),
              )
            : ListView.builder(
                padding: const EdgeInsets.only(top: 5),
                scrollDirection: Axis.vertical,
                itemCount: listController.info.length,
                itemBuilder: (ctx, index) {
                  return Container(
                    height: 100,
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.WHITE,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 80,
                            margin: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: AppColors.dSubscriptionPriceBg,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '$CURRENCY${listController.info[index].price}',
                              style: Theme.of(context).textTheme.titleMedium!
                                  .apply(
                                    color: AppColors.BLACK,
                                    fontSizeFactor: 1.6,
                                    fontWeightDelta: 2,
                                  ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      (listController.info[index].planName
                                                  ?.trim()
                                                  .isNotEmpty ??
                                              false)
                                          ? listController.info[index].planName!
                                                .trim()
                                          : '${listController.info[index].month ?? ''} ${'choose_plan_t1'.tr}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .apply(
                                            color: AppColors.BLACK,
                                            fontSizeFactor: 0.9,
                                            fontWeightDelta: 1,
                                          ),
                                    ),
                                    const SizedBox(width: 80),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.circle,
                                          size: 13,
                                          color:
                                              listController.info[index].status
                                                      .toString() ==
                                                  '1'
                                              ? AppColors.chatColor1
                                              : listController
                                                        .info[index]
                                                        .status
                                                        .toString() ==
                                                    '2'
                                              ? AppColors.GREEN
                                              : listController
                                                        .info[index]
                                                        .status
                                                        .toString() ==
                                                    '3'
                                              ? AppColors.grey
                                              : AppColors.YELLOW,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          listController.info[index].status
                                                      .toString() ==
                                                  '1'
                                              ? 'd_subscription_plan_status1'.tr
                                              : listController
                                                        .info[index]
                                                        .status
                                                        .toString() ==
                                                    '2'
                                              ? 'd_subscription_plan_status2'.tr
                                              : listController
                                                        .info[index]
                                                        .status
                                                        .toString() ==
                                                    '3'
                                              ? 'd_subscription_plan_status3'.tr
                                              : 'd_subscription_plan_status4'
                                                    .tr,
                                          // maxLines: 2,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .apply(
                                                color:
                                                    listController
                                                            .info[index]
                                                            .status
                                                            .toString() ==
                                                        '1'
                                                    ? AppColors.chatColor1
                                                    : listController
                                                              .info[index]
                                                              .status
                                                              .toString() ==
                                                          '2'
                                                    ? AppColors.GREEN
                                                    : listController
                                                              .info[index]
                                                              .status
                                                              .toString() ==
                                                          '3'
                                                    ? AppColors.grey
                                                    : AppColors.YELLOW,
                                                fontSizeFactor: 0.8,
                                                fontWeightDelta: 2,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Text(
                                  listController.info[index].date
                                      .toString()
                                      .substring(0, 10),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
