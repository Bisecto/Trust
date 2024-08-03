import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:teller_trust/utills/app_utils.dart';
import 'package:teller_trust/view/the_app_screens/transaction_history/transaction_history_appbar.dart';

import '../../../bloc/app_bloc/app_bloc.dart';
import '../../../model/transactionHistory.dart';
import '../../../res/app_colors.dart';
import '../../../utills/app_navigator.dart';
import '../../../utills/constants/loading_dialog.dart';
import '../../../utills/custom_theme.dart';
import '../../../utills/enums/toast_mesage.dart';
import '../../../utills/shared_preferences.dart';
import '../../auth/sign_in_with_access_pin_and_biometrics.dart';
import '../../widgets/app_custom_text.dart';
import '../../widgets/purchase_receipt.dart';
import '../../widgets/show_toast.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({super.key});

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  //static const _pageSize = 20;

  final PagingController<int, dynamic> _pagingController =
      PagingController(firstPageKey: 1);

  AppBloc appBloc = AppBloc();

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  List<dynamic> transformTransactionsWithDateHeadings(
      List<Transaction> transactions) {
    final Map<String, List<Transaction>> groupedTransactions =
        groupTransactionsByDate(transactions);
    final List<dynamic> result = [];

    groupedTransactions.forEach((date, transactions) {
      result.add(date);
      result.addAll(transactions);
    });

    return result;
  }

  Map<String, List<Transaction>> groupTransactionsByDate(
      List<Transaction> transactions) {
    final Map<String, List<Transaction>> groupedTransactions = {};
    for (var transaction in transactions) {
      final String date =
          "${transaction.createdAt.day}-${transaction.createdAt.month}-${transaction.createdAt.year}";
      if (!groupedTransactions.containsKey(date)) {
        groupedTransactions[date] = [];
      }
      groupedTransactions[date]!.add(transaction);
    }
    return groupedTransactions;
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      print(pageKey.toString());
      appBloc.add(
          GetAllTransactionHistoryEvent('', '', '', '20', pageKey.toString()));
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;

    return Scaffold(
      body: Column(
        //crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const TransactionHistoryCustomAppBar(
            title: 'Transactions',
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: BlocConsumer<AppBloc, AppState>(
                bloc: appBloc,
                listener: (context, state) {
                  if (state is TransactionListSuccessState) {
                    final newItems = transformTransactionsWithDateHeadings(
                        state.transactionHistoryModel.data.items);
                    final isLastPage =
                        state.transactionHistoryModel.data.currentPage ==
                            state.transactionHistoryModel.data.totalPages;
                    if (isLastPage) {
                      _pagingController.appendLastPage(newItems);
                    } else {
                      final nextPageKey =
                          state.transactionHistoryModel.data.currentPage + 1;
                      _pagingController.appendPage(newItems, nextPageKey);
                    }
                  } else if (state is AccessTokenExpireState) {
                    _pagingController.error = "Access Token Expired";
                  } else if (state is TransactionErrorState) {
                    _pagingController.error = state.error;
                  }
                },
                builder: (context, state) {
                  return
                    PagedListView<int, dynamic>(
                      pagingController: _pagingController,
                      builderDelegate: PagedChildBuilderDelegate<dynamic>(
                        itemBuilder: (context, item, index) {
                          if (item is String) {
                            // This is a date heading
                            return Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: CustomText(
                                  text: AppUtils.formatComplexDate(dateTime: item),
                                  size: 14,
                                  weight: FontWeight.bold,
                                ),
                              ),
                            );
                          } else if (item is Transaction) {
                            // This is a transaction
                            final order = item.order;

                            return InkWell(
                              onTap: () {
                                AppNavigator.pushAndStackPage(
                                  context,
                                  page: TransactionReceipt(transaction: item),
                                );
                              },
                              child: SizedBox(
                                height: 90,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: item.order?.product?.name ?? (item.type.toLowerCase().contains('credit') ? 'Credit' : 'Debit'),
                                      size: 10,
                                      color: theme.isDark ? AppColors.darkModeBackgroundSubTextColor : AppColors.textColor,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundImage: order != null ? NetworkImage(order.product!.image) : null,
                                              child: order == null && (item.type.toLowerCase().contains('credit') || item.type.toLowerCase().contains('debit'))
                                                  ? Icon(
                                                item.type.toLowerCase().contains('credit') ? Icons.arrow_downward : Icons.arrow_upward,
                                                color: item.type.toLowerCase().contains('credit') ? AppColors.green : AppColors.red,
                                              )
                                                  : const SizedBox(),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Container(
                                                width: order?.requiredFields.phoneNumber != null ||
                                                    order?.requiredFields.meterNumber != null ||
                                                    order?.requiredFields.cardNumber != null
                                                    ? 70
                                                    : 0,
                                                decoration: BoxDecoration(
                                                  color: theme.isDark ? AppColors.darkGreen : AppColors.lightShadowGreenColor,
                                                  borderRadius: BorderRadius.circular(10),
                                                  border: Border.all(color: AppColors.green),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(5.0),
                                                  child: CustomText(
                                                    text: order?.requiredFields.meterNumber ?? order?.requiredFields.cardNumber ?? order?.requiredFields.phoneNumber ?? item.type,
                                                    size: 10,
                                                    color: theme.isDark ? AppColors.darkModeBackgroundMainTextColor : AppColors.textColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: theme.isDark ? AppColors.darkModeBackgroundContainerColor : AppColors.white,
                                                  borderRadius: BorderRadius.circular(10),
                                                  border: Border.all(color: AppColors.grey),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(5.0),
                                                  child: CustomText(
                                                    text: item.type.toLowerCase().contains('debit')
                                                        ? '-N${order?.requiredFields.amount ?? item.amount}'
                                                        : '+N${order?.requiredFields.amount ?? item.amount}',
                                                    size: 10,
                                                    color: theme.isDark ? AppColors.darkModeBackgroundMainTextColor : AppColors.textColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        CustomText(
                                          text: item.status.toLowerCase() == "success" ? "SUCCESSFUL" :item.status
                                              .toLowerCase() ==
                                              "failure"
                                              ? "FAILED" :item.status.toUpperCase(),
                                          color: item.status.toLowerCase() == 'success'
                                              ? AppColors.green
                                              : item.status.toLowerCase() == 'pending'
                                              ? Colors.yellow.shade800
                                              : AppColors.red,
                                          size: 10,
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                  ],
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    )
                  ;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
