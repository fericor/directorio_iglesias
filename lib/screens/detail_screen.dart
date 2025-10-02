// screens/detail_screen.dart
import 'package:conexion_mas/controllers/CalendarService.dart';
import 'package:flutter/material.dart';
import '../models/event.dart';
import '../widgets/follow_button.dart';
import '../widgets/comment_section.dart';

class DetailScreen extends StatefulWidget {
  final dynamic item; // Puede ser Event o Church
  final String tipo; // 'evento' o 'iglesia'

  const DetailScreen({Key? key, required this.item, required this.tipo}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.titulo ?? widget.item.nombre),
        actions: [
          if (widget.tipo == 'evento')
            IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: () => CalendarService.addToCalendar(widget.item),
              tooltip: 'Agregar al calendario',
            ),
          FollowButton(
            idIglesia: widget.tipo == 'iglesia' ? widget.item.id : null,
            idEvento: widget.tipo == 'evento' ? widget.item.idEvento : null,
            tipo: widget.tipo,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con imagen e información básica
            _buildHeader(),
            SizedBox(height: 16),
            // Descripción
            if (widget.item.descripcion != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Descripción',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(widget.item.descripcion!),
                  SizedBox(height: 16),
                ],
              ),
            // Información adicional para eventos
            if (widget.tipo == 'evento') _buildEventInfo(),
            // Sección de comentarios
            CommentSection(
              idIglesia: widget.tipo == 'iglesia' ? widget.item.id : null,
              idEvento: widget.tipo == 'evento' ? widget.item.idEvento : null,
              tipo: widget.tipo,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.item.imagen != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              widget.item.imagen!,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
        SizedBox(height: 16),
        Text(
          widget.item.titulo ?? widget.item.nombre,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        if (widget.item.lugar != null) Text('Lugar: ${widget.item.lugar}'),
        if (widget.item.direccion != null) Text('Dirección: ${widget.item.direccion}'),
      ],
    );
  }

  Widget _buildEventInfo() {
    final event = widget.item as Event;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Información del Evento',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text('Fecha: ${event.fecha}'),
        Text('Hora: ${event.hora}'),
        if (event.fechaFin != null) Text('Fecha fin: ${event.fechaFin}'),
        if (event.horaFin != null) Text('Hora fin: ${event.horaFin}'),
        if (event.esGratis != null) Text('Entrada: ${event.esGratis ? 'Gratis' : 'De pago'}'),
        if (event.seats != null) Text('Aforo: ${event.seats} personas'),
        SizedBox(height: 16),
      ],
    );
  }
}