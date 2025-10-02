import 'package:conexion_mas/controllers/ProfileServide.dart';
import 'package:flutter/material.dart';

class FollowButton extends StatefulWidget {
  final int? idIglesia;
  final int? idEvento;
  final String tipo;
  final Function(bool)? onStateChanged;

  const FollowButton({
    Key? key,
    this.idIglesia,
    this.idEvento,
    required this.tipo,
    this.onStateChanged,
  }) : super(key: key);

  @override
  _FollowButtonState createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  bool _isFollowing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkIfFollowing();
  }

  Future<void> _checkIfFollowing() async {
    setState(() => _isLoading = true);
    try {
      final response = await ProfileService.checkFollowing(
        widget.idIglesia,
        widget.idEvento,
        widget.tipo,
      );
      setState(() {
        _isFollowing = response['data']['siguiendo'] ?? false;
        _isLoading = false;
      });
      if (widget.onStateChanged != null) {
        widget.onStateChanged!(_isFollowing);
      }
    } catch (error) {
      setState(() => _isLoading = false);
      print('Error checking follow status: $error');
    }
  }

  Future<void> _toggleFollow() async {
    setState(() => _isLoading = true);
    try {
      if (_isFollowing) {
        await ProfileService.unfollow(
            widget.idIglesia, widget.idEvento, widget.tipo);
      } else {
        await ProfileService.follow({
          'idIglesia': widget.idIglesia,
          'idEvento': widget.idEvento,
          'tipo': widget.tipo,
        });
      }

      setState(() {
        _isFollowing = !_isFollowing;
        _isLoading = false;
      });

      if (widget.onStateChanged != null) {
        widget.onStateChanged!(_isFollowing);
      }
    } catch (error) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : IconButton(
            iconSize: 20.0,
            icon: Icon(
              _isFollowing ? Icons.favorite : Icons.favorite_border,
              color: _isFollowing ? Colors.red : null,
            ),
            onPressed: _toggleFollow,
          );
  }
}
