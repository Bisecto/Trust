import 'package:flutter/material.dart';


class TransactionReceiptScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: Colors.black),
            onPressed: () {
              // Handle close action
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Icon(Icons.grass, size: 50, color: Colors.green), // Custom logo
                  Text(
                    'Transaction Receipt',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MTN NG VTU 234703583039',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('₦1,000.00', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('To', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text('07087865088', style: TextStyle(fontSize: 18, color: Colors.grey)),
                  SizedBox(height: 10),
                  Text('Payment Method', style: TextStyle(fontSize: 16)),
                  Text('Wallet Balance', style: TextStyle(fontSize: 18, color: Colors.grey)),
                  SizedBox(height: 10),
                  Text('Description', style: TextStyle(fontSize: 16)),
                  Text('Airtime Purchase to 07087865088', style: TextStyle(fontSize: 18, color: Colors.grey)),
                  SizedBox(height: 10),
                  Text('Date', style: TextStyle(fontSize: 16)),
                  Text('2023-11-25 06:47:36', style: TextStyle(fontSize: 18, color: Colors.grey)),
                  SizedBox(height: 20),
                  Divider(),
                  SizedBox(height: 10),
                  Text('Transaction Reference', style: TextStyle(fontSize: 16)),
                  Text('tella_purchase_65072539539454', style: TextStyle(fontSize: 18, color: Colors.grey)),
                  SizedBox(height: 10),
                  Text('Status', style: TextStyle(fontSize: 16)),
                  Text('Purchase Successful', style: TextStyle(fontSize: 18, color: Colors.green)),
                  SizedBox(height: 10),
                  Text('Session ID', style: TextStyle(fontSize: 16)),
                  Text('47240240248745340248480280', style: TextStyle(fontSize: 18, color: Colors.grey)),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      'Tella Trust',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.share, color: Colors.green),
                  onPressed: () {
                    // Handle share action
                  },
                ),
                IconButton(
                  icon: Icon(Icons.download, color: Colors.green),
                  onPressed: () {
                    // Handle download action
                  },
                ),
                IconButton(
                  icon: Icon(Icons.refresh, color: Colors.green),
                  onPressed: () {
                    // Handle repeat action
                  },
                ),
                IconButton(
                  icon: Icon(Icons.report, color: Colors.green),
                  onPressed: () {
                    // Handle report action
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Thank You!\nFor Your Purchase',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20),
            Text(
              'Secured by Tella Trust',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.greenAccent.shade100,
    );
  }
}
