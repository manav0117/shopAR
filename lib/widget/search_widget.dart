import 'package:e_com/constants.dart';
import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      // borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: TextField(
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: "Search items",
              prefixIcon: InkWell(
                child: Icon(Icons.search),
                onTap: () {},
              ),
              border: InputBorder.none),
        ),
      ),
    );
  }
}
