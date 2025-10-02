import 'package:conexion_mas/controllers/notificacionesApiClient.dart';
import 'package:conexion_mas/helper/snackbar.dart';
import 'package:conexion_mas/models/Actividad.dart';
import 'package:conexion_mas/utils/ChurchTextFieldStyles.dart';
import 'package:conexion_mas/utils/colorsUtils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';

class Notificacioneslistpage extends StatefulWidget {
  final String token;
  final int userRole;

  const Notificacioneslistpage({
    Key? key,
    required this.token,
    required this.userRole,
  }) : super(key: key);

  @override
  State<Notificacioneslistpage> createState() => _NotificacioneslistpageState();
}

class _NotificacioneslistpageState extends State<Notificacioneslistpage> {
  final List<NotificationRecord> _notifications = [];
  List<Actividad> actividades = [];

  String selectedType = 'General';
  String selectedGroup = 'Todos';
  String errorMessage = '';
  bool isLoading = true;

  // FORMULARIOS
  final TextEditingController _textTituloController = TextEditingController();
  final TextEditingController _textMensajeController = TextEditingController();
  final TextEditingController _textGeneroController = TextEditingController();
  final TextEditingController _textQuienController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cargarActividades();
  }

  // FUNCIONES
  Future<void> _cargarActividades() async {
    try {
      final resultado;

      setState(() => isLoading = true);

      if (widget.userRole == 1000) {
        resultado = await NotificacionesApiClient().listarNotificaciones(
            localStorage
                .getItem('miIglesia')
                .toString(), // Reemplaza con el ID real
            localStorage.getItem('miToken').toString());
      } else {
        resultado = await NotificacionesApiClient()
            .listarNotificacionesByIglesia(
                localStorage
                    .getItem('miIglesia')
                    .toString(), // Reemplaza con el ID real
                localStorage.getItem('miToken').toString());
      }

      setState(() {
        isLoading = false;

        List<NotificationRecord> recordsDesdeAPI = [];

        if (resultado.isNotEmpty) {
          actividades = resultado;
          for (var actividad in actividades) {
            recordsDesdeAPI.add(
              NotificationRecord(
                id: actividad.idActividad!,
                title: actividad.titulo!.toString() ?? 'Notificación',
                message: actividad.detalles.toString() ?? '',
                type: actividad.tipo.toString() ?? 'General',
                date: DateTime.tryParse(actividad.fechaHora ?? '') ??
                    DateTime.now(),
                status: 'Enviado',
                recipients: actividad.exitosas! + actividad.fallidas!,
                successful: actividad.exitosas!,
              ),
            );
          }

          // Añadir todos los registros de la API
          _notifications.addAll(recordsDesdeAPI);
        } else {
          errorMessage = 'Error desconocido';
          actividades = [];
        }
      });
    } catch (e) {
      setState(() => errorMessage = e.toString());
      actividades = [];
    } finally {
      setState(() => isLoading = false);
    }
  }

  void EnviarNotificacionSimple() async {
    // Enviar una notificación
    final resultado =
        await NotificacionesApiClient().enviarNotificacionPushByGenero(
      title: _textTituloController.text,
      bodyMsg: _textMensajeController.text,
      data: {'action': 'send_notification'},
      tipo: selectedType,
      grupo: selectedGroup,
      token: localStorage.getItem('miToken').toString(),
      idUser: localStorage.getItem('miIdUser').toString(),
    );

    // Verificar resultado
    if (resultado['success'] == true) {
      print('✅ Notificación enviada: ${resultado['message']}');
      print('📊 Datos: ${resultado['data']}');
      Navigator.pop(context);
      AppSnackbar.show(
        context,
        message: 'Notificación enviada',
        type: SnackbarType.success,
      );
    } else {
      print('❌ Error: ${resultado['message']}');
      print('🔍 Detalles: ${resultado['error']}');
      AppSnackbar.show(
        context,
        message: resultado['message'],
        type: SnackbarType.error,
      );
    }
  }

  Widget _buildNotifications() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  style: TextStyle(
                    color: ColorsUtils.blancoColor,
                  ),
                  decoration: ChurchTextFieldStyles.churchTextField(
                    hintText: 'Buscar notificaciones...',
                    prefixIcon: Icon(Icons.search),
                    labelText: '',
                  ),
                ),
              ),
              SizedBox(width: 10),
              FilterChip(
                label: Text('Filtrar'),
                onSelected: (bool value) {},
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _notifications.length,
            itemBuilder: (context, index) {
              return _buildNotificationCard(_notifications[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationCard(NotificationRecord notification) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 15, right: 15),
        leading: Icon(
          Icons.notifications,
          size: 40,
          color: ColorsUtils.principalColor,
        ),
        title: Text(
          notification.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 0),
            Text(notification.message),
            SizedBox(height: 10),
            Row(
              children: [
                Chip(
                  label: Text(notification.type),
                  backgroundColor: ColorsUtils.principalColor,
                  labelPadding: EdgeInsets.only(left: 10, right: 10),
                ),
                SizedBox(width: 10),
                Text(
                  DateFormat('dd/MM/yyyy').format(notification.date),
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 10),
            LinearProgressIndicator(
              value: notification.successful / notification.recipients,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
            SizedBox(height: 5),
            Text(
              '${notification.successful} de ${notification.recipients} enviados exitosamente',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  void _showSendNotificationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String title = '';
        String message = '';

        return AlertDialog(
          title: Text('Enviar Notificación'),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(2))),
          titlePadding: EdgeInsets.all(10),
          contentPadding: EdgeInsets.only(left: 10, right: 10),
          buttonPadding: EdgeInsets.all(10),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 5),
                TextField(
                  controller: _textTituloController,
                  style: TextStyle(
                    color: ColorsUtils.blancoColor,
                  ),
                  decoration: ChurchTextFieldStyles.churchTextField(
                    labelText: 'Título',
                  ),
                  onChanged: (value) => title = value,
                ),
                SizedBox(height: 5),
                TextField(
                  controller: _textMensajeController,
                  style: TextStyle(
                    color: ColorsUtils.blancoColor,
                  ),
                  decoration: ChurchTextFieldStyles.churchTextField(
                    labelText: 'Mensaje',
                  ),
                  maxLines: 3,
                  onChanged: (value) => message = value,
                ),
                SizedBox(height: 5),
                DropdownButtonFormField<String>(
                  value: selectedType,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    filled: true,
                    fillColor: ColorsUtils.terceroColor,
                    hintText: 'Tipo de notificación',
                    hintStyle: TextStyle(color: ColorsUtils.blancoColor),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 0, vertical: 14),
                  ),
                  items: <String>[
                    'General',
                    'Evento',
                    'Urgente',
                    'Recordatorio'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    selectedType = newValue!;
                  },
                ),
                SizedBox(height: 5),
                DropdownButtonFormField<String>(
                  value: selectedGroup,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    filled: true,
                    fillColor: ColorsUtils.terceroColor,
                    hintText: 'Grupo de destinatarios',
                    hintStyle: TextStyle(color: ColorsUtils.blancoColor),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 0, vertical: 14),
                  ),
                  items: <String>[
                    'Todos',
                    'Damas',
                    'Caballeros',
                    'Jovenes',
                    'Niños'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    selectedGroup = newValue!;
                  },
                ),
                SizedBox(height: 5),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                EnviarNotificacionSimple();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsUtils.principalColor,
              ),
              child: Text(
                'Enviar',
                style: TextStyle(
                  color: ColorsUtils.blancoColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorsUtils.fondoColor,
        appBar: AppBar(
          title: Text(
            'Notificaciones',
            style: TextStyle(
              color: ColorsUtils.blancoColor,
            ),
          ),
          backgroundColor: ColorsUtils.fondoColor,
          actions: [
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {},
            ),
          ],
        ),
        body: _buildNotifications(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showSendNotificationDialog();
          },
          child: Icon(Icons.add),
          backgroundColor: ColorsUtils.principalColor,
        ));
  }
}

class NotificationRecord {
  final int id;
  final String title;
  final String message;
  final String type;
  final DateTime date;
  final String status;
  final int recipients;
  final int successful;

  NotificationRecord({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.date,
    required this.status,
    required this.recipients,
    required this.successful,
  });
}
