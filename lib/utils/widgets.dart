import 'package:cached_network_image/cached_network_image.dart';
import 'package:conexion_mas/models/categorias.dart';
import 'package:conexion_mas/utils/colorsUtils.dart';
import 'package:conexion_mas/utils/mainUtils.dart';
import 'package:flutter/material.dart';
import 'package:input_quantity/input_quantity.dart';

class frcaWidget {
  // LINEA DE SEPARACION
  static frca_separacion() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
      child: Row(
        children: <Widget>[
          Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(color: ColorsUtils.blancoColor),
          ),
          SizedBox(
            width: 5.0,
          ),
          Container(
            width: 10,
            height: 5,
            decoration: BoxDecoration(color: ColorsUtils.blancoColor),
          ),
          SizedBox(
            width: 5.0,
          ),
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(color: ColorsUtils.blancoColor),
          ),
        ],
      ),
    );
  }

  static frca_header_bar(Function fns, context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: ColorsUtils.principalColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
            color: ColorsUtils.blancoColor,
          ),
        ),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: ColorsUtils.principalColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: IconButton(
            onPressed: () {
              fns();
            },
            icon: Icon(Icons.favorite_border),
            color: ColorsUtils.blancoColor,
          ),
        ),
      ],
    );
  }

  static frca_loading_container() {
    return Container(
      decoration: BoxDecoration(
        color: ColorsUtils.principalColor.withOpacity(0.7),
      ),
      child: Center(
        child: CircularProgressIndicator(
          color: ColorsUtils.blancoColor,
        ),
      ),
    );
  }

  static frca_cuenta_atras(String dias, horas, minutos, segundos) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // DIAS
        Container(
          width: 70.0,
          height: 70.0,
          decoration: BoxDecoration(
            color: ColorsUtils.principalColor,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                Text(
                  "Días",
                  style: TextStyle(
                    color: ColorsUtils.blancoColor,
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                  ),
                ),
                Text(
                  dias,
                  style: TextStyle(
                    color: ColorsUtils.blancoColor,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 5.0,
        ),
        // HORAS
        Container(
          width: 70.0,
          height: 70.0,
          decoration: BoxDecoration(
            color: ColorsUtils.principalColor,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                Text(
                  "Horas",
                  style: TextStyle(
                    color: ColorsUtils.blancoColor,
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                  ),
                ),
                Text(
                  horas,
                  style: TextStyle(
                    color: ColorsUtils.blancoColor,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 5.0,
        ),
        // MINUTOS
        Container(
          width: 70.0,
          height: 70.0,
          decoration: BoxDecoration(
            color: ColorsUtils.principalColor,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                Text(
                  "Minutos",
                  style: TextStyle(
                    color: ColorsUtils.blancoColor,
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                  ),
                ),
                Text(
                  minutos,
                  style: TextStyle(
                    color: ColorsUtils.blancoColor,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 5.0,
        ),
        // SEGUNDOS
        Container(
          width: 70.0,
          height: 70.0,
          decoration: BoxDecoration(
            color: ColorsUtils.principalColor,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                Text(
                  "Segundos",
                  style: TextStyle(
                    color: ColorsUtils.blancoColor,
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                  ),
                ),
                Text(
                  segundos,
                  style: TextStyle(
                    color: ColorsUtils.blancoColor,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static frca_header_main() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          decoration: BoxDecoration(
            color: ColorsUtils.blancoColor,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                top: 15.0, bottom: 15.0, left: 8.0, right: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 30,
                  height: 4,
                  decoration: BoxDecoration(
                    color: ColorsUtils.negroColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: 20,
                  height: 4,
                  decoration: BoxDecoration(
                    color: ColorsUtils.negroColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                )
              ],
            ),
          ),
        ),
        // AVATAR USER
        Container(
          width: 60,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            image: DecorationImage(
              image: NetworkImage(
                  'https://vallmarketing.es/app_assets/images/users/user_1.png'),
              fit: BoxFit.contain,
            ),
            border: Border.all(
              width: 5,
              color: ColorsUtils.blancoColor,
            ),
          ),
        ),
      ],
    );
  }

  static frca_buscador(
      Widget widgets, Function fns2, String texto, context, bool iconLeft) {
    String textBusca = "";

    return Container(
      decoration: BoxDecoration(
        color: ColorsUtils.segundoColor,
        borderRadius: BorderRadius.circular(60),
        boxShadow: [
          BoxShadow(
            color: ColorsUtils.negroColor.withOpacity(0.7),
            spreadRadius: 0.7,
            blurRadius: 0.7,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 0,
          bottom: 0,
          left: 25,
          right: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            iconLeft ? widgets : Container(),
            Expanded(
              child: TextField(
                onChanged: (value) {
                  textBusca = value;
                },
                style: TextStyle(
                  color: ColorsUtils.blancoColor,
                  fontSize: 14.0,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 0, vertical: 0), // Reduce el padding
                  border: OutlineInputBorder(),
                  fillColor: ColorsUtils.terceroColor,
                  hintText: texto,
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(width: 0, color: ColorsUtils.segundoColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(width: 0, color: ColorsUtils.segundoColor),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                fns2(textBusca);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: ColorsUtils.principalColor,
                  borderRadius: BorderRadius.circular(60),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.search,
                    color: ColorsUtils.blancoColor,
                    size: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static frca_main_menu(Function fns, int num, bool isLogin, String idUser) {
    return Container(
      decoration: BoxDecoration(
        color: ColorsUtils.principalColor.withOpacity(0.7),
        borderRadius: BorderRadius.circular(60),
        boxShadow: [
          BoxShadow(
            color: ColorsUtils.terceroColor.withOpacity(0.2),
            spreadRadius: 0.5,
            blurRadius: 0.5,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(
            left: 15.0, right: 15.0, top: 3.0, bottom: 3.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(
                Icons.home,
                color:
                    num == 0 ? ColorsUtils.blancoColor : ColorsUtils.negroColor,
                size: 30,
              ),
              onPressed: () {
                fns(0);
              },
            ),
            IconButton(
              icon: Icon(
                Icons.church,
                color:
                    num == 1 ? ColorsUtils.blancoColor : ColorsUtils.negroColor,
                size: 30,
              ),
              onPressed: () {
                fns(1);
              },
            ),
            IconButton(
              icon: Icon(
                Icons.calendar_view_day,
                color:
                    num == 2 ? ColorsUtils.blancoColor : ColorsUtils.negroColor,
                size: 30,
              ),
              onPressed: () {
                fns(2);
              },
            ),
            isLogin
                ? GestureDetector(
                    onTap: () {
                      fns(3);
                    },
                    child: CachedNetworkImage(
                      imageUrl:
                          "${MainUtils.urlHostAssets}/images/users/user_$idUser.png",
                      imageBuilder: (context, imageProvider) => Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Image.network(
                        "${MainUtils.urlHostAssets}/images/users/user_0.png",
                        fit: BoxFit.cover,
                        width: 40,
                        height: 40,
                      ),
                    ),
                  )
                : IconButton(
                    icon: Icon(
                      Icons.person,
                      color: num == 3
                          ? ColorsUtils.blancoColor
                          : ColorsUtils.negroColor,
                      size: 30,
                    ),
                    onPressed: () {
                      fns(3);
                    },
                  ),
          ],
        ),
      ),
    );
  }

  static frca_getMesIniciales(mes) {
    List arrayMes = [
      "DIC",
      "ENE",
      "FEB",
      "MAR",
      "ABR",
      "MAY",
      "JUN",
      "JUL",
      "AGO",
      "SEP",
      "OCT",
      "NOV",
      "DIC"
    ];

    return arrayMes[mes];
  }

  static frca_botones_map(Function fnsPlus, fnsMinus, fnsPosition) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: ColorsUtils.principalColor,
            borderRadius: BorderRadius.circular(5),
          ),
          child: IconButton(
            onPressed: () {
              fnsPosition();
            },
            icon: Icon(Icons.my_location_outlined),
            color: ColorsUtils.blancoColor,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: ColorsUtils.principalColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            ),
          ),
          child: IconButton(
            onPressed: () {
              fnsPlus();
            },
            icon: Icon(
              Icons.add,
            ),
            color: ColorsUtils.blancoColor,
          ),
        ),
        SizedBox(
          height: 0,
        ),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: ColorsUtils.principalColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(5),
              bottomRight: Radius.circular(5),
            ),
          ),
          child: IconButton(
            onPressed: () {
              fnsMinus();
            },
            icon: Icon(
              Icons.remove,
            ),
            color: ColorsUtils.blancoColor,
          ),
        ),
      ],
    );
  }

  static frca_categori_listOld(Function fns, int num) {
    return SizedBox(
      height: 40.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // TODOS
          GestureDetector(
            onTap: () => fns(0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Todo",
                  style: TextStyle(
                    color: ColorsUtils.blancoColor,
                    fontSize: 16,
                    fontWeight: num == 0 ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                if (num == 0)
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 5,
                        decoration: BoxDecoration(
                          color: ColorsUtils.principalColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Container(
                        width: 30,
                        height: 5,
                        decoration: BoxDecoration(
                          color: ColorsUtils.principalColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  )
              ],
            ),
          ),
          // DISTRITO 1
          SizedBox(
            width: 20,
          ),
          GestureDetector(
            onTap: () => fns(1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Región 1",
                  style: TextStyle(
                    color: ColorsUtils.blancoColor,
                    fontSize: 16,
                    fontWeight: num == 1 ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                if (num == 1)
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 5,
                        decoration: BoxDecoration(
                          color: ColorsUtils.principalColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Container(
                        width: 30,
                        height: 5,
                        decoration: BoxDecoration(
                          color: ColorsUtils.principalColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  )
              ],
            ),
          ),
          // DISTRITO 2
          SizedBox(
            width: 20,
          ),
          GestureDetector(
            onTap: () => fns(2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Región 2",
                  style: TextStyle(
                    color: ColorsUtils.blancoColor,
                    fontSize: 16,
                    fontWeight: num == 2 ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                if (num == 2)
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 5,
                        decoration: BoxDecoration(
                          color: ColorsUtils.principalColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Container(
                        width: 30,
                        height: 5,
                        decoration: BoxDecoration(
                          color: ColorsUtils.principalColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  )
              ],
            ),
          ),
          // DISTRITO 3
          SizedBox(
            width: 20,
          ),
          GestureDetector(
            onTap: () => fns(3),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Región 3",
                  style: TextStyle(
                    color: ColorsUtils.blancoColor,
                    fontSize: 16,
                    fontWeight: num == 3 ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                if (num == 3)
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 5,
                        decoration: BoxDecoration(
                          color: ColorsUtils.principalColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Container(
                        width: 30,
                        height: 5,
                        decoration: BoxDecoration(
                          color: ColorsUtils.principalColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget frca_categori_list(
      Function(int) fns, int selectedIndex, List<Categorias> categorias) {
    return SizedBox(
      height: 40.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // Widget para "Todos" (opcional)
          _buildCategoriaItem(
            fns: fns,
            id: 0,
            nombre: "Todo",
            selectedIndex: selectedIndex,
          ),
          SizedBox(width: 20),

          // Lista dinámica de categorías
          ...categorias.map((categoria) {
            return Row(
              children: [
                _buildCategoriaItem(
                  fns: fns,
                  id: categoria.id ?? 0,
                  nombre: categoria.titulo ?? '',
                  selectedIndex: selectedIndex,
                ),
                SizedBox(width: 20),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  // Método auxiliar para construir cada ítem de categoría
  static Widget _buildCategoriaItem({
    required Function(int) fns,
    required int id,
    required String nombre,
    required int selectedIndex,
  }) {
    return GestureDetector(
      onTap: () => fns(id),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            nombre,
            style: TextStyle(
              color: ColorsUtils.blancoColor,
              fontSize: 14,
              fontWeight:
                  selectedIndex == id ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (selectedIndex == id)
            Row(
              children: [
                Container(
                  width: 10,
                  height: 5,
                  decoration: BoxDecoration(
                    color: ColorsUtils.principalColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(width: 2),
                Container(
                  width: 30,
                  height: 5,
                  decoration: BoxDecoration(
                    color: ColorsUtils.principalColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            )
        ],
      ),
    );
  }

  static frca_texto_header(String texto, Widget widgets) {
    return Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  texto,
                  style: TextStyle(
                    color: ColorsUtils.blancoColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 2,
            ),
            Row(
              children: [
                Container(
                  width: 10,
                  height: 5,
                  decoration: BoxDecoration(
                    color: ColorsUtils.principalColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                Container(
                  width: 30,
                  height: 5,
                  decoration: BoxDecoration(
                    color: ColorsUtils.principalColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            )
          ],
        ),
        widgets,
      ],
    );
  }

  static frca_not_lista() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.info_outline,
            size: 190,
            color: ColorsUtils.principalColor,
          ),
          SizedBox(height: 8),
          Text(
            "No hay datos para mostrar",
            style: TextStyle(color: ColorsUtils.negroColor, fontSize: 14),
          ),
        ],
      ),
    );
  }

  static frca_not_lista_txt(String mensaje) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          mensaje,
          style: TextStyle(color: ColorsUtils.blancoColor, fontSize: 14),
        ),
      ),
    );
  }

  static frca_number_evento(String titulo, descripcion, precio, restante,
      context, Function fns1, int id, int index) {
    String precioTxt = precio == "0" ? "GRATIS" : "$precio €";
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 5.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: ColorsUtils.blancoColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(titulo),
                            content: Text(descripcion),
                            actions: <Widget>[
                              TextButton(
                                style: TextButton.styleFrom(
                                  textStyle:
                                      Theme.of(context).textTheme.labelLarge,
                                ),
                                child: const Text('Cerrar'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 180,
                      child: Text(
                        titulo,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: ColorsUtils.segundoColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    precioTxt,
                    style: TextStyle(
                        fontSize: 20,
                        color: ColorsUtils.negroColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Roboto"),
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  InputQty(
                    maxVal: 100,
                    initVal: 0,
                    minVal: 0,
                    steps: 1,
                    qtyFormProps: QtyFormProps(
                      style: TextStyle(
                          fontSize: 22, // Cambia el tamaño del texto
                          color: ColorsUtils
                              .negroColor, // Cambia el color del texto
                          fontWeight: FontWeight.bold,
                          fontFamily: "Roboto"),
                    ),
                    decoration: QtyDecorationProps(
                        width: 4,
                        qtyStyle: QtyStyle.classic,
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: ColorsUtils.principalColor,
                            ),
                            borderRadius: BorderRadius.circular(6)),
                        minusBtn: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 0),
                          child: Icon(
                            Icons.remove,
                            color: ColorsUtils.principalColor,
                            size: 38,
                          ),
                        ),
                        plusBtn: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 0),
                          child: Icon(
                            Icons.add,
                            color: ColorsUtils.principalColor,
                            size: 38,
                          ),
                        )),
                    onQtyChanged: (val) {
                      fns1(val, id, index);
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: ColorsUtils.principalColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 3.0,
                        bottom: 3.0,
                        right: 15.0,
                        left: 15.0,
                      ),
                      child: Text("$restante restantes"),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static frca_loading_simple() {
    return Center(
      child: SizedBox(
          width: 60,
          height: 60,
          child: CircularProgressIndicator(
            color: ColorsUtils.principalColor,
            strokeWidth: 3,
          )),
    );
  }
}
