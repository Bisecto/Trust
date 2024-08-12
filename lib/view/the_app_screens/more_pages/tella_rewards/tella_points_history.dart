import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:teller_trust/bloc/tellapoint/tellapoint_bloc.dart';
import 'package:teller_trust/res/app_colors.dart';
import 'package:teller_trust/res/app_icons.dart';

import '../../../../model/tellapoint_history_model.dart';
import '../../../../utills/app_utils.dart';
import '../../../../utills/custom_theme.dart';
import '../../../widgets/app_custom_text.dart';

class TellaPointsHistory extends StatefulWidget {
  const TellaPointsHistory({super.key});

  @override
  State<TellaPointsHistory> createState() => _TellaPointsHistoryState();
}

class _TellaPointsHistoryState extends State<TellaPointsHistory> {
  TellapointBloc tellapointBloc = TellapointBloc();
  final PagingController<int, dynamic> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    // TODO: implement initState
    //tellapointBloc.add(Get)
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      print(pageKey.toString());
      tellapointBloc.add(GetTellaPointHistory('', '20', pageKey.toString()));
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 0,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 0.0, right: 0.0),
              child: Container(
               // co
                child: BlocConsumer<TellapointBloc, TellapointState>(
                  bloc: tellapointBloc,
                  listener: (context, state) {
                    if (state is TellapointSuccessState) {
                      final newItems = state.tellaPointHistoryModel.data.items;
                      final isLastPage =
                          state.tellaPointHistoryModel.data.currentPage ==
                              state.tellaPointHistoryModel.data.totalPages;
                      if (isLastPage) {
                        _pagingController.appendLastPage(newItems);
                      } else {
                        final nextPageKey =
                            state.tellaPointHistoryModel.data.currentPage + 1;
                        _pagingController.appendPage(newItems, nextPageKey);
                      }
                    } else if (state is AccessTokenExpireState) {
                      _pagingController.error = "Access Token Expired";
                    } else if (state is TellapointErrorState) {
                      _pagingController.error = state.msg;
                    }
                  },
                  builder: (context, state) {
                    return PagedListView<int, dynamic>(
                      pagingController: _pagingController,
                      builderDelegate: PagedChildBuilderDelegate<dynamic>(
                        itemBuilder: (context, item, index) {
                 if (item is Tellapoints) {
                            // This is a transaction
                            // final order = item.order;

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  // AppNavigator.pushAndStackPage(
                                  //   context,
                                  //   page: TransactionReceipt(transaction: item),
                                  // );
                                },
                                child: SizedBox(
                                  //height: 90,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        //crossAxisAlignment: CrossAxisAlignment.c,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(AppIcons.badge),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              TextStyles.textSubHeadings(
                                                  textValue:
                                                      item.transaction.description),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              CustomText(
                                                text: item.transaction.description
                                                    .split(' ')[0],
                                                weight: FontWeight.bold,
                                                size: 12,
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          TextStyles.textSubHeadings(
                                              textValue:
                                                  "${item.transaction.type.toLowerCase() == 'debit' ? '-' : "+"}" +
                                                      item.amount.toString()),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          CustomText(
                                            text: AppUtils.formateSimpleDate(
                                                dateTime:
                                                    item.createdAt.toString()),
                                            weight: FontWeight.bold,
                                            size: 12,
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
