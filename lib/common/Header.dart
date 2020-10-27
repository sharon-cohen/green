import 'package:flutter/material.dart';
import 'package:greenpeace/home/home_menager.dart';
import 'package:greenpeace/Footer/footer.dart';

class MyHeader extends StatefulWidget {
  final String image;
  final String page;
  final double offset;
  const MyHeader({Key key, this.image, this.offset, this.page})
      : super(key: key);

  @override
  _MyHeaderState createState() => _MyHeaderState();
}

class _MyHeaderState extends State<MyHeader> {
  bool check_page() {
    if (widget.page == "event" || widget.page == "struggle") {
      return true;
    } else
      return false;
  }

  bool check_image() {
    if (widget.image.contains("image/")) {
      return true;
    } else
      return false;
  }

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: MyClipper(),
      child: Container(
        height: MediaQuery.of(context).size.height / (2.3),
        width: double.infinity,
        decoration: BoxDecoration(
          image: check_image()
              ? new DecorationImage(
                  image: new ExactAssetImage(widget.image),
                  fit: BoxFit.cover,
                )
              : new DecorationImage(
                  image: NetworkImage(widget.image),
                  fit: BoxFit.cover,
                ),
        ),
        child: check_page()
            ? Padding(
                padding: const EdgeInsets.only(
                  left: 30,
                  top: 30,
                  right: 10,
                ),
                child: Align(
                    alignment: Alignment.topRight,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey,
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    BottomNavigationBarController(2, 1)),
                          );
                        },
                        icon: Icon(
                          Icons.clear,
                          color: Colors.white,
                        ),
                      ),
                    )),
              )
            : Container(),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 80);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
