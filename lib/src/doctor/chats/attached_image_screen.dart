import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ViewAttachedImage extends StatefulWidget {
  static const String id = 'ViewAttachedImage';
  ViewAttachedImage({
    Key key,
    this.image,
    this.text,
  }) : super(key: key);
  final String text;
  final ImageProvider image;
  @override
  _ViewAttachedImageState createState() => _ViewAttachedImageState();
}

class _ViewAttachedImageState extends State<ViewAttachedImage> {
  bool isShowText = true;
  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isShowText = !isShowText;
                  });
                },
                child: PhotoView(
                  imageProvider: widget.image ??
                      CachedNetworkImageProvider(
                        'https://www.google.com/url?sa=i&url=https%3A%2F%2Fbitsofco.de%2Fhandling-broken-images-with-service-worker%2F&psig=AOvVaw2D0w00IWnhTJMNlT7r3t_x&ust=1601150393153000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCMCd15iMhewCFQAAAAAdAAAAABAD',
                      ),
                  minScale: PhotoViewComputedScale.contained * 1.0,
                  maxScale: PhotoViewComputedScale.contained * 2.5,
                  initialScale: PhotoViewComputedScale.contained * 1.0,
                ),
              ),
            ),
            Positioned(
              top: 5.0,
              right: 5.0,
              child: Material(
                shape: CircleBorder(),
                clipBehavior: Clip.hardEdge,
                color: Colors.black.withOpacity(0.05),
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 36.5,
                    height: 36.5,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      color: Colors.orange,
                      size: 30.0,
                    ),
                  ),
                ),
              ),
            ),
            isShowText
                ? Positioned(
                    bottom: 0.0,
                    child: Container(
                      padding: EdgeInsets.only(
                        top: 15.0,
                        right: 10.0,
                        bottom: 15.0,
                        left: 10.0,
                      ),
                      width: deviceWidth,
                      color: Colors.black.withOpacity(0.15),
                      child: Text(
                        widget.text ?? '',
                        style: TextStyle(
                            color: Colors.white, fontSize: 15.0),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
