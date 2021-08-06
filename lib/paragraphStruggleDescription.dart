import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
class paragraphStruggleDescription extends StatelessWidget {
  paragraphStruggleDescription(this.des,this.image);
  final String image;
  final String des;
  @override
  Widget build(BuildContext context) {
  print(des);
    return des!='w'? Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Container(
            width:MediaQuery.of(context).size.width ,
            child: AutoSizeText(
              des,
              style: TextStyle(fontFamily: 'Assistant', fontSize:20,
                // color: Colors.green,
              ),
            ),
          ),
        ),
        image!=" "? Padding(
          padding: const EdgeInsets.all(12),
          child: Card(
            elevation: 1,
            child: Container(
              height:  MediaQuery.of(context).size.height/4,
              child: Container(
                height:  MediaQuery.of(context).size.height/4,

                child: AspectRatio(
                  aspectRatio: 16/9,
                  child:
                  CachedNetworkImage(
                    imageUrl: image,fit: BoxFit.cover,
                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                        CircularProgressIndicator(value: downloadProgress.progress),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
            ),
          ),
        ):Container(),
      ],
    ):Container();
  }
}
