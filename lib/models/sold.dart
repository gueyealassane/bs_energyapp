class Sold {
    int  quantite;
    String? carburant;
    int? prix_total;
    String? uidusers;
    String? uidclients;
    String? nomclient;
    DateTime? date;

    Sold({this.carburant,required this.quantite,required this.prix_total,this.uidclients,this.uidusers,required this.nomclient,this.date});

    Map<String, dynamic> toJson() => {
        'carburant': carburant,
        'quantite': quantite,
        'prix_total': prix_total,
        'uidclients': uidclients,
        'nomclient':nomclient,
        'uidusers': uidusers,
        'date':date,
    };

}

