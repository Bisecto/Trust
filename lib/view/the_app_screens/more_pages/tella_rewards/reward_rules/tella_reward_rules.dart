import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teller_trust/utills/app_utils.dart';

import '../../../../../utills/custom_theme.dart';

class RewardRulesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;

    return Container(
      child: SingleChildScrollView(
        child: RichText(
          text:  TextSpan(
            style: TextStyle(
              fontSize: 16.0,
              color: theme.isDark?Colors.white:Colors.black
            ),
            children: [
              TextSpan(
                text:
                    'Tella-Rewards Point Rules System and Redemption Criteria\n\n',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: 'Point Earning Rules:\n\n',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: '1. Referral Points:\n',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: '- New User Sign-Up: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text:
                    'Earn 100 Tella-Rewards points for each successful referral who signs up and completes their KYC.\n\n',
              ),
              TextSpan(
                text: '- First Transaction: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text:
                    'Earn an additional 50 Tella-Rewards points when your referral completes their first transaction.\n\n',
              ),
              TextSpan(
                text: '2. Transaction Points:\n',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: '- Daily Transactions: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text:
                    'Earn 1 Tella-Rewards point for every ₦100 spent on transactions using TellaTrust services (e.g., bill payments, wallet funding, etc.).\n\n',
              ),
              TextSpan(
                text: '- Monthly Bonus: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text:
                    'Earn a bonus of 500 Tella-Rewards points for completing transactions totaling ₦100,000 or more in a calendar month.\n\n',
              ),
              TextSpan(
                text: '3. Special Promotions:\n',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: '- Limited-Time Offers: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text:
                    'Earn double points during special promotional periods (e.g., festive seasons, company anniversaries).\n\n',
              ),
              TextSpan(
                text: '- Social Media Engagement: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text:
                    'Earn 20 Tella-Rewards points for each share or referral through social media platforms.\n\n',
              ),
              TextSpan(
                text: 'Redemption Criteria:\n\n',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: '1. Minimum Redemption Threshold:\n',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text:
                    '- Users can redeem their Tella-Rewards points once they have accumulated at least 1,000 points.\n\n',
              ),
              TextSpan(
                text: '2. Redemption Value:\n',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: '- 1,000 Tella-Rewards points = ₦500\n',
              ),
              TextSpan(
                text:
                    '- Redemption is possible in multiples of 1,000 points (e.g., 2,000 points = ₦1,000).\n\n',
              ),
              TextSpan(
                text: '3. Redemption Process:\n',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text:
                    '- Points can be redeemed directly within the TellaTrust app, and the equivalent value will be credited to the user’s wallet.\n\n',
              ),
              TextSpan(
                text: '4. Eligible Transactions:\n',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text:
                    '- Redeemed points can be used for any TellaTrust services, including bill payments, airtime purchases, and wallet funding.\n\n',
              ),
              TextSpan(
                text: '5. Expiration of Points:\n',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text:
                    '- Tella-Rewards points do not expire as long as the account is active. Accounts that are inactive for 12 months or more will forfeit any accumulated points.\n',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
