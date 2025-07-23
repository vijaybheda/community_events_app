import 'package:get/get.dart';
import '../controllers/event_details_controller.dart';

class EventDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EventDetailsController>(() => EventDetailsController());
  }
}
