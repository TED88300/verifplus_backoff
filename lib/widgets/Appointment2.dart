import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart' show IterableDiagnostics;


class Appointment2 with Diagnosticable {

  Appointment2({
    this.startTimeZone,
    this.endTimeZone,
    this.recurrenceRule,
    this.isAllDay = false,
    this.notes,
    this.location,
    this.ResourceIds,
    this.recurrenceId,
    this.id,
    required this.startTime,
    required this.endTime,
    this.subject = '',
    this.subject2 = '',
    this.subject3 = '',
    this.color = Colors.lightBlue,
    this.recurrenceExceptionDates,
  }) {
    recurrenceRule = recurrenceId != null ? null : recurrenceRule;
    _appointmentType = _getAppointmentType();
    id = id ?? hashCode;
  }


  DateTime startTime;
  DateTime endTime;
  bool isAllDay;
  String subject;
  String subject2;
  String subject3;
  Color color;
  String? startTimeZone;
  String? endTimeZone;
  String? recurrenceRule;
  List<DateTime>? recurrenceExceptionDates;
  String? notes;
  String? location;
  List<Object>? ResourceIds;
  Object? recurrenceId;
  Object? id;

  AppointmentType _appointmentType = AppointmentType.normal;
  AppointmentType get appointmentType => _appointmentType;

  AppointmentType _getAppointmentType() {
    if (recurrenceId != null) {
      return AppointmentType.changedOccurrence;
    } else if (recurrenceRule != null && recurrenceRule!.isNotEmpty) {
      if (notes != null && notes!.contains('isOccurrenceAppointment')) {
        notes = notes!.replaceAll('isOccurrenceAppointment', '');
        return AppointmentType.occurrence;
      }

      return AppointmentType.pattern;
    }
    return AppointmentType.normal;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(dynamic other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    late final Appointment2 otherStyle;
    if (other is Appointment2) {
      otherStyle = other;
    }
    return otherStyle.startTime == startTime &&
        otherStyle.endTime == endTime &&
        otherStyle.startTimeZone == startTimeZone &&
        otherStyle.endTimeZone == endTimeZone &&
        otherStyle.isAllDay == isAllDay &&
        otherStyle.notes == notes &&
        otherStyle.location == location &&
        otherStyle.ResourceIds == ResourceIds &&
        otherStyle.subject == subject &&
        otherStyle.color == color &&
        otherStyle.recurrenceExceptionDates == recurrenceExceptionDates &&
        otherStyle.recurrenceId == recurrenceId &&
        otherStyle.id == id &&
        otherStyle.appointmentType == appointmentType;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    return Object.hash(
      startTimeZone,
      endTimeZone,
      recurrenceRule,
      isAllDay,
      notes,
      location,
      ResourceIds == null ? null : Object.hashAll(ResourceIds!),
      recurrenceId,
      id,
      appointmentType,
      startTime,
      endTime,
      subject,
      subject2,
      subject3,
      color,
      recurrenceExceptionDates == null
          ? null
          : Object.hashAll(recurrenceExceptionDates!),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('startTimeZone', startTimeZone));
    properties.add(StringProperty('endTimeZone', endTimeZone));
    properties.add(StringProperty('recurrenceRule', recurrenceRule));
    properties.add(StringProperty('notes', notes));
    properties.add(StringProperty('location', location));
    properties.add(StringProperty('subject', subject));
    properties.add(StringProperty('subject2', subject2));
    properties.add(StringProperty('subject3', subject3));
    properties.add(ColorProperty('color', color));
    properties.add(DiagnosticsProperty<Object>('recurrenceId', recurrenceId));
    properties.add(DiagnosticsProperty<Object>('id', id));
    properties.add(EnumProperty<AppointmentType>('appointmentType', appointmentType));
    properties.add(DiagnosticsProperty<DateTime>('startTime', startTime));
    properties.add(DiagnosticsProperty<DateTime>('endTime', endTime));
    properties.add(IterableDiagnostics<DateTime>(recurrenceExceptionDates).toDiagnosticsNode(name: 'recurrenceExceptionDates'));
    properties.add(IterableDiagnostics<Object>(ResourceIds).toDiagnosticsNode(name: 'ResourceIds'));
    properties.add(DiagnosticsProperty<bool>('isAllDay', isAllDay));
  }
}
