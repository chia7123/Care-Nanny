import 'package:flutter_braintree/flutter_braintree.dart';

class Payment {

  Future<BraintreeDropInResult> paymentRequest({double price}) async {
    final request = BraintreeDropInRequest(
      tokenizationKey: 'sandbox_s9873d2v_g4cp8jkzys4q5vbk',
      collectDeviceData: true,
      paypalRequest: BraintreePayPalRequest(
        amount: price.toString(),
        currencyCode: 'MYR',
        displayName: 'CareNanny',
      ),
    );

    BraintreeDropInResult result = await BraintreeDropIn.start(request);

    return result;
  }

}
