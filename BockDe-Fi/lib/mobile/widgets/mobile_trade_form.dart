import 'package:flutter/material.dart';

class MobileTradeForm extends StatefulWidget {
  @override
  _MobileTradeFormState createState() => _MobileTradeFormState();
}

class _MobileTradeFormState extends State<MobileTradeForm> {
  bool isBuy = true;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color(0xFF1E2329),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFF0B0E11),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => isBuy = true),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isBuy ? Color(0xFF0ECB81) : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Buy',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isBuy ? Colors.white : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => isBuy = false),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: !isBuy ? Color(0xFFF6465D) : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Sell',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: !isBuy ? Colors.white : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                _buildInputField('Price', '\$43,250.00'),
                SizedBox(height: 12),
                _buildInputField('Amount', '0.00 BTC'),
                SizedBox(height: 12),
                _buildInputField('Total', '0.00 USDT'),
                SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isBuy ? Color(0xFF0ECB81) : Color(0xFFF6465D),
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text(
                      isBuy ? 'Buy BTC' : 'Sell BTC',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
        SizedBox(height: 4),
        TextField(
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Color(0xFF0B0E11),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }
}