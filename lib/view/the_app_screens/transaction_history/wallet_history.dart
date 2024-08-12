import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:teller_trust/bloc/wallet_bloc/wallet_bloc.dart';
import 'package:teller_trust/model/wallet_history_model.dart';
import 'package:teller_trust/view/the_app_screens/transaction_history/transaction_history_appbar.dart';

import '../../../res/app_icons.dart';
import '../../../utills/app_utils.dart';
import '../../widgets/app_custom_text.dart';

class WalletHistory extends StatefulWidget {
  const WalletHistory({
    super.key,
  });

  @override
  State<WalletHistory> createState() => _WalletHistoryState();
}

class _WalletHistoryState extends State<WalletHistory> {
  WalletBloc walletBloc = WalletBloc();
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
      walletBloc.add(GetWalletHistory('', '20', pageKey.toString()));
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        children: [
          TransactionHistoryCustomAppBar(
              title: 'Wallet History', showFilter: true),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 0.0, right: 0.0),
              child: BlocConsumer<WalletBloc, WalletState>(
                bloc: walletBloc,
                listener: (context, state) {
                  if (state is WalletHistorySuccessState) {
                    final newItems = state.walletHistoryModel.data.items;
                    final isLastPage =
                        state.walletHistoryModel.data.currentPage ==
                            state.walletHistoryModel.data.totalPages;
                    if (isLastPage) {
                      _pagingController.appendLastPage(newItems);
                    } else {
                      final nextPageKey =
                          state.walletHistoryModel.data.currentPage + 1;
                      _pagingController.appendPage(newItems, nextPageKey);
                    }
                  } else if (state is AccessTokenExpireState) {
                    _pagingController.error = "Access Token Expired";
                  } else if (state is WalletHistoryErrorState) {
                    _pagingController.error = state.msg;
                  }
                },
                builder: (context, state) {
                  return PagedListView<int, dynamic>(
                    pagingController: _pagingController,
                    builderDelegate: PagedChildBuilderDelegate<dynamic>(
                      itemBuilder: (context, item, index) {
                        if (item is Wallet) {
                          return InkWell(
                            onTap: () {
                              // AppNavigator.pushAndStackPage(
                              //   context,
                              //   page: TransactionReceipt(transaction: item),
                              // );
                            },
                            child: Padding(padding: EdgeInsets.all(10),
                            child:SizedBox(
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
                                              item.transaction.type.toUpperCase()),
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
                            )),
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

        ],
      ),
    );
  }
}
