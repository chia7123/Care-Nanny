class AdminView {
  final String title;

  const AdminView(
    this.title,
  );
}

class AdminViews {
  static const cl = AdminView('Confinement Lady');
  static const mother = AdminView('Mothers');
  static const cancel = AdminView('Cancel Order');
  static const onGoing = AdminView('On Going Order');
  static const completed = AdminView('Completed Order');
  static const pending = AdminView('Pending Order');
  static const declined = AdminView('Declined Order');

  static const all = <AdminView>[
    cl,
    mother,
    cancel,
    onGoing,
    completed,
    pending,
    declined
  ];
}
