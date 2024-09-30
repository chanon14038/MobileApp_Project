abstract class BottomNavigationEvent {}

class ChangeBottomNavigation extends BottomNavigationEvent {
  final int index;

  ChangeBottomNavigation(this.index);
}