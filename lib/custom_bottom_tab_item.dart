import 'package:flutter/widgets.dart';

class CustomBottomTabItem{

  const CustomBottomTabItem({
    @required this.icon, 
    Widget activeIcon, 
    this.title, 
    this.badge, 
    this.badgeNum
  }): activeIcon = activeIcon ?? icon,
       assert(icon != null);

  ///未选中图标
  final Widget icon;
  ///选中图标
  final Widget activeIcon;
  ///标题
  final Widget title;
  ///未读消息样式
  final Widget badge;
  ///未读消息数量
  final String badgeNum;
}