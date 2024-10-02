class Reports {
  String? description;

  Reports({
    this.description,
  });

  factory Reports.fromJson(Map<String, dynamic> json) => Reports(
        description: json['description'],
      );


  Map<String, dynamic> toJson() => {
        'description': description,
      };
}
