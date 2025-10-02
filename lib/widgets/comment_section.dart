import 'package:conexion_mas/controllers/ProfileServide.dart';
import 'package:conexion_mas/models/comment.dart';
import 'package:conexion_mas/utils/colorsUtils.dart';
import 'package:conexion_mas/utils/mainUtils.dart';
import 'package:flutter/material.dart';

class CommentSection extends StatefulWidget {
  final int? idIglesia;
  final int? idEvento;
  final String tipo;

  const CommentSection({
    Key? key,
    this.idIglesia,
    this.idEvento,
    required this.tipo,
  }) : super(key: key);

  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final TextEditingController _commentController = TextEditingController();
  List<Comment> _comments = [];
  bool _isLoading = true;
  int _rating = 0;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _loadComments() async {
    try {
      final response = await ProfileService.getComments(
        widget.idIglesia,
        widget.idEvento,
        widget.tipo,
      );

      final List<dynamic> commentData = response['data'];
      setState(() {
        _comments = commentData.map((json) => Comment.fromJson(json)).toList();
        _isLoading = false;
      });
    } catch (error) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar comentarios: $error')),
      );
    }
  }

  Future<void> _addComment() async {
    if (_commentController.text.isEmpty) return;

    try {
      final commentData = {
        'idIglesia': widget.idIglesia,
        'idEvento': widget.idEvento,
        'tipo': widget.tipo,
        'comentario': _commentController.text,
        'calificacion': _rating,
      };

      final response = await ProfileService.addComment(commentData);
      final newComment = Comment.fromJson(response['data']);

      setState(() {
        _comments.insert(0, newComment);
        _commentController.clear();
        _rating = 0;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al agregar comentario: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: ColorsUtils.terceroColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  'Comentarios y Reseñas',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                // Selector de calificación
                Row(
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < _rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 28,
                      ),
                      onPressed: () {
                        setState(() {
                          _rating = index + 1;
                        });
                      },
                    );
                  }),
                ),
                // Campo de texto para comentario
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          hintText: 'Escribe tu comentario...',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 2,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: _addComment,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        _isLoading
            ? Center(child: CircularProgressIndicator())
            : _comments.isEmpty
                ? Center(child: Text('No hay comentarios aún'))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _comments.length,
                    itemBuilder: (context, index) {
                      return _CommentItem(comment: _comments[index]);
                    },
                  ),
      ],
    );
  }
}

class _CommentItem extends StatelessWidget {
  final Comment comment;

  const _CommentItem({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 3, horizontal: 0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: comment.userFoto != null
              ? NetworkImage("${MainUtils.urlHostAssets}/${comment.userFoto!}")
              : AssetImage('assets/images/default_avatar.png') as ImageProvider,
        ),
        title: Row(
          children: [
            Expanded(child: Text(comment.userName)),
            if (comment.calificacion > 0)
              Row(
                children: List.generate(comment.calificacion, (index) {
                  return Icon(Icons.star, size: 16, color: Colors.amber);
                }),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(comment.comentario),
            SizedBox(height: 4),
            Text(
              comment.fecha,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
