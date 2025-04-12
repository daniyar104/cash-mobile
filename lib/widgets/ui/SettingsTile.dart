import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  final IconData leadingIcon;
  final String localizationKey;
  final VoidCallback? onTap;
  const SettingsTile({super.key, required this.leadingIcon, required this.localizationKey, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[200],
        ),
        child: Row(
            children: [
              Icon(leadingIcon, size: 30,),
              SizedBox(width: 10,),
              Text(
                localizationKey,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Icon(Icons.arrow_right, size: 30,),
            ]
        ),
      )
    );
  }
}
