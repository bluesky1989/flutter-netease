import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/component/my_vertical_text.dart';
import 'package:flutter_app/component/slivers.dart';
import 'package:flutter_app/constant/colors.dart';
import 'package:flutter_app/constant/fonts.dart';
import 'package:flutter_app/model/itemListItem.dart';
import 'package:flutter_app/ui/router/router.dart';
import 'package:flutter_app/utils/price_util.dart';

const marginS = 8.0;
const mrr = 5.0;

class GoodItemNormalWidget extends StatelessWidget {
  final List<ItemListItem> dataList;

  const GoodItemNormalWidget({Key key, this.dataList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildItems(dataList);
  }

  _buildItems(List<ItemListItem> data) {
    return data.isEmpty
        ? buildASingleSliverGrid(Container(), 2)
        : SliverPadding(
            padding:
                EdgeInsets.symmetric(horizontal: marginS, vertical: marginS),
            sliver: SliverGrid(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                Widget widget = Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.transparent),
                  child: _buildGoodItem(context, index, data),
                );
                return GestureDetector(
                  child: widget,
                  onTap: () {
                    print(data[index]);
                    Routers.push(
                        Routers.goodDetail, context, {'id': data[index].id});
                  },
                );
              }, childCount: data.length),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.6,
                  mainAxisSpacing: 0,
                  crossAxisSpacing: marginS),
            ),
          );
  }

  _buildGoodItem(BuildContext context, int index, List<ItemListItem> dataList) {
    var item = dataList[index];
    var itemTagList = dataList[index].itemTagList;
    var imgHeight = MediaQuery.of(context).size.width / 2;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: imgHeight,
            decoration: BoxDecoration(
              color: Color(0x33E9E9E8),
              borderRadius: BorderRadius.vertical(top: Radius.circular(3)),
            ),
            child: Stack(
              children: [
                _roundImg(
                  item.listPicUrl,
                ),
                if (dataList[index].colorNum != null &&
                    dataList[index].colorNum > 0)
                  Container(
                    padding: EdgeInsets.fromLTRB(1, 2, 1, 2),
                    decoration: BoxDecoration(
                      color: Color(0XFFF4F4F4),
                      border: Border.all(color: Color(0xFFA28C63), width: 0.5),
                      borderRadius: BorderRadius.circular(1),
                    ),
                    margin: EdgeInsets.only(top: 5, left: 5),
                    child: MyVerticalText(
                      '${dataList[index].colorNum}色可选',
                      TextStyle(color: Color(0xFFA28C63), fontSize: 10),
                    ),
                  ),
                if (item.promDesc != null)
                  Positioned(
                      bottom: 10, left: 10, child: _promDesc(item.promDesc))
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    '${dataList[index].name}',
                    style: t15blackBold,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // _buildTags(itemTagList),
                _price(item),
                _priceDec(item),
                if (_getBannerContent(item).length > 7)
                  Expanded(
                      child: Container(
                    margin: EdgeInsets.only(top: 3),
                    child: Text(
                      '${_getBannerContent(item)}',
                      style: TextStyle(
                          color: textRed,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          height: 1),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))
              ],
            ),
          )
        ],
      ),
    );
  }

  _getBannerContent(ItemListItem item) {
    var content = '';
    if (item.finalPriceInfoVO.banner != null) {
      content = item.finalPriceInfoVO.banner.content ?? '';
    }
    return content;
  }

  _priceDec(ItemListItem item) {
    var finalPriceInfoVO = item.finalPriceInfoVO;
    var banner = finalPriceInfoVO.banner;
    if (banner == null) {
      return Container();
    } else {
      if (banner.title == null && banner.content != null) {
        return Container(
          margin: EdgeInsets.only(top: 5),
          padding: EdgeInsets.symmetric(vertical: 1, horizontal: 6),
          decoration: BoxDecoration(
            color: backRed,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '${banner.content}',
            style: t12white,
          ),
        );
      }
    }
    return Container(
      margin: EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        color: Color(0xFFFFE9EB),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
            decoration: BoxDecoration(
              color: backRed,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '${banner.title}',
              style: t12white,
            ),
          ),
          SizedBox(width: 3),
          if (_getBannerContent(item).length <= 7)
            Text(
              '${_getBannerContent(item)}',
              style: t12redBold,
            )
        ],
      ),
    );
  }

  _price(ItemListItem item) {
    List<String> priceToStr = ['', ''];
    String pricePrefix = '';
    String priceSuffix = '';
    String counterPrice = '';
    var finalPrice = item.finalPriceInfoVO.priceInfo.finalPrice;
    counterPrice = item.finalPriceInfoVO.priceInfo.counterPrice;
    if (finalPrice != null) {
      priceToStr = PriceUtil.priceToStr(finalPrice.price);
      pricePrefix = finalPrice.prefix ?? '';
      priceSuffix = finalPrice.suffix ?? '';
    } else {
      priceToStr = PriceUtil.priceToStr(item.retailPrice.toString());
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text("$pricePrefix¥", style: t12redBold),
        Text(
          "${priceToStr[0]}",
          style: t20redBold,
        ),
        Text(
          "${priceToStr[1]}$priceSuffix",
          style: t12redBold,
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          _getCounterPrice(item) == null
              ? ""
              : "¥${_getCounterPrice(item) ?? ''}",
          style: TextStyle(
              color: textGrey,
              decoration: TextDecoration.lineThrough,
              fontSize: 11),
        ),
      ],
    );
  }

  _getCounterPrice(ItemListItem item) {
    var finalCounterPrice = item.finalPriceInfoVO.priceInfo.counterPrice;
    var counterPrice = finalCounterPrice ?? (item.counterPrice ?? null);
    return counterPrice;
  }

  _promDesc(String dec) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
          color: backWhite,
          border: Border.all(color: textRed, width: 1),
          borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/good_red.png',
            width: 7,
          ),
          SizedBox(width: 2),
          Text(
            '$dec',
            style: t12red,
          ),
        ],
      ),
    );
  }

  _roundImg(String url) {
    return Container(
      child: CachedNetworkImage(
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Color(0xFFF4F4F4),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        imageUrl: url,
      ),
    );
  }
}
