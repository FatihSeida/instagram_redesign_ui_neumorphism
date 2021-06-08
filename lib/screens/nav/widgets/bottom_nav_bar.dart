import 'package:flutter/material.dart';
import 'package:flutter_instagram/enums/enums.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class BottomNavBar extends StatelessWidget {
  final Map<BottomNavItem, IconData> items;
  final BottomNavItem selectedItem;
  final Function(int) onTap;

  const BottomNavBar({
    Key key,
    @required this.items,
    @required this.selectedItem,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: NeumorphicTheme.baseColor(context),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedItemColor: Colors.white,
      unselectedItemColor: Theme.of(context).primaryColor,
      currentIndex: BottomNavItem.values.indexOf(selectedItem),
      onTap: onTap,
      items: items
          .map((item, icon) => MapEntry(
                item.toString(),
                BottomNavigationBarItem(
                  label: '',
                  activeIcon: Neumorphic(
                    style: NeumorphicStyle(
                      shape: NeumorphicShape.concave,
                      depth: 5,
                      intensity: 0.75,
                      surfaceIntensity: 0.75,
                      lightSource: LightSource.topLeft,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(10)),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              Color(0xFF0059D6),
                              Color(0xFF04BFBF),
                            ],
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            tileMode: TileMode.clamp),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(icon, size: 25.0),
                    ),
                  ),
                  icon: Neumorphic(
                    style: NeumorphicStyle(
                      shape: NeumorphicShape.concave,
                      depth: 5,
                      intensity: 0.75,
                      surfaceIntensity: 0.4,
                      lightSource: LightSource.topLeft,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(10)),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        color: NeumorphicTheme.baseColor(context),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(icon, size: 25.0),
                    ),
                  ),
                ),
              ))
          .values
          .toList(),
    );
  }
}
