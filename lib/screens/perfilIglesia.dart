import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:conexion_mas/helper/snackbar.dart';
import 'package:conexion_mas/models/iglesias.dart';
import 'package:conexion_mas/utils/colorsUtils.dart';
import 'package:conexion_mas/utils/mainUtils.dart';
import 'package:conexion_mas/widgets/FavoritoButton.dart';
import 'package:conexion_mas/widgets/comment_section.dart';
import 'package:conexion_mas/widgets/follow_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:localstorage/localstorage.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ChurchProfileScreen extends StatefulWidget {
  Iglesias church;

  ChurchProfileScreen({super.key, required this.church});

  @override
  _ChurchProfileScreenState createState() => _ChurchProfileScreenState();
}

class _ChurchProfileScreenState extends State<ChurchProfileScreen> {
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  final MapController _mapController = MapController();
  int _currentImageIndex = 0;
  late double _rating = double.parse(widget.church.ranking.toString());
  int _totalRatings = 128;
  late int _averageAttendance = int.parse(widget.church.asistentes.toString());
  bool _isExpanded = false;

  // Datos de ejemplo para el pastor
  late final Map<String, dynamic> _pastorData =
      widget.church.pastoresIglesia!.length > 0
          ? {
              'name':
                  "${widget.church.pastoresIglesia?.first.nombre} ${widget.church.pastoresIglesia?.first.apellidos}",
              'image':
                  '${MainUtils.urlHostAssetsImagen}/${widget.church.pastoresIglesia?.first.imagen}',
              'experience':
                  '${widget.church.pastoresIglesia?.first.experiencia}',
              'specialty':
                  '${widget.church.pastoresIglesia?.first.especialidad}',
              'phone': '${widget.church.pastoresIglesia?.first.telefonoMovil}',
              'email': '${widget.church.pastoresIglesia?.first.email}',
            }
          : {
              'name': 'Pastor no disponible',
              'image': "${MainUtils.urlHostAssetsImagen}/logos/logo_0.png",
              'experience': 'N/A',
              'specialty': 'N/A',
              'phone': '',
              'email': '',
            };

  // Lista de imágenes de ejemplo para la iglesia
  late final List<String> _churchImages =
      widget.church.imagenesIglesia != null &&
              widget.church.imagenesIglesia!.isNotEmpty
          ? widget.church.imagenesIglesia!
              .map((img) => '${MainUtils.urlHostAssetsImagen}/${img.imagen}')
              .toList()
          : ['${MainUtils.urlHostAssetsImagen}/iglesias/iglesia_0.jpg'];

  String idUser = localStorage.getItem('miIdUser').toString();
  String token = localStorage.getItem('miToken').toString();
  bool is_Login = localStorage.getItem('isLogin') == 'true';
  late List<int> favoritos = [];

  @override
  void initState() {
    super.initState();
    obtenerFavoritos();

    // Inicializar el mapa con la ubicación de la iglesia después de un breve delay
    Future.delayed(Duration(milliseconds: 100), () {
      double? lat = (widget.church.latitud != null &&
              widget.church.latitud.toString().isNotEmpty)
          ? double.tryParse(widget.church.latitud.toString())
          : null;

      double? lng = (widget.church.longitud != null &&
              widget.church.longitud.toString().isNotEmpty)
          ? double.tryParse(widget.church.longitud.toString())
          : null;

      if (lat != null && lng != null) {
        // _mapController.move(LatLng(lat, lng), 15.0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header con carrusel de imágenes
          SliverAppBar(
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildImageCarousel(),
            ),
            actions: [
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: ColorsUtils.principalColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  icon: Icon(Icons.share, color: ColorsUtils.blancoColor),
                  iconSize: 20.0,
                  onPressed: _shareChurch,
                ),
              ),
              SizedBox(width: 3),
              if (is_Login)
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: ColorsUtils.principalColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: FollowButton(
                    idIglesia: widget.church.idIglesia!,
                    idEvento: 0,
                    tipo: 'iglesia',
                  ),
                ),
              SizedBox(width: 3),
            ],
          ),

          // Contenido principal
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre y información básica
                  _buildChurchHeader(),

                  const SizedBox(height: 24),

                  // Rating y asistentes
                  _buildStatsRow(),

                  const SizedBox(height: 24),

                  // Descripción
                  _buildDescription(),

                  const SizedBox(height: 24),

                  // Información de contacto
                  _buildContactInfo(),

                  const SizedBox(height: 24),

                  // Cómo llegar
                  _buildLocationSection(),

                  const SizedBox(height: 24),

                  // Información del pastor
                  _buildPastorSection(),

                  const SizedBox(height: 24),

                  // Horarios de servicios
                  _buildServiceTimes(),

                  // Nueva sección de comentarios
                  SizedBox(height: 24),
                  CommentSection(
                    idIglesia: widget.church.idIglesia!,
                    idEvento: 0,
                    tipo: 'iglesia',
                  ),

                  const SizedBox(height: 112),
                ],
              ),
            ),
          ),
        ],
      ),

      // Botón flotante de acción
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _getDirections,
        icon: Icon(Icons.directions, color: ColorsUtils.blancoColor),
        label: Text('Cómo llegar',
            style: TextStyle(color: ColorsUtils.blancoColor)),
        backgroundColor: ColorsUtils.principalColor,
        elevation: 4,
      ),
    );
  }

  void obtenerFavoritos() async {
    final url = Uri.parse(
        "${MainUtils.urlHostApi}/iglesiaFavoritos/$idUser?api_token=$token");
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      setState(() {
        favoritos = (data['favoritos'] as List)
            .map<int>((e) => int.parse(e.toString()))
            .toList();
      });
    } else {
      throw Exception("Error al cargar favoritos");
    }
  }

  Widget _buildImageCarousel() {
    return Stack(
      children: [
        CarouselSlider(
          carouselController: _carouselController,
          options: CarouselOptions(
            height: 300,
            viewportFraction: 1.0,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 5),
            onPageChanged: (index, reason) {
              setState(() {
                _currentImageIndex = index;
              });
            },
          ),
          items: _churchImages.map((imageUrl) {
            return CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              placeholder: (context, url) => Container(
                color: ColorsUtils.terceroColor.withOpacity(0.3),
                child: Center(
                    child: CircularProgressIndicator(
                        color: ColorsUtils.principalColor)),
              ),
              errorWidget: (context, url, error) => Container(
                color: ColorsUtils.terceroColor.withOpacity(0.1),
                child: Icon(Icons.church,
                    size: 60,
                    color: ColorsUtils.principalColor.withOpacity(0.5)),
              ),
            );
          }).toList(),
        ),

        // Indicadores de imágenes
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _churchImages.asMap().entries.map((entry) {
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentImageIndex == entry.key
                      ? ColorsUtils.principalColor
                      : ColorsUtils.blancoColor.withOpacity(0.5),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildChurchHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.church.titulo ?? 'Iglesia',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: ColorsUtils.blancoColor,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.location_on, size: 16, color: ColorsUtils.blancoColor),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                widget.church.direccion ?? 'Dirección no disponible',
                style: TextStyle(
                  fontSize: 12,
                  color: ColorsUtils.blancoColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.phone, size: 16, color: ColorsUtils.blancoColor),
            const SizedBox(width: 4),
            Text(
              widget.church.telefono ?? 'Teléfono no disponible',
              style: TextStyle(
                fontSize: 12,
                color: ColorsUtils.blancoColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorsUtils.negroColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorsUtils.blancoColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatItem(
            icon: Icons.star,
            value: _rating.toString(),
            label: 'Rating',
            subtitle: '$_totalRatings valoraciones',
          ),
          _buildStatItem(
            icon: Icons.people,
            value: _averageAttendance.toString(),
            label: 'Asistentes',
            subtitle: 'promedio semanal',
          ),
          _buildStatItem(
            icon: Icons.calendar_today,
            value: '5',
            label: 'Servicios',
            subtitle: 'por semana',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      {required IconData icon,
      required String value,
      required String label,
      required String subtitle}) {
    return Column(
      children: [
        Icon(icon, size: 24, color: ColorsUtils.principalColor),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: ColorsUtils.principalColor,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: ColorsUtils.blancoColor,
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 10,
            color: ColorsUtils.blancoColor,
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Acerca de nosotros',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: ColorsUtils.principalColor,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          widget.church.descripcion ??
              'Descripción no disponible. Esta iglesia se dedica a servir a la comunidad y compartir el mensaje de amor y esperanza.',
          style: TextStyle(
            fontSize: 12,
            color: ColorsUtils.blancoColor,
            height: 1.5,
          ),
          maxLines: _isExpanded ? null : 3,
          overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
        ),
        if ((widget.church.descripcion?.length ?? 0) > 150)
          TextButton(
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Text(
              _isExpanded ? 'Ver menos' : 'Ver más',
              style: TextStyle(
                color: ColorsUtils.principalColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildContactInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Información de contacto',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: ColorsUtils.principalColor,
          ),
        ),
        const SizedBox(height: 16),
        _buildContactItem(
          icon: Icons.phone,
          title: 'Teléfono',
          value: widget.church.telefono ?? 'No disponible',
          onTap: () => _makePhoneCall(widget.church.telefono),
        ),
        _buildContactItem(
          icon: Icons.email,
          title: 'Email',
          value: 'info@${_getChurchSlug()}.com',
          onTap: () => _sendEmail(),
        ),
        _buildContactItem(
          icon: Icons.language,
          title: 'Sitio web',
          value: widget.church.web ?? 'No disponible',
          onTap: () => _launchWebsite(widget.church.web),
        ),
        _buildContactItem(
          icon: Icons.access_time,
          title: 'Horario de oficina',
          value: 'Lunes - Viernes: 9:00 AM - 5:00 PM',
          onTap: null,
        ),
      ],
    );
  }

  String _getChurchSlug() {
    return widget.church.titulo
            ?.toLowerCase()
            .replaceAll(' ', '-')
            .replaceAll(RegExp(r'[^a-z0-9-]'), '') ??
        'iglesia';
  }

  Widget _buildContactItem(
      {required IconData icon,
      required String title,
      required String value,
      required Function()? onTap}) {
    return ListTile(
      leading: Icon(icon, color: ColorsUtils.principalColor),
      title: Text(title,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: ColorsUtils.blancoColor)),
      subtitle: Text(value, style: TextStyle(color: ColorsUtils.blancoColor)),
      onTap: onTap,
      trailing: onTap != null
          ? Icon(Icons.arrow_forward_ios,
              size: 16, color: ColorsUtils.blancoColor)
          : null,
    );
  }

  Widget _buildLocationSection() {
    final hasLocation =
        widget.church.latitud != null && widget.church.longitud != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cómo llegar',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: ColorsUtils.principalColor,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border:
                Border.all(color: ColorsUtils.terceroColor.withOpacity(0.3)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: hasLocation
                ? FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: LatLng(
                          widget.church.latitud!, widget.church.longitud!),
                      initialZoom: 15.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://api.mapbox.com/styles/v1/fericor/cm5aqsckv00li01sa3ubd38gn/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiZmVyaWNvciIsImEiOiJja3J3ZHpzNnQwZm54Mm5xamo0OHN6bDBhIn0.2EtgIWzOEgy6AKorHcL44w',
                        userAgentPackageName: 'com.fericor.conexionmas',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            width: 40.0,
                            height: 40.0,
                            point: LatLng(widget.church.latitud!,
                                widget.church.longitud!),
                            child: Icon(
                              Icons.location_on,
                              color: ColorsUtils.principalColor,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.location_off,
                            size: 40,
                            color: ColorsUtils.terceroColor.withOpacity(0.5)),
                        SizedBox(height: 8),
                        Text(
                          'Ubicación no disponible',
                          style: TextStyle(color: ColorsUtils.terceroColor),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 12),
        if (hasLocation)
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _getDirections,
                  icon: Icon(Icons.directions, color: ColorsUtils.blancoColor),
                  label: Text('Abrir en Maps',
                      style: TextStyle(color: ColorsUtils.blancoColor)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsUtils.principalColor,
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildPastorSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nuestro Pastor',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: ColorsUtils.principalColor,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: ColorsUtils.terceroColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: ColorsUtils.blancoColor.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              // Foto del pastor
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                      color: ColorsUtils.principalColor.withOpacity(0.3),
                      width: 2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: CachedNetworkImage(
                    imageUrl: _pastorData['image'],
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(
                          color: ColorsUtils.principalColor),
                    ),
                    errorWidget: (context, url, error) => Icon(
                      Icons.person,
                      size: 40,
                      color: ColorsUtils.principalColor,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _pastorData['name'],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: ColorsUtils.blancoColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _pastorData['experience'],
                      style: TextStyle(
                        fontSize: 12,
                        color: ColorsUtils.blancoColor,
                      ),
                    ),
                    Text(
                      _pastorData['specialty'],
                      style: TextStyle(
                        fontSize: 10,
                        color: ColorsUtils.blancoColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.phone,
                              size: 20, color: ColorsUtils.principalColor),
                          onPressed: () => _makePhoneCall(_pastorData['phone']),
                        ),
                        IconButton(
                          icon: Icon(Icons.email,
                              size: 20, color: ColorsUtils.principalColor),
                          onPressed: () => _sendEmailToPastor(),
                        ),
                        IconButton(
                          icon: Icon(Icons.info,
                              size: 20, color: ColorsUtils.principalColor),
                          onPressed: _showPastorProfile,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServiceTimes() {
    final serviceTimes =
        jsonDecode(widget.church.servicios!) as Map<String, dynamic>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Horarios de servicios',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: ColorsUtils.principalColor,
          ),
        ),
        const SizedBox(height: 16),
        ...serviceTimes.entries.map((entry) {
          return Container(
            margin: EdgeInsets.only(bottom: 8),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ColorsUtils.blancoColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border:
                  Border.all(color: ColorsUtils.blancoColor.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                // Día de la semana
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: ColorsUtils.principalColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      entry.key[0],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ColorsUtils.principalColor,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.key,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ColorsUtils.blancoColor,
                        ),
                      ),
                      Text(
                        entry.value.join(', '),
                        style: TextStyle(
                          color: ColorsUtils.blancoColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  // Métodos de utilidad
  void _shareChurch() {
    // Implementar lógica de compartir
    final message =
        'Te invito a visitar ${widget.church.titulo} - ${widget.church.direccion}';
    Share.share(
      'Conexión+ - Directorio de Iglesias\n\n$message',
      subject: message,
    );
  }

  void _toggleFavorite() {
    AppSnackbar.show(
      context,
      message: 'Tienes que estar logueado para poder añadir a favoritos',
      type: SnackbarType.info,
    );
  }

  Future<void> _makePhoneCall(String? phoneNumber) async {
    if (phoneNumber != null && phoneNumber.isNotEmpty) {
      final Uri launchUri = Uri(
        scheme: 'tel',
        path: phoneNumber,
      );
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No se puede realizar la llamada'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _sendEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'info@${_getChurchSlug()}.com',
    );
    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    }
  }

  Future<void> _sendEmailToPastor() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: _pastorData['email'],
    );
    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    }
  }

  Future<void> _launchWebsite(String? url) async {
    if (url != null && url.isNotEmpty) {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No se puede abrir el sitio web'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _getDirections() {
    final lat = widget.church.latitud;
    final lng = widget.church.longitud;
    if (lat != null && lng != null) {
      final Uri mapsUri = Uri.parse(
          'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng');
      launchUrl(mapsUri);
    }
  }

  void _showPastorProfile() {
    // Navegar al perfil del pastor
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Perfil del pastor'),
        backgroundColor: ColorsUtils.principalColor,
      ),
    );
  }
}
