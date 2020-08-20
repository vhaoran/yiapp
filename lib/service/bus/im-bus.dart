import 'package:event_bus/event_bus.dart';

EventBus glbEventBus = EventBus();



class MessageEvent {
  String topic;
  String payload;

  MessageEvent(this.topic, this.payload);

  @override
  toString() {
    return '<$topic>:<$payload>';
  }
}
