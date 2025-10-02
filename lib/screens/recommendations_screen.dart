import 'package:conexion_mas/controllers/ProfileServide.dart';
import 'package:flutter/material.dart';
import '../models/event.dart';
import './detail_screen.dart';

class RecommendationsScreen extends StatefulWidget {
  const RecommendationsScreen({Key? key}) : super(key: key);

  @override
  _RecommendationsScreenState createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  List<Event> _recommendedEvents = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecommendations();
  }

  Future<void> _loadRecommendations() async {
    try {
      final response = await ProfileService.getRecommendedEvents();
      final List<dynamic> eventData = response['data'];
      setState(() {
        _recommendedEvents = eventData.map((json) => Event.fromJson(json)).toList();
        _isLoading = false;
      });
    } catch (error) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar eventos recomendados: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eventos Recomendados'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _recommendedEvents.isEmpty
              ? Center(child: Text('No hay eventos recomendados'))
              : ListView.builder(
                  itemCount: _recommendedEvents.length,
                  itemBuilder: (context, index) {
                    final event = _recommendedEvents[index];
                    return ListTile(
                      leading: event.imagen != null
                          ? Image.network(event.imagen!, width: 50, height: 50, fit: BoxFit.cover)
                          : Icon(Icons.event),
                      title: Text(event.titulo),
                      subtitle: Text('${event.fecha} ${event.hora}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(
                              item: event,
                              tipo: 'evento',
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}