import 'package:flutter/material.dart';
import 'package:flutter_app/component/loading.dart';
import 'package:flutter_app/component/sliver_footer.dart';
import 'package:flutter_app/component/slivers.dart';
import 'package:flutter_app/constant/colors.dart';
import 'package:flutter_app/constant/fonts.dart';
import 'package:flutter_app/http_manager/api.dart';
import 'package:flutter_app/model/category.dart';
import 'package:flutter_app/model/itemListItem.dart';
import 'package:flutter_app/ui/sort/good_item_widget.dart';
import 'package:flutter_app/ui/sort/model/sortListData.dart';

class SortListItemPage extends StatefulWidget {
  var arguments;

  SortListItemPage({this.arguments});

  @override
  _CatalogGoodsState createState() => _CatalogGoodsState();
}

///AutomaticKeepAliveClientMixin  保持滑动不刷新  重写方法 bool get wantKeepAlive => true;
class _CatalogGoodsState extends State<SortListItemPage>
    with AutomaticKeepAliveClientMixin {
  bool _isLoading = true;
  int _total = 0;
  bool _moreLoading = false;
  final _scrollController = new ScrollController();
  Category category;

  ///商品
  List<ItemListItem> _itemList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getInitData();

    _scrollController.addListener(() {
      // 如果下拉的当前位置到scroll的最下面
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!_moreLoading && (_total > _itemList.length)) {
          // _getMore();
        }
      }
    });
  }

  _getInitData() async {
    var map = {
      "categoryType": "0",
      "subCategoryId": widget.arguments.id,
      "categoryId": widget.arguments.superCategoryId,
    };
    var responseData = await sortListData(map);
    var data = responseData.data;
    var sortListDataModel = SortListData.fromJson(data);

    setState(() {
      _itemList = sortListDataModel.categoryItems.itemList;

      category = sortListDataModel.categoryItems.category;

      // category = data["categoryItems"]["category"];
      _isLoading = false;
      _total = _itemList.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Loading();
    } else {
      return RefreshIndicator(
        onRefresh: _refresh,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            if (category.frontName != null && category.frontName != "")
              singleSliverWidget(Container(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  color: backWhite,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    category.frontName,
                    style: t14black,
                  ),
                ),
              )),
            GoodItemWidget(dataList: _itemList),
            SliverFooter(hasMore: _itemList.length != _total),
          ],
        ),
      );
    }
  }

  Future _refresh() async {
    _getInitData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
