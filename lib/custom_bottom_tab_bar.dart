library custom_bottom_tab_bar;
import 'dart:ui' show ImageFilter;
import 'package:flutter/cupertino.dart';
import 'package:custom_bottom_tab_bar/custom_bottom_tab_item.dart';
import 'package:flutter/material.dart';

///bottombar默认高度
const double _kTabBarHeight = 50.0;
///tabbar顶部边框的颜色
const Color _kDefaultTabBarBorderColor = Color(0x4C000000);
class CustomBottomTabBar extends StatelessWidget {
  CustomBottomTabBar({Key key, 
    @required this.items, 
    this.onTap, 
    this.currentIndex = 0, 
    this.backgroundColor, 
    this.activeColor, 
    this.inactiveColor = CupertinoColors.inactiveGray, 
    this.iconSize = 30.0, 
    this.tabBarHeight = _kTabBarHeight, 
    this.border = const Border(
      top: BorderSide(
        color: _kDefaultTabBarBorderColor,
        width: 0.0, // One physical pixel.
        style: BorderStyle.solid,
      ),
    ), 
    this.badgeColor=Colors.red, 
    this.bottomTitlePadding=8.0,
  }) : assert(items != null),
       assert(
         items.length >= 2,
         "Tabs need at least 2 items to conform to Apple's HIG",
       ),
       assert(currentIndex != null),
       assert(0 <= currentIndex && currentIndex < items.length),
       assert(iconSize != null),
       assert(inactiveColor != null),
       super(key: key);

  ///tab集合
  final List<CustomBottomTabItem> items;
  ///tab点击事件
  final ValueChanged<int> onTap;
  ///当前选中
  final int currentIndex;
  ///tabbar背景颜色
  final Color backgroundColor;
  ///选中的颜色
  final Color activeColor;
  ///未选中颜色
  final Color inactiveColor;
  ///图标大小
  final double iconSize;
  ///TabBar高度
  final double tabBarHeight;
  ///tabbar的边框
  final Border border;
  ///未读消息背景颜色
  final Color badgeColor;
  ///底部距离
  final double bottomTitlePadding;

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(tabBarHeight);

  /// it show through it.
  bool opaque(BuildContext context) {
    final Color backgroundColor =
        this.backgroundColor ?? CupertinoTheme.of(context).barBackgroundColor;
    return backgroundColor.alpha == 0xFF;
  }

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = MediaQuery.of(context).padding.bottom;
    Widget result = DecoratedBox(
      decoration: BoxDecoration(
        border: border,
        color: backgroundColor ?? CupertinoTheme.of(context).barBackgroundColor,
      ),
      child: SizedBox(
        height: tabBarHeight + bottomPadding,
        child: IconTheme.merge( // Default with the inactive state.
          data: IconThemeData(
            color: inactiveColor,
            size: iconSize,
          ),
          child: DefaultTextStyle( // Default with the inactive state.
            style: CupertinoTheme.of(context).textTheme.tabLabelTextStyle.copyWith(color: inactiveColor),
            child: Padding(
              padding: EdgeInsets.only(bottom: bottomPadding),
              child: Row(
                // Align bottom since we want the labels to be aligned.
                crossAxisAlignment: CrossAxisAlignment.end,
                children: _buildTabItems(context),
              ),
            ),
          ),
        ),
      ),
    );

    if (!opaque(context)) {
      // For non-opaque backgrounds, apply a blur effect.
      result = ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: result,
        ),
      );
    }
    return result;
  }

  List<Widget> _buildTabItems(BuildContext context) {
    final List<Widget> result = <Widget>[];

    for (int index = 0; index < items.length; index += 1) {
      final bool active = index == currentIndex;
      result.add(
        _wrapActiveItem(
          context,
          Expanded(
            child: Semantics(
              selected: active,
              // TODO(xster): This needs localization support. https://github.com/flutter/flutter/issues/13452
              hint: 'tab, ${index + 1} of ${items.length}',
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onTap == null ? null : () { onTap(index); },
                child: Padding(
                  padding: EdgeInsets.only(bottom: bottomTitlePadding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: _buildSingleTabItem(items[index], active),
                  ),
                ),
              ),
            ),
          ),
          active: active,
        ),
      );
    }

    return result;
  }

  List<Widget> _buildSingleTabItem(CustomBottomTabItem item, bool active) {
    final List<Widget> components = <Widget>[
      Expanded(
        child: Stack(
          children: <Widget>[
            Center(child: active ? item.activeIcon : item.icon),
            _buildBadge(item),
          ],
        )
      )
    ];

    if (item.title != null) {
      components.add(item.title);
    }

    return components;
  }

  Widget _buildBadge(CustomBottomTabItem item) {
    if (item.badge == null && (item.badgeNum == null || item.badgeNum.isEmpty)) {
      return Container();
    }
    if (item.badge != null) {
      return item.badge;
    }
    if(item.badgeNum=='n'){
      return Positioned(right: 20, top: 10, child: Container(
        width: 10,
        height: 10,
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: badgeColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Text(
          '',
          style: TextStyle(fontSize: 10, color: Colors.white),
        ),
      ));
    }
    return Positioned(right: 10, top: 10, child:Container(
      width: 24,
      padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: badgeColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Text(
        item.badgeNum,
        style: TextStyle(fontSize: 10, color: Colors.white),
      ),
    ));
  }

  /// Change the active tab item's icon and title colors to active.
  Widget _wrapActiveItem(BuildContext context, Widget item, { @required bool active }) {
    if (!active)
      return item;

    final Color activeColor = this.activeColor ?? CupertinoTheme.of(context).primaryColor;
    return IconTheme.merge(
      data: IconThemeData(color: activeColor),
      child: DefaultTextStyle.merge(
        style: TextStyle(color: activeColor),
        child: item,
      ),
    );
  }

  /// Create a clone of the current [CupertinoTabBar] but with provided
  /// parameters overridden.
  CupertinoTabBar copyWith({
    Key key,
    List<BottomNavigationBarItem> items,
    Color backgroundColor,
    Color activeColor,
    Color inactiveColor,
    Size iconSize,
    Border border,
    int currentIndex,
    ValueChanged<int> onTap,
  }) {
    return CupertinoTabBar(
      key: key ?? this.key,
      items: items ?? this.items,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      activeColor: activeColor ?? this.activeColor,
      inactiveColor: inactiveColor ?? this.inactiveColor,
      iconSize: iconSize ?? this.iconSize,
      border: border ?? this.border,
      currentIndex: currentIndex ?? this.currentIndex,
      onTap: onTap ?? this.onTap,
    );
  }
}