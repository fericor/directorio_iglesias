import 'package:conexion_mas/models/eventosItems.dart';
import 'package:url_launcher/url_launcher.dart';

class CalendarService {
  static Future<void> addToCalendar(Evento event) async {
    final startDate = DateTime.parse('${event.fecha} ${event.hora}');
    final endDate = event.fechaFin != null && event.horaFin != null
        ? DateTime.parse('${event.fechaFin} ${event.horaFin}')
        : startDate.add(Duration(hours: 2));

    // Formato para Google Calendar
    final googleCalendarUrl = Uri.parse(
      'https://calendar.google.com/calendar/r/eventedit?'
      'text=${Uri.encodeComponent(event.titulo!)}&'
      'dates=${startDate.toUtc().toString().replaceAll(RegExp(r'[^\w]'), '')}'
      '/${endDate.toUtc().toString().replaceAll(RegExp(r'[^\w]'), '')}&'
      'details=${Uri.encodeComponent(event.descripcionCorta!)}&'
      'location=${Uri.encodeComponent(event.lugar ?? '')}&',
    );

    if (await canLaunchUrl(googleCalendarUrl)) {
      await launchUrl(googleCalendarUrl);
    } else {
      throw 'No se pudo abrir el calendario';
    }
  }
}
