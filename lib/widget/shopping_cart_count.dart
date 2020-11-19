import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef void ValueChanged(int count);
Color borderColor = Colors.grey[200];
class CartCount extends StatefulWidget {
  CartCount({
    this.number,
    this.min,
    this.max,
    this.onChange,
  });

  final ValueChanged onChange;
  final int number;
  final int min;
  final int max;

  @override
  _CartCountState createState() => _CartCountState();
}

class _CartCountState extends State<CartCount> {
  int num = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    num = widget.number;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: 120,
      decoration: BoxDecoration(
          border: Border.all(
            color: borderColor,
          ),
          borderRadius: BorderRadius.circular(2)),
      child: Row(
        children: <Widget>[
          Container(
            width: 35,
            color:
                widget.min >= num ? Colors.grey[200] : Colors.white,
            child: InkResponse(
              child: Center(
                child: Icon(
                  Icons.remove,
                  color: widget.min >= widget.number
                      ? Colors.grey[500]
                      : Colors.black,
                ),
              ),
              onTap: () {
                onClickBtn('remove');
              },
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: borderColor),
                  right: BorderSide(color: borderColor),
                ),
              ),
              child: Center(
                child: Text(
                  '${num}',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
          Container(
            width: 35,
            color:
                widget.max <= num ? Colors.grey[200] : Colors.white,
            child: InkResponse(
              child: Center(
                child: Icon(
                  Icons.add,
                  color: widget.max <= widget.number
                      ? Colors.grey[500]
                      : Colors.black,
                ),
              ),
              onTap: () {
                onClickBtn('add');
              },
            ),
          ),
        ],
      ),
    );
  }

  onClickBtn(String type) {
    if (type == 'remove' && num > widget.min) {
      setState(() {
        num -= 1;
        widget.onChange(num);
      });
    } else if (type == 'add' && num < widget.max) {
      setState(() {
        num += 1;
        widget.onChange(num);
      });
    }
  }
}
