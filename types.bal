// ===== Order workflow types =====

public type OrderInfo record {|
    string id;
    string customerEmail;
    decimal total;
|};

public type PaymentInfo record {|
    string status;
|};

public type OrderEvents record {|
    future<PaymentInfo> paymentInfo;
|};

public type OrderResult record {|
    string orderId;
    string status;
|};

// ===== Insurance claim workflow types =====

public type ClaimInfo record {|
    string filePath;
|};

public type ClaimDecision record {|
    string status;
    string reason?;
|};

public type ClaimResult record {|
    string status;
    string reason?;
|};

// ===== HTTP request payloads =====

public type PaymentNotification record {|
    string status;
|};
