# Regulations for getting SCS compatible certified:
As Operator, I want to achieve the Certificate SCS compatible.

1. SCS compatible certificates for the IaaS and KaaS layer MUST and CAN be achieved separately and WILL be labeled separately.
<!-- Add some further details regarding SCS-0003 and the layers defined there -->

2. Every granted certificate „SCS compatible“ expires after the corresponding standard version of this layer has been obsoleted. For that matter any certification referring to a particular version of SCS standards does not have a duration of validity, but a fixed expiry date, regardless when the certification has been achieved.

3. For achieving the certificate „SCS compatible“ an operator MUST include the official SCS compliance test suite in his continuous test infrastructure -- for public clouds the recommended way to achieve this is to offer the SCS project access to the infrastructure so the test suite runs can be triggered continously by the SCS team and ensure continuous compliance. For non-public clouds, the results (log files) can be submitted to SCS by a mechanism of SCS' choice and need to be reproduced again on request by SCS.
<!-- Initially this will probably be eMail -->
<!-- What happens when the tests fail? Who will be notified, will the certificate be revoked after a given amount of time? -->

4. The SCS certification assessment body (or entities empowered to do so) WILL review the certification application and either grant the certification, reject it or ask for further measures or information.
<!-- body might as well just be a machine, at least on the scs compatible level -->

5. After having received a confirmation of a successful achievement of a certificate „SCS compatible“ granted by the SCS certification assessment body, the operator MAY use the „SCS compatible“ logo and publicly state the certified „SCS compatibility“  on the respective layer for the time of the validity of the certification, i.e. until the version of standards get obsoleted. The logos will contain a link to SCS owned pages that contain details on the achieved standards, either by embedding a hyperlink or a QR code for printed assets.

<!-- Make clear that we – the SCS project – are allowed to test a cloud enviroment on request or request docs that prove the fulfillment of certification requirements -->
