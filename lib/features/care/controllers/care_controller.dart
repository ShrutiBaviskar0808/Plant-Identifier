import 'package:get/get.dart';

class CareController extends GetxController {
  final RxList<CareTask> _todaysTasks = <CareTask>[].obs;
  final RxBool _isLoading = false.obs;

  List<CareTask> get todaysTasks => _todaysTasks;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    loadTodaysTasks();
  }

  Future<void> loadTodaysTasks() async {
    _isLoading.value = true;
    // Simulate loading
    await Future.delayed(const Duration(seconds: 1));
    _todaysTasks.clear(); // No tasks for now
    _isLoading.value = false;
  }

  void completeTask(String taskId) {
    _todaysTasks.removeWhere((task) => task.id == taskId);
    Get.snackbar('Task Completed', 'Great job taking care of your plants!');
  }
}

class CareTask {
  final String id;
  final String plantName;
  final String taskType;
  final DateTime dueDate;
  final bool isCompleted;

  const CareTask({
    required this.id,
    required this.plantName,
    required this.taskType,
    required this.dueDate,
    this.isCompleted = false,
  });
}