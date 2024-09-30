abstract class BottomNavigationState {
  final int selectedIndex;
  BottomNavigationState(this.selectedIndex);
}

class BottomNavigationInitial extends BottomNavigationState {
  BottomNavigationInitial() : super(0); // เริ่มต้นที่หน้าแรก
}

class BottomNavigationChanged extends BottomNavigationState {
  BottomNavigationChanged(int index) : super(index);
}