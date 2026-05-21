import 'package:videocalling/common/utils/app_imports.dart';

class CustomOptionTile extends StatelessWidget {
  final VoidCallback callback;
  final String text;

  CustomOptionTile({required this.callback, required this.text});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.only(
          left: 10,
        ),
        height: 45,
        decoration: BoxDecoration(
          color: AppColors.tileBgColorIncomeReport,
          borderRadius: BorderRadius.circular(7),
        ),
        alignment: Alignment.centerLeft,
        child: AppTextWidgets.blackText(
          text: text,
          color: AppColors.tileColorIncomeReport,
          size: 17,
        ),
      ),
    );
  }
}

class CustomMoreScreenTile extends StatelessWidget {
  final VoidCallback callback;
  final String text;

  CustomMoreScreenTile({required this.callback, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        height: 50,
        margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
        decoration: BoxDecoration(
            color: AppColors.WHITE, borderRadius: BorderRadius.circular(10)),
        child: Container(
          margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


