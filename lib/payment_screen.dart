import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:toast/toast.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _amountController;
  Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _razorpay = new Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
  }

  void handlerPaymentSuccess() {
    print("payment success");
    Toast.show("payment success", context);
    Navigator.pop(context);
  }

  void handlerErrorFailure() {
    print("payment failed");
    Toast.show("payment failed", context);
  }

  void handlerExternalWallet() {
    print("External Wallet");
    Toast.show("External Wallet", context);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment Integration"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 350,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Text(
                          "Razorpay Integration",
                          style: TextStyle(fontSize: 21),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: TextFormField(
                            controller: _amountController,
                            decoration:
                                InputDecoration(labelText: "Enter the amount"),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "please enter amount";
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        // ignore: deprecated_member_use
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          color: Colors.redAccent,
                          onPressed: () {
                            if (!_formKey.currentState.validate()) {
                              return;
                            }
                            _formKey.currentState.save();
                            var options = {
                              "key": "rzp_test_EHWMv4fkgbNe7R",
                              "amount": num.parse(_amountController.text) * 100,
                              "name": "Startup Projects",
                              "description": "Payment for our work",
                              "prefill": {
                                "contact": "7904435022",
                                "email": "mvel1620r@gmail.com",
                              },
                              "external": {
                                "wallets": ["paytm"],
                              },
                            };
                            try {
                              _razorpay.open(options);
                              _amountController.text = "";
                            } catch (e) {
                              print(e.toString());
                            }
                          },
                          child: Text(
                            "Pay Now",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
