import 'package:conexion_mas/controllers/user_follow_service.dart';
import 'package:conexion_mas/helper/snackbar.dart';
import 'package:conexion_mas/utils/colorsUtils.dart';
import 'package:flutter/material.dart';

class UserFollowButton extends StatefulWidget {
  final int userId;
  final String userName;
  final bool? isFollowing;
  final String userToken;
  final Function(bool)? onStateChanged;
  final bool showLabel;

  const UserFollowButton({
    Key? key,
    required this.userId,
    required this.userName,
    required this.userToken,
    this.isFollowing,
    this.onStateChanged,
    this.showLabel = true, required bool smallVersion,
  }) : super(key: key);

  @override
  _UserFollowButtonState createState() => _UserFollowButtonState();
}

class _UserFollowButtonState extends State<UserFollowButton> {
  bool _isFollowing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isFollowing = widget.isFollowing ?? false;
  }

  @override
  void didUpdateWidget(covariant UserFollowButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFollowing != null && widget.isFollowing != _isFollowing) {
      setState(() {
        _isFollowing = widget.isFollowing!;
      });
    }
  }

  Future<void> _toggleFollow() async {
    setState(() => _isLoading = true);
    try {
      if (_isFollowing) {
        await UserFollowService.unfollowUser(widget.userId, widget.userToken);
      } else {
        await UserFollowService.followUser(widget.userId, widget.userToken);
      }

      setState(() {
        _isFollowing = !_isFollowing;
        _isLoading = false;
      });

      if (widget.onStateChanged != null) {
        widget.onStateChanged!(_isFollowing);
      }

      if (_isFollowing) {
        AppSnackbar.show(
          context,
          message: '✅ Ahora sigues a ${widget.userName}',
          type: SnackbarType.success,
        );
      } else {
        AppSnackbar.show(
          context,
          message: '❌ Has dejado de seguir a ${widget.userName}',
          type: SnackbarType.info,
        );
      }
    } catch (error) {
      setState(() => _isLoading = false);

      AppSnackbar.show(
        context,
        message: '❌ Error: $error',
        type: SnackbarType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return SizedBox(
        width: widget.showLabel ? null : 24,
        height: widget.showLabel ? null : 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    return widget.showLabel
        ? ElevatedButton(
            onPressed: _toggleFollow,
            style: ElevatedButton.styleFrom(
              backgroundColor: _isFollowing
                  ? ColorsUtils.blancoColor
                  : ColorsUtils.principalColor,
              foregroundColor: _isFollowing
                  ? ColorsUtils.terceroColor
                  : ColorsUtils.blancoColor,
            ),
            child: Text(_isFollowing ? 'Siguiendo' : 'Seguir'),
          )
        : IconButton(
            icon: Icon(
              _isFollowing ? Icons.person : Icons.person_add,
              color: _isFollowing
                  ? ColorsUtils.principalColor
                  : ColorsUtils.terceroColor,
            ),
            onPressed: _toggleFollow,
            tooltip: _isFollowing ? 'Dejar de seguir' : 'Seguir usuario',
          );
  }
}
