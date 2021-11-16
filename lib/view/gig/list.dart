import 'package:flutter/material.dart';
import 'package:freibr/common/images.dart';
import 'package:freibr/common/widget/FREmpty.dart';
import 'package:freibr/common/widget/statefull_wrapper.dart';
import 'package:freibr/core/controller/gig.dart';
import 'package:freibr/core/model/gig/gig.dart';
import 'package:freibr/util/util.dart';
import 'package:freibr/view/gig/information.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class GigsList extends StatelessWidget {
  GigsList({Key key}) : super(key: key);
  ScrollController _scrollController;
  int pageSize = 12;
  bool _isFetchingMore = false;

  @override
  Widget build(BuildContext context) {
    GigController controller = Provider.of(context);
    ThemeData theme = Get.theme;

    void getPagedGigs({bool isRefresh = false, bool isInit = false}) {
      if (isInit) {
        controller.gigPagingController.clearItems();
        controller.gigPagingController.items.clear();
      }
      controller.getGigs(
          isInit ? 1 : controller.gigPagingController.page, pageSize,
          isRefresh: isRefresh);
    }

    void fetchMore() async {
      if (_scrollController.position.maxScrollExtent -
              _scrollController.offset <
          50) {
        if (controller.isEnabledMore && !_isFetchingMore) {
          _isFetchingMore = true;
          await controller.getGigs(
            controller.gigPagingController.page,
            pageSize,
          );
          _isFetchingMore = false;
        }
      }
    }

    return StatefulWrapper(
      onInit: () async {
        Future.microtask(() => controller.resetState());
        _scrollController = ScrollController();
        _scrollController.addListener(fetchMore);
        getPagedGigs(isRefresh: true, isInit: true);
      },
      dispose: () {
        _scrollController.dispose();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("My Services",
              style: theme.textTheme.subtitle1.copyWith(fontSize: 14.sp)),
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          child: !controller.gigPagingController.hasData &&
                  !controller.isLoading
              ? FREmptyScreen(
                  imageSrc: 'assets/images/create_a_new_gig.png',
                  title: 'Nothing to show',
                  onTap: () {
                    getPagedGigs(isRefresh: true);
                  },
                )
              : controller.isLoading && !controller.gigPagingController.hasData
                  ? Center(child: frCircularLoader())
                  : ListView.separated(
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(height: 25),
                      controller: _scrollController,
                      itemBuilder: (c, index) {
                        if (controller.gigPagingController.items.length > 0) {
                          var item =
                              controller.gigPagingController.items[index];
                          if (controller.isEnabledMore &&
                              controller.gigPagingController.items.length - 1 ==
                                  index) {
                            return Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                alignment: Alignment.center,
                                child: frCircularLoader(
                                  height: 20,
                                  width: 20,
                                ));
                          }
                          return Card(
                            child: ListTile(
                              contentPadding: EdgeInsets.all(10.0),
                              title: Text(item.title ?? ""),
                              subtitle: Text(item.description ?? ""),
                              onTap: () {
                                controller.modifyGigModel(item);
                                controller.setIsEdited(true);

                                print(controller.gig.faqs);
                                Get.to(() => GigInformation(
                                      isEditMode: true,
                                    ));
                              },
                            ),
                          );
                        }
                        return Container();
                      },
                      itemCount: controller.gigPagingController.items.length,
                    ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          // isExtended: true,
          child: Icon(Icons.add),
          onPressed: () {
            controller.modifyGigModel(new GigModel());
            Get.to(() => GigInformation());
          },
        ),
      ),
    );
  }
}
