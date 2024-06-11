import 'package:flutter/material.dart';
import '../screens/my_home_page.dart';

class IconTab extends StatelessWidget {
  final IconData icon;
  final ValueNotifier<bool> isSelected;

  IconTab({required this.icon, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isSelected,
      builder: (context, isSelected, child) {
        return Icon(
          icon,
          color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey[500],
        );
      },
    );
  }
}

class CustomBottomAppBar extends StatelessWidget {
  CustomBottomAppBar({super.key, required this.color, required this.height, required this.tabController});
  final Color color;
  final double height;
  final TabController tabController;
  //final List<ValueNotifier<bool>> isSelectedList = [
  //  ValueNotifier<bool>(true),
  //  ValueNotifier<bool>(false),
  //  ValueNotifier<bool>(false),
  //];

  @override
  Widget build(BuildContext context) {
    tabController.addListener(() {
      for (int i = 0; i < SelectedTab.instance.isSelectedList.length; i++) {
        SelectedTab.instance.isSelectedList[i].value = i == tabController.index;
      }
    });
    return DecoratedBox(decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.secondary,
      border: Border(
        bottom: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 3.0,
        ),
      ),
    ),
      child: Container(
        color: Theme.of(context).colorScheme.secondary,
        height: 90,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildTabItem(context, Icons.brightness_low, 'Currently', 0),
            _buildTabItem(context, Icons.today, 'Today', 1),
            _buildTabItem(context, Icons.date_range, 'Weekly', 2),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(BuildContext context, IconData icon, String text, int index) {
    return InkWell(
      onTap: () {
        tabController.animateTo(index);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconTab(icon: icon, isSelected: SelectedTab.instance.isSelectedList[index]),
          Padding(padding: const EdgeInsets.only(top: 10.0),
            child:ValueListenableBuilder(
              valueListenable: SelectedTab.instance.isSelectedList[index],
              builder: (context, isSelected, child) {
                return Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child:
                  Text(
                    text,
                    style: TextStyle(color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey[500]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
